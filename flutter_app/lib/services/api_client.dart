import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String coreBaseUrl;
  final String trainingBaseUrl;

  ApiClient({required this.coreBaseUrl, required this.trainingBaseUrl});

  Future<Map<String, dynamic>> weeklyReport(String studentId) async {
    final resp = await http.get(Uri.parse('$coreBaseUrl/v1/reports/weekly?studentId=$studentId'));
    if (resp.statusCode >= 400) {
      throw Exception('weekly report failed: ${resp.body}');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<void> uploadEvent(String sessionId, String eventType, Map<String, dynamic> payload) async {
    final resp = await http.post(
      Uri.parse('$trainingBaseUrl/v1/training/events'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'sessionId': sessionId,
        'eventType': eventType,
        'payload': payload,
      }),
    );
    if (resp.statusCode >= 400) {
      throw Exception('upload event failed: ${resp.body}');
    }
  }
}
