import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/liquid_glass.dart';
import '../models/hod_models.dart';
import '../repositories/dept_repository.dart';

class ManualAllocationPage extends StatefulWidget {
  final String? vacancyId;
  
  const ManualAllocationPage({super.key, this.vacancyId});

  @override
  State<ManualAllocationPage> createState() => _ManualAllocationPageState();
}

class _ManualAllocationPageState extends State<ManualAllocationPage> {
  final MockDeptRepository _deptRepo = MockDeptRepository();
  List<OngoingClass> _vacantClasses = [];
  List<FreeFaculty> _availableFaculty = [];
  bool _isLoading = true;
  String? _selectedVacancyId;
  String? _selectedFacultyId;
  final Map<String, String> _assignments = {};

  @override
  void initState() {
    super.initState();
    _selectedVacancyId = widget.vacancyId;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _deptRepo.getOngoingClasses(),
        _deptRepo.getFreeFaculty(),
      ]);

      setState(() {
        _vacantClasses = (results[0] as List<OngoingClass>)
            .where((c) => c.status == ClassStatus.vacant)
            .toList();
        _availableFaculty = results[1] as List<FreeFaculty>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load data: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _assignFaculty(String vacancyId, String facultyId) {
    setState(() {
      _assignments[vacancyId] = facultyId;
    });
    
    final vacancy = _vacantClasses.firstWhere((c) => c.id == vacancyId);
    final faculty = _availableFaculty.firstWhere((f) => f.id == facultyId);
    
    _showSuccessSnackBar('${faculty.name} assigned to ${vacancy.subject} (${vacancy.room})');
  }

  void _removeAssignment(String vacancyId) {
    setState(() {
      _assignments.remove(vacancyId);
    });
  }

  void _executeAllAssignments() {
    if (_assignments.isEmpty) {
      _showErrorSnackBar('No assignments to execute');
      return;
    }

    // TODO: Implement actual assignment execution
    _showSuccessSnackBar('${_assignments.length} assignment(s) executed successfully');
    
    // Clear assignments and refresh data
    setState(() {
      _assignments.clear();
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Title Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.assignment_ind,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Manual Allocation',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (_assignments.isNotEmpty)
                        GestureDetector(
                          onTap: _executeAllAssignments,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Execute ${_assignments.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Stats
                  LiquidGlass(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              'Vacant Classes',
                              _vacantClasses.length.toString(),
                              Icons.warning_amber,
                              Colors.red,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.outline.withOpacity(0.2),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Available Faculty',
                              _availableFaculty.length.toString(),
                              Icons.people,
                              Colors.green,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.outline.withOpacity(0.2),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Assignments',
                              _assignments.length.toString(),
                              Icons.assignment_turned_in,
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildAllocationContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildAllocationContent() {
    if (_vacantClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Vacant Classes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All classes are currently covered',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _vacantClasses.length,
        itemBuilder: (context, index) {
          final vacancy = _vacantClasses[index];
          final isAssigned = _assignments.containsKey(vacancy.id);
          final assignedFacultyId = _assignments[vacancy.id];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildVacancyCard(vacancy, isAssigned, assignedFacultyId),
          );
        },
      ),
    );
  }

  Widget _buildVacancyCard(OngoingClass vacancy, bool isAssigned, String? assignedFacultyId) {
    final assignedFaculty = assignedFacultyId != null 
        ? _availableFaculty.firstWhere((f) => f.id == assignedFacultyId)
        : null;
    
    return LiquidGlass(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vacancy Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vacancy.subject,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${vacancy.startTime} - ${vacancy.endTime} • ${vacancy.room}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'VACANT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            
            if (isAssigned && assignedFaculty != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assigned: ${assignedFaculty.name}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            assignedFaculty.department,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeAssignment(vacancy.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              const Text(
                'Select Faculty:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ..._availableFaculty.map((faculty) => _buildFacultyOption(vacancy.id, faculty)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFacultyOption(String vacancyId, FreeFaculty faculty) {
    return GestureDetector(
      onTap: () => _assignFaculty(vacancyId, faculty.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faculty.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${faculty.department} • ${faculty.proximity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
