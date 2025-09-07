import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/liquid_glass.dart';
import '../models/hod_models.dart';
import '../repositories/approvals_repository.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage>
    with SingleTickerProviderStateMixin {
  final MockApprovalsRepository _approvalsRepo = MockApprovalsRepository();
  late TabController _tabController;
  
  List<LeaveRequest> _leaveRequests = [];
  List<SwapRequest> _swapRequests = [];
  bool _isLoading = true;
  String _selectedFilter = 'pending';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadApprovals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadApprovals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _approvalsRepo.getLeaveRequests(),
        _approvalsRepo.getSwapRequests(),
      ]);

      setState(() {
        _leaveRequests = results[0] as List<LeaveRequest>;
        _swapRequests = results[1] as List<SwapRequest>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load approvals: $e');
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

  Future<void> _approveLeaveRequest(String requestId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        final index = _leaveRequests.indexWhere((r) => r.id == requestId);
        if (index != -1) {
          _leaveRequests[index] = LeaveRequest(
            id: _leaveRequests[index].id,
            facultyId: _leaveRequests[index].facultyId,
            facultyName: _leaveRequests[index].facultyName,
            startDate: _leaveRequests[index].startDate,
            endDate: _leaveRequests[index].endDate,
            reason: _leaveRequests[index].reason,
            status: LeaveStatus.approved,
            affectedClasses: _leaveRequests[index].affectedClasses,
            impactCount: _leaveRequests[index].impactCount,
            hasAttachments: _leaveRequests[index].hasAttachments,
            requestedAt: _leaveRequests[index].requestedAt,
            submittedAt: _leaveRequests[index].submittedAt,
            priority: _leaveRequests[index].priority,
          );
        }
      });
      
      _showSuccessSnackBar('Leave request approved');
    } catch (e) {
      _showErrorSnackBar('Failed to approve request');
    }
  }

  Future<void> _rejectLeaveRequest(String requestId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        final index = _leaveRequests.indexWhere((r) => r.id == requestId);
        if (index != -1) {
          _leaveRequests[index] = LeaveRequest(
            id: _leaveRequests[index].id,
            facultyId: _leaveRequests[index].facultyId,
            facultyName: _leaveRequests[index].facultyName,
            startDate: _leaveRequests[index].startDate,
            endDate: _leaveRequests[index].endDate,
            reason: _leaveRequests[index].reason,
            status: LeaveStatus.rejected,
            affectedClasses: _leaveRequests[index].affectedClasses,
            impactCount: _leaveRequests[index].impactCount,
            hasAttachments: _leaveRequests[index].hasAttachments,
            requestedAt: _leaveRequests[index].requestedAt,
            submittedAt: _leaveRequests[index].submittedAt,
            priority: _leaveRequests[index].priority,
          );
        }
      });
      
      _showSuccessSnackBar('Leave request rejected');
    } catch (e) {
      _showErrorSnackBar('Failed to reject request');
    }
  }

  Future<void> _approveSwapRequest(String requestId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        final index = _swapRequests.indexWhere((r) => r.id == requestId);
        if (index != -1) {
          _swapRequests[index] = SwapRequest(
            id: _swapRequests[index].id,
            requesterId: _swapRequests[index].requesterId,
            requesterName: _swapRequests[index].requesterName,
            targetFacultyId: _swapRequests[index].targetFacultyId,
            targetFacultyName: _swapRequests[index].targetFacultyName,
            requesterSlot: _swapRequests[index].requesterSlot,
            targetSlot: _swapRequests[index].targetSlot,
            requestedDate: _swapRequests[index].requestedDate,
            reason: _swapRequests[index].reason,
            status: SubstitutionStatus.approved,
            impactCount: _swapRequests[index].impactCount,
            requestedAt: _swapRequests[index].requestedAt,
            priority: _swapRequests[index].priority,
          );
        }
      });
      
      _showSuccessSnackBar('Swap request approved');
    } catch (e) {
      _showErrorSnackBar('Failed to approve request');
    }
  }

  Future<void> _rejectSwapRequest(String requestId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        final index = _swapRequests.indexWhere((r) => r.id == requestId);
        if (index != -1) {
          _swapRequests[index] = SwapRequest(
            id: _swapRequests[index].id,
            requesterId: _swapRequests[index].requesterId,
            requesterName: _swapRequests[index].requesterName,
            targetFacultyId: _swapRequests[index].targetFacultyId,
            targetFacultyName: _swapRequests[index].targetFacultyName,
            requesterSlot: _swapRequests[index].requesterSlot,
            targetSlot: _swapRequests[index].targetSlot,
            requestedDate: _swapRequests[index].requestedDate,
            reason: _swapRequests[index].reason,
            status: SubstitutionStatus.rejected,
            impactCount: _swapRequests[index].impactCount,
            requestedAt: _swapRequests[index].requestedAt,
            priority: _swapRequests[index].priority,
          );
        }
      });
      
      _showSuccessSnackBar('Swap request rejected');
    } catch (e) {
      _showErrorSnackBar('Failed to reject request');
    }
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
                        Icons.pending_actions,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Approvals',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Filter Chips
                  LiquidGlass(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(child: _buildFilterChip('Pending', 'pending')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildFilterChip('Approved', 'approved')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildFilterChip('Rejected', 'rejected')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tab Bar
                  LiquidGlass(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'Leave Requests'),
                          Tab(text: 'Swap Requests'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _isLoading 
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLeaveRequestsList(),
                        _buildSwapRequestsList(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveRequestsList() {
    final filteredRequests = _leaveRequests.where((request) {
      switch (_selectedFilter) {
        case 'pending':
          return request.status == LeaveStatus.pending;
        case 'approved':
          return request.status == LeaveStatus.approved;
        case 'rejected':
          return request.status == LeaveStatus.rejected;
        default:
          return true;
      }
    }).toList();

    if (filteredRequests.isEmpty) {
      return _buildEmptyState('No leave requests found');
    }

    return RefreshIndicator(
      onRefresh: _loadApprovals,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filteredRequests.length,
        itemBuilder: (context, index) {
          final request = filteredRequests[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildLeaveRequestCard(request),
          );
        },
      ),
    );
  }

  Widget _buildSwapRequestsList() {
    final filteredRequests = _swapRequests.where((request) {
      switch (_selectedFilter) {
        case 'pending':
          return request.status == SubstitutionStatus.pending;
        case 'approved':
          return request.status == SubstitutionStatus.approved;
        case 'rejected':
          return request.status == SubstitutionStatus.rejected;
        default:
          return true;
      }
    }).toList();

    if (filteredRequests.isEmpty) {
      return _buildEmptyState('No swap requests found');
    }

    return RefreshIndicator(
      onRefresh: _loadApprovals,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filteredRequests.length,
        itemBuilder: (context, index) {
          final request = filteredRequests[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildSwapRequestCard(request),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestCard(LeaveRequest request) {
    return LiquidGlass(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LEAVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.status.displayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(request.status),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Faculty Info
            Text(
              request.facultyName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Leave Details
            Text(
              '${request.startDate} - ${request.endDate}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Reason
            Text(
              request.reason,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            // Action Buttons (only for pending requests)
            if (request.status == LeaveStatus.pending) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Reject',
                      Icons.close,
                      Colors.red,
                      () => _rejectLeaveRequest(request.id),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Approve',
                      Icons.check,
                      Colors.green,
                      () => _approveLeaveRequest(request.id),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSwapRequestCard(SwapRequest request) {
    return LiquidGlass(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'SWAP',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSwapStatusColor(request.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.status.displayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getSwapStatusColor(request.status),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Faculty Exchange
            Text(
              '${request.requesterName} ↔ ${request.targetFacultyName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Slot Details
            Text(
              '${request.requesterSlot} → ${request.targetSlot}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Reason
            Text(
              request.reason,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            // Action Buttons (only for pending requests)
            if (request.status == SubstitutionStatus.pending) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Reject',
                      Icons.close,
                      Colors.red,
                      () => _rejectSwapRequest(request.id),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Approve',
                      Icons.check,
                      Colors.green,
                      () => _approveSwapRequest(request.id),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return Colors.orange;
      case LeaveStatus.approved:
        return Colors.green;
      case LeaveStatus.rejected:
        return Colors.red;
    }
  }

  Color _getSwapStatusColor(SubstitutionStatus status) {
    switch (status) {
      case SubstitutionStatus.pending:
        return Colors.orange;
      case SubstitutionStatus.accepted:
        return Colors.lightGreen;
      case SubstitutionStatus.declined:
        return Colors.redAccent;
      case SubstitutionStatus.noResponse:
        return Colors.grey;
      case SubstitutionStatus.manualOverride:
        return Colors.purple;
      case SubstitutionStatus.approved:
        return Colors.green;
      case SubstitutionStatus.rejected:
        return Colors.red;
      case SubstitutionStatus.active:
        return Colors.blue;
      case SubstitutionStatus.completed:
        return Colors.grey;
    }
  }
}
