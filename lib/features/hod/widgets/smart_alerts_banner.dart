import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../models/hod_models.dart';

class SmartAlertsBanner extends StatefulWidget {
  final List<OngoingClass> ongoingClasses;
  final List<LeaveRequest> leaveRequests;
  final List<SwapRequest> swapRequests;
  final Function() onDismissAll;
  final Function(String alertType, String? data) onAlertAction;

  const SmartAlertsBanner({
    super.key,
    required this.ongoingClasses,
    required this.leaveRequests,
    required this.swapRequests,
    required this.onDismissAll,
    required this.onAlertAction,
  });

  @override
  State<SmartAlertsBanner> createState() => _SmartAlertsBannerState();
}

class _SmartAlertsBannerState extends State<SmartAlertsBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  final Set<String> _dismissedAlerts = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alerts = _generateAlerts();
    final visibleAlerts = alerts.where((alert) => !_dismissedAlerts.contains(alert.id)).toList();

    if (visibleAlerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: visibleAlerts.map((alert) => _buildAlertCard(alert)).toList(),
      ),
    );
  }

  List<SmartAlert> _generateAlerts() {
    final alerts = <SmartAlert>[];

    // Critical: Vacant classes requiring immediate attention
    final vacantClasses = widget.ongoingClasses
        .where((c) => c.status == ClassStatus.vacant)
        .toList();
    
    if (vacantClasses.isNotEmpty) {
      alerts.add(SmartAlert(
        id: 'vacant_classes',
        type: AlertType.critical,
        title: 'Classes Need Immediate Coverage',
        message: '${vacantClasses.length} class${vacantClasses.length > 1 ? 'es' : ''} currently vacant',
        actionLabel: 'Assign Faculty',
        actionData: 'vacant_classes',
        icon: Icons.warning,
      ));
    }

    // Warning: Classes starting soon without faculty
    final upcomingVacant = widget.ongoingClasses
        .where((c) => c.status == ClassStatus.scheduled && _isStartingSoon(c.startTime))
        .toList();
    
    if (upcomingVacant.isNotEmpty) {
      alerts.add(SmartAlert(
        id: 'upcoming_vacant',
        type: AlertType.warning,
        title: 'Classes Starting Soon',
        message: '${upcomingVacant.length} class${upcomingVacant.length > 1 ? 'es' : ''} starting in 15 minutes without assigned faculty',
        actionLabel: 'Quick Assign',
        actionData: 'upcoming_vacant',
        icon: Icons.schedule,
      ));
    }

    // Urgent: Pending approvals for tomorrow
    final urgentLeave = widget.leaveRequests
        .where((r) => r.status == LeaveStatus.pending && _isUrgent(r.startDate))
        .toList();
    
    if (urgentLeave.isNotEmpty) {
      alerts.add(SmartAlert(
        id: 'urgent_leave',
        type: AlertType.urgent,
        title: 'Urgent Leave Approvals',
        message: '${urgentLeave.length} leave request${urgentLeave.length > 1 ? 's' : ''} for tomorrow pending approval',
        actionLabel: 'Review Now',
        actionData: 'urgent_leave',
        icon: Icons.pending_actions,
      ));
    }

    // Info: Faculty availability insights
    final runningLate = widget.ongoingClasses
        .where((c) => c.status == ClassStatus.running && _isRunningLate(c.startTime))
        .toList();
    
    if (runningLate.isNotEmpty) {
      alerts.add(SmartAlert(
        id: 'running_late',
        type: AlertType.info,
        title: 'Classes Running Over Time',
        message: '${runningLate.length} class${runningLate.length > 1 ? 'es' : ''} extended beyond scheduled time',
        actionLabel: 'Monitor',
        actionData: 'running_late',
        icon: Icons.access_time,
      ));
    }

    return alerts;
  }

  Widget _buildAlertCard(SmartAlert alert) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Transform.scale(
            scale: alert.type == AlertType.critical ? _pulseAnimation.value : 1.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getAlertColor(alert.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getAlertColor(alert.type).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: alert.type == AlertType.critical
                    ? [
                        BoxShadow(
                          color: _getAlertColor(alert.type).withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getAlertColor(alert.type).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      alert.icon,
                      color: _getAlertColor(alert.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _getAlertColor(alert.type),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getAlertColor(alert.type).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                alert.type.displayName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getAlertColor(alert.type),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert.message,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onAlertAction(alert.type.displayName, alert.actionData);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _getAlertColor(alert.type),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            alert.actionLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _dismissedAlerts.add(alert.id);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.outline.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.critical:
        return Colors.red;
      case AlertType.urgent:
        return Colors.orange;
      case AlertType.warning:
        return Colors.amber;
      case AlertType.info:
        return Colors.blue;
    }
  }

  bool _isStartingSoon(String startTime) {
    try {
      final now = DateTime.now();
      final classStart = _parseTimeToday(startTime);
      final difference = classStart.difference(now).inMinutes;
      return difference > 0 && difference <= 15;
    } catch (e) {
      return false;
    }
  }

  bool _isUrgent(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      return date.year == tomorrow.year &&
             date.month == tomorrow.month &&
             date.day == tomorrow.day;
    } catch (e) {
      return false;
    }
  }

  bool _isRunningLate(String startTime) {
    try {
      final now = DateTime.now();
      final classStart = _parseTimeToday(startTime);
      final expectedEnd = classStart.add(const Duration(minutes: 50)); // Assuming 50min classes
      return now.isAfter(expectedEnd);
    } catch (e) {
      return false;
    }
  }

  DateTime _parseTimeToday(String timeStr) {
    final now = DateTime.now();
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

class SmartAlert {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final String actionLabel;
  final String? actionData;
  final IconData icon;

  SmartAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.actionLabel,
    this.actionData,
    required this.icon,
  });
}

enum AlertType {
  critical,
  urgent,
  warning,
  info;

  String get displayName {
    switch (this) {
      case AlertType.critical:
        return 'Critical';
      case AlertType.urgent:
        return 'Urgent';
      case AlertType.warning:
        return 'Warning';
      case AlertType.info:
        return 'Info';
    }
  }
}
