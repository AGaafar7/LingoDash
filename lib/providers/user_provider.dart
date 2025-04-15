import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'user_usage.dart';

class UserProvider with ChangeNotifier {
  final StreamChatClient _client = StreamChatClient('8w7w6b93ktuu');
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final fb.FirebaseFirestore _firestore = fb.FirebaseFirestore.instance;

  Future<UserUsage?> fetchUserUsage(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserUsage.fromMap(doc.data()!);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return null;
  }

  Future<void> initializeClient() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Initialize the client with your API key
      await _client.connectUser(
        User(id: 'admin', role: 'admin'),
        _client.devToken('admin').rawValue,
      );

      await fetchUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUsers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _client.queryUsers(filter: Filter.empty());
      _users = result.users;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser({
    required String id,
    required String name,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _client.updateUser(
        User(
          id: id,
          name: name,
          role: 'admin',
          extraData: extraData ?? <String, Object?>{},
        ),
      );

      await fetchUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _client.banUser(userId);
      await fetchUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _client.dispose();
    super.dispose();
  }
}
