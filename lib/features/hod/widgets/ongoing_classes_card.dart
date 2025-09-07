import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/liquid_glass.dart';
import '../models/hod_models.dart';

class OngoingClassesCard extends StatelessWidget {
  final List<OngoingClass> classes;
  final Function(String classId) onMessageFaculty;
  final Function(String classId) onEmergencyAction;

  const OngoingClassesCard({
    super.key,
    required this.classes,
    required this.onMessageFaculty,
    required this.onEmergencyAction,
  });

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return LiquidGlass(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.school_outlined,
                size: 48,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No classes in session',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All classes are completed or not yet started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LiquidGlass(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.live_tv,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Live Updates',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'AUTO-REFRESH',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...classes.map((classData) => _buildClassRow(context, classData)),
          ],
        ),
      ),
    );
  }

  Widget _buildClassRow(BuildContext context, OngoingClass classData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(classData.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classData.course,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${classData.section} • ${classData.semester} • ${classData.room}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildStatusChip(classData.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  classData.faculty ?? 'No faculty assigned',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: classData.faculty != null 
                        ? AppColors.textPrimary 
                        : Colors.red,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (classData.vacantMinutes != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    classData.vacantDisplay,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.info_outline,
                label: 'Details',
                onPressed: () {
                  // TODO: Show class details
                },
              ),
              const SizedBox(width: 8),
              if (classData.faculty != null)
                _buildActionButton(
                  icon: Icons.message_outlined,
                  label: 'Message',
                  onPressed: () => onMessageFaculty(classData.id),
                ),
              if (classData.status == ClassStatus.vacant) ...[
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.emergency,
                  label: 'Emergency Assign',
                  color: Colors.red,
                  onPressed: () => onEmergencyAction(classData.id),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ClassStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final buttonColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: buttonColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: buttonColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: buttonColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ClassStatus status) {
    switch (status) {
      case ClassStatus.onTime:
        return Colors.green;
      case ClassStatus.vacant:
        return Colors.red;
      case ClassStatus.delay:
        return Colors.orange;
      case ClassStatus.conflict:
        return Colors.purple;
      case ClassStatus.roomChange:
        return Colors.blue;
      case ClassStatus.lateStart:
        return Colors.amber;
      case ClassStatus.running:
        return Colors.lightGreen;
      case ClassStatus.scheduled:
        return Colors.grey;
      case ClassStatus.completed:
        return Colors.blueGrey;
    }
  }

  String _getStatusText(ClassStatus status) {
    switch (status) {
      case ClassStatus.onTime:
        return 'ON TIME';
      case ClassStatus.vacant:
        return 'VACANT';
      case ClassStatus.delay:
        return 'DELAYED';
      case ClassStatus.conflict:
        return 'CONFLICT';
      case ClassStatus.roomChange:
        return 'ROOM CHANGE';
      case ClassStatus.lateStart:
        return 'LATE START';
      case ClassStatus.running:
        return 'RUNNING';
      case ClassStatus.scheduled:
        return 'SCHEDULED';
      case ClassStatus.completed:
        return 'COMPLETED';
    }
  }
}
