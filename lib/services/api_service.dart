import 'dart:convert';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3036/api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3036/api';
    }
    return 'http://localhost:3036/api';
  }

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) async {
    final Uri url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) async {
    final Uri url = Uri.parse('$baseUrl/sign_up');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> sendOffer({
    required String senderEmail,
    required double fee,
    required String offer,
    String? tripTitle,
    String? tripLocation,
  }) async {
    final Uri url = Uri.parse('$baseUrl/send-offer');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderEmail': senderEmail,
        'fee': fee,
        'offer': offer,
        'tripTitle': tripTitle,
        'tripLocation': tripLocation,
      }),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> searchTrips({
    String? query,
    String? location,
  }) async {
    String url = '$baseUrl/search-trips?';
    if (location != null && location.isNotEmpty) {
      url += 'location=${Uri.encodeComponent(location)}&';
    }
    if (query != null && query.isNotEmpty) {
      url += 'q=${Uri.encodeComponent(query)}&';
    }
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> searchGuides({
    String? query,
    String? location,
  }) async {
    String url = '$baseUrl/search-guides?';
    if (location != null && location.isNotEmpty) {
      url += 'location=${Uri.encodeComponent(location)}&';
    }
    if (query != null && query.isNotEmpty) {
      url += 'q=${Uri.encodeComponent(query)}&';
    }
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getProfile(int userId) async {
    final Uri url = Uri.parse('$baseUrl/profile/$userId');
    final response = await http.get(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String token,
    String? firstName,
    String? lastName,
    String? bio,
    String? phone,
    String? avatarUrl,
  }) async {
    final Uri url = Uri.parse('$baseUrl/profile/$userId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (bio != null) 'bio': bio,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      }),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // Chat APIs
  static Future<Map<String, dynamic>> getConversations(String email) async {
    final Uri url = Uri.parse('$baseUrl/conversations/$email');
    final response = await http.get(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getMessages(
    int conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl/messages/$conversationId?limit=$limit&offset=$offset',
    );
    final response = await http.get(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String senderEmail,
    required String receiverEmail,
    required String content,
  }) async {
    final Uri url = Uri.parse('$baseUrl/send-message');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderEmail': senderEmail,
        'receiverEmail': receiverEmail,
        'content': content,
      }),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> markAsRead({
    required int conversationId,
    required String receiverEmail,
  }) async {
    final Uri url = Uri.parse('$baseUrl/mark-as-read/$conversationId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'receiverEmail': receiverEmail}),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> searchConversations({
    required String email,
    required String query,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl/search-conversations/$email?query=${Uri.encodeComponent(query)}',
    );
    final response = await http.get(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getNotifications(String email) async {
    final Uri url = Uri.parse('$baseUrl/notifications?email=${Uri.encodeComponent(email)}');
    final response = await http.get(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(int notificationId) async {
    final Uri url = Uri.parse('$baseUrl/notifications/$notificationId/read');
    final response = await http.put(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getTripDetail(int id) async {
    final Uri url = Uri.parse('$baseUrl/trips/$id');
    final response = await http.get(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
