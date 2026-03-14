import 'package:flutter/material.dart';

import '../core/dashboard_scaffold.dart';
import '../staff/profile/staff_profile_page.dart';

import 'student_list_page.dart';
import 'request_list_page.dart';
import 'rt_complaint_list_page.dart';

import 'emergency/emergency_page.dart';
import 'matron/send_notification_page.dart';

class RTDashboard extends StatelessWidget {
  const RTDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      dashboardName: "RT Dashboard",
      userName: "Fahmi Sara",

      onProfileTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const StaffProfilePage(userId: "rt@nila"),
          ),
        );
      },

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Services",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A6B52),
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            children: [
              _serviceTile(
                context,
                icon: Icons.people,
                title: "Student Records",
                page: const StudentListPage(),
              ),
              _serviceTile(
                context,
                icon: Icons.report_problem,
                title: "Requests & Complaints",
                page: _RequestsComplaintsMenu(),
              ),
              _serviceTile(
                context,
                icon: Icons.warning,
                title: "Emergency Alerts",
                page: const EmergencyPage(),
              ),
              _serviceTile(
                context,
                icon: Icons.notifications,
                title: "Send Notification",
                page: const SendNotificationPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF3A6B52)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A6B52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Requests & Complaints menu (Complaints removed — handled by RT complaint page) ──
class _RequestsComplaintsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Requests & Complaints")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: const Text("View Requests"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RequestListPage()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("View Complaints"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RtComplaintListPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
