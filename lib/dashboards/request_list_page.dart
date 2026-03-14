import 'package:flutter/material.dart';

import '../core/complaint_theme.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  final List<Map<String, String>> requests = [
    {
      "student": "Akhil",
      "room": "203",
      "reason": "Late entry after 9:30 PM",
    },
    {
      "student": "Sneha",
      "room": "115",
      "reason": "Early exit for exam",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kComplaintBg,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: requests.isEmpty
                ? const Center(child: Text("No pending requests"))
                : ListView.builder(
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
                            child: const Icon(
                              Icons.outgoing_mail,
                              color: kComplaintBlue,
                            ),
                          ),
                          title: Text(
                            "${r["student"]} - Room ${r["room"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kComplaintText,
                            ),
                          ),
                          subtitle: Text(
                            r["reason"]!,
                            style: const TextStyle(color: kComplaintMuted),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == "approve") {
                                _confirmApprove(index);
                              } else {
                                _confirmReject(index);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: "approve",
                                child: Text("Approve"),
                              ),
                              PopupMenuItem(
                                value: "reject",
                                child: Text("Reject"),
                              ),
                            ],
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

  Widget _header(BuildContext context) {
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
              "Requests",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${requests.length} pending request(s)",
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

  void _confirmApprove(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Approve this request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kComplaintBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() => requests.removeAt(index));
              Navigator.pop(context);
              _showSuccess("Request approved");
            },
            child: const Text("Approve"),
          ),
        ],
      ),
    );
  }

  void _confirmReject(int index) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reject Request"),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: "Enter rejection reason",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() => requests.removeAt(index));
              Navigator.pop(context);
              _showSuccess("Request rejected");
            },
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
