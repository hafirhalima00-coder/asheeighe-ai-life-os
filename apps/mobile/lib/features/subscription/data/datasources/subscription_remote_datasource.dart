import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subscription_plan_model.dart';
import '../models/user_subscription_model.dart';

class SubscriptionRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  SubscriptionRemoteDataSource({
    required this.client,
    this.baseUrl = 'https://api.asheeighe.app',
  });

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<SubscriptionPlanModel>> getPlans() async {
    final response = await client.get(
      Uri.parse('$baseUrl/subscriptions/plans'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => SubscriptionPlanModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load plans');
  }

  Future<UserSubscriptionModel?> getCurrentSubscription(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/subscriptions/current'),
      headers: {..._headers, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) return null;
      return UserSubscriptionModel.fromJson(data);
    }
    if (response.statusCode == 404) return null;
    throw Exception('Failed to load subscription');
  }

  Future<void> subscribe(
      String token, String planId, String? paymentMethodId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/subscriptions/subscribe'),
      headers: {..._headers, 'Authorization': 'Bearer $token'},
      body: json.encode({
        'planId': planId,
        if (paymentMethodId != null) 'paymentMethodId': paymentMethodId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to subscribe');
    }
  }

  Future<void> cancelSubscription(String token, {String? reason}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/subscriptions/cancel'),
      headers: {..._headers, 'Authorization': 'Bearer $token'},
      body: json.encode({if (reason != null) 'reason': reason}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel subscription');
    }
  }

  Future<void> restorePurchases(String token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/subscriptions/restore'),
      headers: {..._headers, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to restore purchases');
    }
  }

  Future<bool> checkFeatureAccess(String token, String feature) async {
    final response = await client.get(
      Uri.parse('$baseUrl/subscriptions/check-access?feature=$feature'),
      headers: {..._headers, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['allowed'] ?? false;
    }
    return false;
  }

  Future<Map<String, dynamic>> getUsage(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/subscriptions/usage'),
      headers: {..._headers, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load usage');
  }
}
