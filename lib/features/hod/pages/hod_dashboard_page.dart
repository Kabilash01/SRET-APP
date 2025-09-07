import 'package:flutter/material.dart';
import 'dart:async';
import '../../../theme/app_theme.dart';
import '../../../widgets/liquid_glass.dart';
import '../../../widgets/glass_pill_nav.dart';
import '../models/hod_models.dart';
import '../repositories/dept_repository.dart';
import '../repositories/approvals_repository.dart';
import '../widgets/kpi_card.dart';
import '../widgets/ongoing_classes_card.dart';
import '../widgets/free_faculty_card.dart';
import '../widgets/pending_approvals_card.dart';
import '../widgets/smart_alerts_banner.dart';
import 'now_teaching_page.dart';
import 'approvals_page.dart';
import 'manual_allocation_page.dart';

class HodDashboardPage extends StatefulWidget {
  const HodDashboardPage({super.key});

  @override
  State<HodDashboardPage> createState() => _HodDashboardPageState();
}

class _HodDashboardPageState extends State<HodDashboardPage> 
    with GlassPillNavMixin, TickerProviderStateMixin {
  
  @override
  int get selectedNavIndex => 3; // Dept tab index

  final DeptRepository _deptRepo = MockDeptRepository();
  final ApprovalsRepository _approvalsRepo = MockApprovalsRepository();
  
  DashboardKPIs? _kpis;
  List<OngoingClass> _ongoingClasses = [];
  List<FreeFaculty> _freeFaculty = [];
  List<LeaveRequest> _leaveRequests = [];
  List<SwapRequest> _swapRequests = [];
  
  bool _isLoading = true;
  Timer? _refreshTimer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _loadDashboardData();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _refreshOngoingClasses();
    });
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _deptRepo.getDashboardKPIs(),
        _deptRepo.getOngoingClasses(),
        _deptRepo.getFreeFaculty(),
        _approvalsRepo.getLeaveRequests(),
        _approvalsRepo.getSwapRequests(),
      ]);

      setState(() {
        _kpis = results[0] as DashboardKPIs;
        _ongoingClasses = results[1] as List<OngoingClass>;
        _freeFaculty = results[2] as List<FreeFaculty>;
        _leaveRequests = results[3] as List<LeaveRequest>;
        _swapRequests = results[4] as List<SwapRequest>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load dashboard data');
    }
  }

  Future<void> _refreshOngoingClasses() async {
    try {
      final classes = await _deptRepo.getOngoingClasses();
      setState(() {
        _ongoingClasses = classes;
      });
    } catch (e) {
      // Silent fail for background refresh
    }
  }

  Future<void> _handleRefresh() async {
    await _loadDashboardData();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      ),
    );
  }

  void _navigateToNowTeaching() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NowTeachingPage()),
    );
  }

  void _navigateToApprovals() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ApprovalsPage()),
    );
  }

  void _navigateToManualAllocation([String? vacancyId]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManualAllocationPage(vacancyId: vacancyId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // Main content
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  floating: true,
                  pinned: false,
                  title: Row(
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'HOD Dashboard',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  actions: [
                    // Live indicator
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.only(right: 16),
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
                
                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Smart Alerts
                        if (!_isLoading) ...[
                          SmartAlertsBanner(
                            ongoingClasses: _ongoingClasses,
                            leaveRequests: _leaveRequests,
                            swapRequests: _swapRequests,
                            onDismissAll: () {
                              // TODO: Implement dismiss all functionality
                            },
                            onAlertAction: (alertType, data) {
                              switch (alertType.toLowerCase()) {
                                case 'critical':
                                case 'vacant_classes':
                                  _navigateToManualAllocation();
                                  break;
                                case 'urgent':
                                case 'urgent_leave':
                                  _navigateToApprovals();
                                  break;
                                default:
                                  _navigateToNowTeaching();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],

                        // KPI Cards
                        if (_isLoading)
                          _buildLoadingSkeleton()
                        else if (_kpis != null)
                          KpiCard(
                            kpis: _kpis!,
                            onTapOngoing: _navigateToNowTeaching,
                            onTapApprovals: _navigateToApprovals,
                          ),

                        const SizedBox(height: 24),

                        // Ongoing Classes
                        if (!_isLoading) ...[
                          _buildSectionHeader('Ongoing Classes (Now Teaching)', 
                            onViewAll: _navigateToNowTeaching),
                          const SizedBox(height: 12),
                          OngoingClassesCard(
                            classes: _ongoingClasses.take(3).toList(),
                            onMessageFaculty: (classId) {
                              // TODO: Implement messaging
                              _showErrorSnackBar('Messaging feature coming soon');
                            },
                            onEmergencyAction: (classId) {
                              final vacancy = _ongoingClasses
                                  .firstWhere((c) => c.id == classId);
                              if (vacancy.status == ClassStatus.vacant) {
                                _navigateToManualAllocation(classId);
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Free Faculty
                        if (!_isLoading) ...[
                          _buildSectionHeader('Free Faculty'),
                          const SizedBox(height: 12),
                          FreeFacultyCard(
                            faculty: _freeFaculty.take(4).toList(),
                            onSelectFaculty: (facultyIds) {
                              // TODO: Handle multi-select for batch assignment
                              _showErrorSnackBar('Multi-select assignment coming soon');
                            },
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Pending Approvals
                        if (!_isLoading) ...[
                          _buildSectionHeader('Pending Approvals', 
                            onViewAll: _navigateToApprovals),
                          const SizedBox(height: 12),
                          PendingApprovalsCard(
                            leaveRequests: _leaveRequests,
                            swapRequests: _swapRequests,
                            onApprove: (requestId, type) {
                              // TODO: Implement approval logic
                              _showErrorSnackBar('${type.toUpperCase()} request approved');
                            },
                            onReject: (requestId, type) {
                              // TODO: Implement rejection logic
                              _showErrorSnackBar('${type.toUpperCase()} request rejected');
                            },
                          ),
                        ],

                        const SizedBox(height: 120), // Bottom navigation space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Glass pill navigation overlay
          GlassPillNav(
            selectedIndex: selectedNavIndex,
            onItemTapped: handleNavTap,
            items: GlassPillNavMixin.navItems,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onViewAll != null) ...[
          const SizedBox(width: 8),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return LiquidGlass(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
