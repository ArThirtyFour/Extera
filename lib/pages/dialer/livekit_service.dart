import 'dart:convert';
import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

class LiveKitCredentials {
  final String url;
  final String jwt;

  LiveKitCredentials({required this.url, required this.jwt});

  factory LiveKitCredentials.fromJson(Map<String, dynamic> json) {
    return LiveKitCredentials(
      url: json['url'] as String,
      jwt: json['jwt'] as String,
    );
  }
}

class LiveKitService {
  static Future<LiveKitCredentials> getCredentials({
    required OpenIdCredentials openId,
    required String roomId,
    required String deviceId,
    required String jwtServiceUrl,
  }) async {
    final body = {
      'room': roomId,
      'openid_token': {
        'access_token': openId.accessToken,
        'token_type': openId.tokenType,
        'matrix_server_name': openId.matrixServerName,
        'expires_in': openId.expiresIn,
      },
      'device_id': deviceId,
    };

    final url = jwtServiceUrl.replaceAll(RegExp(r'/+$'), '');
    final response = await post(
      Uri.parse('$url/sfu/get'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final msg = response.body.isNotEmpty ? response.body : response.reasonPhrase ?? 'unknown error';
      throw Exception('lk-jwt-service error (${response.statusCode}): $msg');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return LiveKitCredentials.fromJson(data);
  }
}
