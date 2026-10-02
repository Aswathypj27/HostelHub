import 'package:flutter/material.dart';

import '../../core/complaint_theme.dart';

class HostelSecRequestsPage extends StatelessWidget {
  const HostelSecRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [
      {
        "name": "Sherin Ibadhi K",
        "room": "1313",
        "status": "Submitted",
      },
      {
        "name": "Anjali P",
        "room": "1204",
        "status": "Approved",
      },
      {
        "name": "Rahul M",
        "room": "1109",
        "status": "Pending",
      },
    ];

    return Scaffold(
      backgroundColor: kComplaintBg,
      body: Column(
        children: [
          _header(context, requests.length),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final r = requests[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kComplaintBorder, width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x141565C0),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: kComplaintBlueTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: kComplaintBlue),
                    ),
                    title: Text(
                      "${r['name']} (Room ${r['room']})",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kComplaintText,
                      ),
                    ),
                    subtitle: Text(
                      "Status: ${r['status']}",
                      style: const TextStyle(color: kComplaintMuted),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: kComplaintMuted,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, int count) {
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
              "Outgoing Requests",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$count request(s)",
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
