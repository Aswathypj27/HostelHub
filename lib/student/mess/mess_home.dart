import 'package:flutter/material.dart';

import '../../core/complaint_theme.dart';
import '../complaint/complaint_home.dart';

class MessHomePage extends StatelessWidget {
  const MessHomePage({super.key});

  static const _weeklyMenu = <Map<String, String>>[
    {
      'day': 'Monday',
      'breakfast': 'Idli + Sambar',
      'lunch': 'Rice, Dal, Vegetable Curry',
      'dinner': 'Chapati + Paneer Curry',
    },
    {
      'day': 'Tuesday',
      'breakfast': 'Dosa + Chutney',
      'lunch': 'Jeera Rice + Rajma',
      'dinner': 'Paratha + Egg Curry',
    },
    {
      'day': 'Wednesday',
      'breakfast': 'Upma + Tea',
      'lunch': 'Rice + Sambar + Thoran',
      'dinner': 'Chapati + Chicken Curry',
    },
  ];

  static const _duties = <String>[
    'Dining hall cleaning - Friday evening',
    'Serving support - Sunday lunch',
    'Waste segregation - Week 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kComplaintBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSummaryCard(
                  title: 'Mess Bill',
                  value: 'Rs. 2,565',
                  subtitle: '27 present days x Rs. 95 daily rate',
                  icon: Icons.receipt_long_rounded,
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'This Week Menu',
                  icon: Icons.restaurant_menu_rounded,
                  child: Column(
                    children: _weeklyMenu
                        .map(
                          (day) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: kComplaintBlueTint,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day['day']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: kComplaintText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _detailRow('Breakfast', day['breakfast']!),
                                  _detailRow('Lunch', day['lunch']!),
                                  _detailRow('Dinner', day['dinner']!),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Mess Duties',
                  icon: Icons.assignment_turned_in_rounded,
                  child: Column(
                    children: _duties
                        .map(
                          (duty) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: kComplaintBlue,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    duty,
                                    style: const TextStyle(
                                      color: kComplaintText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ComplaintHome(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kComplaintBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.report_problem_rounded),
                    label: const Text(
                      'Raise Mess Complaint',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: const BoxDecoration(
        gradient: kComplaintHeaderGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mess Services',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Menu, bill, duty and complaint access',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kComplaintBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141565C0),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kComplaintBlueTint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: kComplaintBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kComplaintMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kComplaintText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kComplaintMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kComplaintBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141565C0),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kComplaintBlue),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kComplaintText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: kComplaintText,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: kComplaintMuted),
            ),
          ),
        ],
      ),
    );
  }
}
