import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/dashboard_scaffold.dart';
import '../dashboards/hostel_sec/hostel_sec_dashboard.dart';
import '../dashboards/mess/mess_sec/mess_sec_screen.dart';
import '../dashboards/wingsec/wingsec_attendance.dart';
import 'attendance/student_attendance_page.dart';
import 'complaint/complaint_home.dart';
import 'gate/gate_request_home.dart';
import 'mess/mess_home.dart';
import 'outgoing/outgoing_home.dart';
import 'profile/profile_page.dart';
import 'student_data.dart';

const _kBlue = Color(0xFF1565C0);
const _kBlueTint = Color(0xFFE8F0FE);
const _kBlueBorder = Color(0xFFBBD0F8);

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(StudentData.admissionNo)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final bool isWingSec = data['isWingSecretary'] == true;
        final bool isHostelSec = data['isHostelSecretary'] == true;
        final bool isMessSec = data['isMessSecretary'] == true;

        return DashboardScaffold(
          dashboardName: "Student Dashboard",
          userName: StudentData.name,
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(admissionNo: StudentData.admissionNo),
              ),
            );
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWingSec || isHostelSec || isMessSec) ...[
                _sectionLabel('My Roles'),
                const SizedBox(height: 10),
                if (isWingSec)
                  _RoleSwitchCard(
                    icon: Icons.groups_2_rounded,
                    label: 'Wing Secretary',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WingSecAttendancePage(),
                        ),
                      );
                    },
                  ),
                if (isWingSec && isHostelSec) const SizedBox(height: 10),
                if (isHostelSec)
                  _RoleSwitchCard(
                    icon: Icons.admin_panel_settings_rounded,
                    label: 'Hostel Secretary',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HostelSecretaryDashboard(),
                        ),
                      );
                    },
                  ),
                if ((isWingSec || isHostelSec) && isMessSec)
                  const SizedBox(height: 10),
                if (isMessSec)
                  _RoleSwitchCard(
                    icon: Icons.restaurant_menu_rounded,
                    label: 'Mess Secretary',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MessSecScreen(),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 28),
              ],
              _sectionLabel('Services'),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.05,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _DashboardServiceCard(
                    icon: Icons.arrow_outward,
                    title: "Outgoing",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OutgoingHome()),
                      );
                    },
                  ),
                  _DashboardServiceCard(
                    icon: Icons.warning_amber,
                    title: "Complaint",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ComplaintHome(),
                        ),
                      );
                    },
                  ),
                  _DashboardServiceCard(
                    icon: Icons.directions_walk,
                    title: "Gate\nRequest",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GateRequestHome(),
                        ),
                      );
                    },
                  ),
                  _DashboardServiceCard(
                    icon: Icons.calendar_month,
                    title: "My\nAttendance",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StudentAttendancePage(),
                        ),
                      );
                    },
                  ),
                  _DashboardServiceCard(
                    icon: Icons.restaurant_menu,
                    title: "Mess",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MessHomePage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
          letterSpacing: -0.2,
        ),
      );
}

class _DashboardServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardServiceCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _kBlueBorder, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x141565C0),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _kBlueTint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 28, color: _kBlue),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleSwitchCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RoleSwitchCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBlueBorder, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F1565C0),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _kBlueTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _kBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Switch to',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _kBlueTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: _kBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
