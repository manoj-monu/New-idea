import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TryOnService {
  static const _baseUrl = String.fromEnvironment('TRYOUT_API_BASE_URL');

  Future<Uri> generate({required XFile person, required XFile garment}) async {
    if (_baseUrl.isEmpty) {
      throw const TryOnException(
        'AI server is not configured yet. Deploy tryout_backend and build with TRYOUT_API_BASE_URL.',
      );
    }
    final personBytes = await person.readAsBytes();
    final garmentBytes = await garment.readAsBytes();
    final payload = {
      'personImage': _dataUri(person.name, personBytes),
      'garmentImage': _dataUri(garment.name, garmentBytes),
    };
    final response = await http
        .post(
          Uri.parse('${_baseUrl.replaceFirst(RegExp(r'/+$'), '')}/api/try-on'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 180));
    final decoded = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map ? decoded['error'] : null;
      throw TryOnException(message?.toString() ?? 'AI generation failed. Please try again.');
    }
    if (decoded is! Map || decoded['imageUrl'] is! String) {
      throw const TryOnException('The AI server returned an invalid result.');
    }
    final uri = Uri.tryParse(decoded['imageUrl'] as String);
    if (uri == null || uri.scheme != 'https') {
      throw const TryOnException('The AI server returned an unsafe result URL.');
    }
    return uri;
  }

  String _dataUri(String name, List<int> bytes) {
    final lower = name.toLowerCase();
    final mime = lower.endsWith('.png')
        ? 'image/png'
        : lower.endsWith('.webp')
            ? 'image/webp'
            : 'image/jpeg';
    return 'data:$mime;base64,${base64Encode(bytes)}';
  }
}

class TryOnException implements Exception {
  final String message;
  const TryOnException(this.message);
  @override
  String toString() => message;
}
