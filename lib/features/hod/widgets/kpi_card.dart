import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/liquid_glass.dart';
import '../models/hod_models.dart';

class KpiCard extends StatelessWidget {
  final DashboardKPIs kpis;
  final VoidCallback? onTapOngoing;
  final VoidCallback? onTapApprovals;

  const KpiCard({
    super.key,
    required this.kpis,
    this.onTapOngoing,
    this.onTapApprovals,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Department Health',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildKpiItem(
                    icon: Icons.school_outlined,
                    value: kpis.ongoingClasses.toString(),
                    label: 'Ongoing Classes',
                    onTap: onTapOngoing,
                  ),
                ),
                Expanded(
                  child: _buildKpiItem(
                    icon: Icons.people_outline,
                    value: kpis.freeFaculty.toString(),
                    label: 'Free Faculty',
                  ),
                ),
                Expanded(
                  child: _buildKpiItem(
                    icon: Icons.event_busy_outlined,
                    value: kpis.vacantSlots.toString(),
                    label: 'Vacant Slots',
                    hasAlert: kpis.vacantSlots > 0,
                  ),
                ),
                Expanded(
                  child: _buildKpiItem(
                    icon: Icons.pending_actions_outlined,
                    value: kpis.pendingApprovals.toString(),
                    label: 'Pending Approvals',
                    badge: kpis.overdueApprovals > 0 ? '${kpis.overdueApprovals} overdue' : null,
                    onTap: onTapApprovals,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiItem({
    required IconData icon,
    required String value,
    required String label,
    String? badge,
    bool hasAlert = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: onTap != null 
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: onTap != null 
              ? Border.all(color: AppColors.primary.withOpacity(0.2))
              : null,
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: hasAlert 
                        ? Colors.orange.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: hasAlert ? Colors.orange : AppColors.primary,
                    size: 22,
                  ),
                ),
                if (hasAlert)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: hasAlert ? Colors.orange : AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
