import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ===============================
/// AUTHORITY COMPLAINT LIST PAGE
/// ===============================
/// Pass the [authorityRole] matching exactly what appears in the complaint chain
/// e.g. "Hostel Secretary", "Mess Secretary", "Matron", "RT", "Warden", "Office Admin"
///
/// Usage:
///   AuthorityComplaintsPage(authorityRole: "Matron")
///
/// For Warden: also receives Private Complaints
class AuthorityComplaintsPage extends StatelessWidget {
  final String authorityRole;

  const AuthorityComplaintsPage({super.key, required this.authorityRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complaints – $authorityRole")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('currentStage', isEqualTo: authorityRole)
            .where('status', isEqualTo: 'pending')
            .orderBy('createdAt', descending: true) // ← newest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "No pending complaints",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              return _AuthorityComplaintCard(
                id: doc.id,
                data: data,
                authorityRole: authorityRole,
              );
            },
          );
        },
      ),
    );
  }
}

/// ===============================
/// AUTHORITY COMPLAINT CARD
/// ===============================
class _AuthorityComplaintCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;
  final String authorityRole;

  const _AuthorityComplaintCard({
    required this.id,
    required this.data,
    required this.authorityRole,
  });

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Room Complaint':
        return Colors.blue;
      case 'Mess Complaint':
        return Colors.orange;
      case 'General Complaint':
        return Colors.green;
      case 'Private Complaint':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = data['category'] ?? '';
    final room = data['studentRoom'] ?? '';
    final isPrivate = data['isPrivate'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _categoryColor(category),
          child: Icon(
            isPrivate ? Icons.lock : Icons.report,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(
          isPrivate ? "🔒 Private Complaint" : "$category (Room $room)",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("From: ${data['studentName'] ?? ''}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuthorityComplaintDetailPage(
                complaintId: id,
                data: data,
                authorityRole: authorityRole,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ===============================
/// AUTHORITY COMPLAINT DETAIL PAGE
/// ===============================
class AuthorityComplaintDetailPage extends StatefulWidget {
  final String complaintId;
  final Map<String, dynamic> data;
  final String authorityRole;

  const AuthorityComplaintDetailPage({
    super.key,
    required this.complaintId,
    required this.data,
    required this.authorityRole,
  });

  @override
  State<AuthorityComplaintDetailPage> createState() =>
      _AuthorityComplaintDetailPageState();
}

class _AuthorityComplaintDetailPageState
    extends State<AuthorityComplaintDetailPage> {
  final _noteCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _takeAction(String action) async {
    setState(() => _loading = true);

    try {
      final ref = FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaintId);

      final doc = await ref.get();
      final d = doc.data() as Map<String, dynamic>;

      final chain = List<String>.from(d['chain'] ?? []);
      final currentIndex = d['currentStageIndex'] as int;
      final history = List<dynamic>.from(d['history'] ?? []);

      history.add({
        'stage': widget.authorityRole,
        'action': action,
        'note': _noteCtrl.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (action == 'rejected') {
        await ref.update({
          'status': 'rejected',
          'currentStage': widget.authorityRole,
          'history': history,
        });
      } else if (action == 'accepted') {
        await ref.update({
          'status': 'accepted',
          'currentStage': widget.authorityRole,
          'history': history,
        });
      } else if (action == 'forwarded') {
        final nextIndex = currentIndex + 1;
        if (nextIndex >= chain.length) {
          await ref.update({
            'status': 'accepted',
            'currentStage': chain.last,
            'history': history,
          });
        } else {
          await ref.update({
            'currentStageIndex': nextIndex,
            'currentStage': chain[nextIndex],
            'status': 'pending',
            'history': history,
          });
        }
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Complaint ${action.toUpperCase()} successfully"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showActionDialog(String action) async {
    String title;
    String confirmLabel;
    Color confirmColor;

    switch (action) {
      case 'accepted':
        title = "Accept & Resolve Complaint";
        confirmLabel = "Accept";
        confirmColor = Colors.green;
        break;
      case 'rejected':
        title = "Reject Complaint";
        confirmLabel = "Reject";
        confirmColor = Colors.red;
        break;
      default:
        title = "Forward to Next Authority";
        confirmLabel = "Forward";
        confirmColor = Colors.blue;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add a note (optional):"),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Your remarks...",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () {
              Navigator.pop(context);
              _takeAction(action);
            },
            child: Text(
              confirmLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final chain = List<String>.from(d['chain'] ?? []);
    final currentIndex = d['currentStageIndex'] as int;
    final isPrivate = d['isPrivate'] == true;
    final isLastStage = currentIndex >= chain.length - 1;
    final history = List<Map<String, dynamic>>.from(d['history'] ?? []);

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPrivate)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: Colors.purple.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            "Private Complaint",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                  _detailRow("Category", d['category'] ?? ''),
                  _detailRow("Student", d['studentName'] ?? ''),
                  _detailRow("Room", d['studentRoom'] ?? ''),
                  const SizedBox(height: 12),

                  const Text(
                    "Message",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(d['message'] ?? ''),
                  ),

                  const Divider(height: 32),

                  const Text(
                    "Status Tracker",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(chain.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            i < currentIndex
                                ? Icons.check_circle
                                : i == currentIndex
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: i <= currentIndex
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(chain[i]),
                        ],
                      ),
                    );
                  }),

                  if (history.isNotEmpty) ...[
                    const Divider(height: 32),
                    const Text(
                      "Action History",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...history.map((h) {
                      final action = h['action'] ?? '';
                      return Card(
                        color: action == 'accepted'
                            ? Colors.green.shade50
                            : action == 'rejected'
                            ? Colors.red.shade50
                            : Colors.blue.shade50,
                        elevation: 0,
                        child: ListTile(
                          dense: true,
                          title: Text(
                            "${h['stage']} → ${action.toUpperCase()}",
                          ),
                          subtitle: (h['note'] ?? '').isNotEmpty
                              ? Text(h['note'])
                              : null,
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 32),

                  const Text(
                    "Take Action",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _showActionDialog('accepted'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text(
                            "Reject",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _showActionDialog('rejected'),
                        ),
                      ),
                    ],
                  ),

                  if (!isPrivate && !isLastStage) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: Text("Forward to ${chain[currentIndex + 1]}"),
                        onPressed: () => _showActionDialog('forwarded'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}
