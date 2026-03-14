import 'package:flutter/material.dart';

import '../../core/complaint_theme.dart';
import '../../services/notification_service.dart';

enum GateStatus { pending, approved, rejected, forwarded }

class GateRequest {
  final String name;
  final String room;
  final String reason;
  GateStatus status;

  GateRequest({
    required this.name,
    required this.room,
    required this.reason,
    this.status = GateStatus.pending,
  });
}

class GateRequestsPage extends StatefulWidget {
  const GateRequestsPage({super.key});

  @override
  State<GateRequestsPage> createState() => _GateRequestsPageState();
}

class _GateRequestsPageState extends State<GateRequestsPage> {
  final List<GateRequest> requests = [
    GateRequest(
      name: "Aswathy PJ",
      room: "1313",
      reason: "Home visit",
    ),
    GateRequest(
      name: "Sherin Ibadhi K",
      room: "1313",
      reason: "Medical checkup",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kComplaintBg,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (_, i) {
                final r = requests[i];
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
                    title: Text(
                      "${r.name} (Room ${r.room})",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kComplaintText,
                      ),
                    ),
                    subtitle: Text(
                      r.reason,
                      style: const TextStyle(color: kComplaintMuted),
                    ),
                    trailing: _statusText(r.status),
                    onTap: () => _openDetails(r),
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
              "Gate Requests",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${requests.length} request(s)",
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

  Widget _statusText(GateStatus s) {
    Color c;
    String t;

    switch (s) {
      case GateStatus.approved:
        c = kComplaintBlue;
        t = "Approved";
        break;
      case GateStatus.rejected:
        c = Colors.red;
        t = "Rejected";
        break;
      case GateStatus.forwarded:
        c = kComplaintBlueLight;
        t = "Forwarded";
        break;
      default:
        c = Colors.orange;
        t = "Pending";
    }

    return Text(t, style: TextStyle(color: c, fontWeight: FontWeight.bold));
  }

  void _openDetails(GateRequest r) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GateRequestDetailPage(request: r),
      ),
    );
    setState(() {});
  }
}

class GateRequestDetailPage extends StatelessWidget {
  final GateRequest request;
  const GateRequestDetailPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kComplaintBg,
      appBar: AppBar(
        title: const Text("Request Details"),
        backgroundColor: kComplaintBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text("Room: ${request.room}"),
            const SizedBox(height: 16),
            Text("Reason:\n${request.reason}"),
            const Spacer(),
            if (request.status == GateStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kComplaintBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          _update(context, request, GateStatus.approved),
                      child: const Text("Approve"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          _update(context, request, GateStatus.rejected),
                      child: const Text("Reject"),
                    ),
                  ),
                ],
              )
            else if (request.status == GateStatus.approved)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kComplaintBlueLight,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () =>
                      _update(context, request, GateStatus.forwarded),
                  child: const Text("Forward to Higher Authority"),
                ),
              )
            else
              Center(
                child: Text(
                  request.status == GateStatus.rejected
                      ? "Rejected"
                      : "Forwarded",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _update(BuildContext c, GateRequest r, GateStatus s) async {
    r.status = s;

    await NotificationService.send(
      message: "Gate request of ${r.name} was ${s.name.toUpperCase()}",
      type: "normal",
    );

    Navigator.pop(c);
  }
}
