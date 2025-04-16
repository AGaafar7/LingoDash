import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/support_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupportService _supportService = SupportService();

  @override
  void initState() {
    super.initState();
    _supportService.listenForSupportMessages((message) {
      // Show a notification or alert for new support messages
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New support message: ${message['content']}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  title: Text(user['email']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Role: ${user['role']}'),
                      Text('Language: ${user['language']}'),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Switch(
                        value: user['translationEnabled'] ?? true,
                        onChanged: (value) async {
                          // Update translationEnabled field in Firestore
                          await _firestore
                              .collection('users')
                              .doc(user.id)
                              .update({'translationEnabled': value});
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Cancel subscription logic
                          await _firestore
                              .collection('users')
                              .doc(user.id)
                              .update({'subscriptionActive': false});
                        },
                        child: const Text('Cancel Subscription'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
