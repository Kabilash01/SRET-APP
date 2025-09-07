import '../models/hod_models.dart';

abstract class AnnouncementsRepository {
  Future<List<Announcement>> getSentAnnouncements();
  Future<void> sendAnnouncement(Announcement announcement);
  Future<void> expireAnnouncement(String id);
}

class MockAnnouncementsRepository implements AnnouncementsRepository {
  @override
  Future<List<Announcement>> getSentAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    return [
      Announcement(
        id: '1',
        title: 'Holiday Notice - Gandhi Jayanti',
        content: 'Please note that the college will remain closed on October 2nd in observance of Gandhi Jayanti. Regular classes will resume on October 3rd.',
        priority: Priority.high,
        createdAt: now.subtract(const Duration(days: 2)),
        expiresAt: now.add(const Duration(days: 5)),
        targetGroups: ['All Faculty', 'All Students'],
        views: 245,
      ),
      Announcement(
        id: '2',
        title: 'Faculty Meeting - Department Review',
        content: 'Mandatory faculty meeting scheduled for Friday 3:00 PM in Conference Hall. Agenda includes semester review and upcoming accreditation preparations.',
        priority: Priority.medium,
        createdAt: now.subtract(const Duration(hours: 6)),
        expiresAt: now.add(const Duration(days: 2)),
        targetGroups: ['CSE Faculty'],
        views: 18,
      ),
      Announcement(
        id: '3',
        title: 'System Maintenance Window',
        content: 'The academic portal will be under maintenance tonight from 11 PM to 6 AM. Please complete any pending submissions before the maintenance window.',
        priority: Priority.urgent,
        createdAt: now.subtract(const Duration(hours: 1)),
        expiresAt: now.add(const Duration(hours: 12)),
        targetGroups: ['All Users'],
        views: 89,
      ),
    ];
  }

  @override
  Future<void> sendAnnouncement(Announcement announcement) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // TODO: Implement actual announcement sending logic
  }

  @override
  Future<void> expireAnnouncement(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: Implement expiration logic
  }
}
