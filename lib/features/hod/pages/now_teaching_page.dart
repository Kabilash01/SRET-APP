import 'package:flutter/material.dart';
import 'dart:async';
import '../../../theme/app_theme.dart';
import '../../../widgets/liquid_glass.dart';
import '../models/hod_models.dart';
import '../repositories/dept_repository.dart';
import '../widgets/ongoing_classes_card.dart';

class NowTeachingPage extends StatefulWidget {
  const NowTeachingPage({super.key});

  @override
  State<NowTeachingPage> createState() => _NowTeachingPageState();
}

class _NowTeachingPageState extends State<NowTeachingPage>
    with TickerProviderStateMixin {
  final MockDeptRepository _deptRepo = MockDeptRepository();
  List<OngoingClass> _allClasses = [];
  List<OngoingClass> _filteredClasses = [];
  bool _isLoading = true;
  Timer? _refreshTimer;
  late AnimationController _pulseController;
  ClassStatus? _selectedFilter;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController.repeat(reverse: true);
    _loadOngoingClasses();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadOngoingClasses();
    });
  }

  Future<void> _loadOngoingClasses() async {
    try {
      final classes = await _deptRepo.getOngoingClasses();
      setState(() {
        _allClasses = classes;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load classes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredClasses = _allClasses.where((classItem) {
        final matchesStatus = _selectedFilter == null || classItem.status == _selectedFilter;
        final matchesSearch = _searchQuery.isEmpty ||
            classItem.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (classItem.facultyName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
            classItem.room.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesStatus && matchesSearch;
      }).toList();
    });
  }

  void _onFilterChanged(ClassStatus? status) {
    setState(() {
      _selectedFilter = status;
      _applyFilters();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
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
                        Icons.school,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Now Teaching',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Live indicator
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green.withOpacity(
                                      0.3 + (_pulseController.value * 0.7),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'LIVE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Search Bar
                  LiquidGlass(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search by subject, faculty, or room...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : null,
                        ),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Filter Chips
                  LiquidGlass(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All', null),
                            const SizedBox(width: 8),
                            _buildFilterChip('Running', ClassStatus.running),
                            const SizedBox(width: 8),
                            _buildFilterChip('Vacant', ClassStatus.vacant),
                            const SizedBox(width: 8),
                            _buildFilterChip('Scheduled', ClassStatus.scheduled),
                            const SizedBox(width: 8),
                            _buildFilterChip('Completed', ClassStatus.completed),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Classes List
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildClassesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ClassStatus? status) {
    final isSelected = _selectedFilter == status;
    return GestureDetector(
      onTap: () => _onFilterChanged(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.outline.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildClassesList() {
    if (_filteredClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.school_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'No classes found'
                  : 'No classes available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Try adjusting your search or filter'
                  : 'All classes may have ended for today',
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
      onRefresh: _loadOngoingClasses,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filteredClasses.length,
        itemBuilder: (context, index) {
          final classItem = _filteredClasses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: OngoingClassesCard(
              classes: [classItem],
              onMessageFaculty: (classId) {
                // TODO: Implement messaging functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Messaging feature coming soon'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              onEmergencyAction: (classId) {
                // TODO: Navigate to manual allocation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Emergency allocation feature coming soon'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
