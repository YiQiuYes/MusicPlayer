import 'dart:convert';

class RequestUtils {
  static Map<String, dynamic> transformResponse(dynamic response) {
    return response.data is String ? jsonDecode(response.data) : response.data;
  }
}
