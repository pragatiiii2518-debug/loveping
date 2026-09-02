import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  // ==================================================
  // CLOUDINARY CONFIGURATION
  // ==================================================

  static const String cloudName = "kv6famp5";
  static const String uploadPreset = "loveping_media";

  // ==================================================
  // UPLOAD PHOTO / VIDEO
  // ==================================================

  static Future<String?> uploadFile(File file) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/auto/upload",
      );

      final request = http.MultipartRequest(
        "POST",
        url,
      );

      // Cloudinary unsigned upload preset
      request.fields["upload_preset"] = uploadPreset;

      // Actual file
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          file.path,
        ),
      );

      // Send request
      final response = await request.send();

      // Read response
      final responseBody =
          await response.stream.bytesToString();

      // ==================================================
      // SUCCESS
      // ==================================================

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(responseBody);

        final String? secureUrl =
            data["secure_url"]?.toString();

        if (secureUrl != null && secureUrl.isNotEmpty) {
          print("Cloudinary upload successful.");
          print("URL: $secureUrl");

          return secureUrl;
        }

        print("Cloudinary response did not contain secure_url.");
        return null;
      }

      // ==================================================
      // FAILED
      // ==================================================

      print(
        "Cloudinary upload failed. "
        "Status code: ${response.statusCode}",
      );

      print("Cloudinary response:");
      print(responseBody);

      return null;
    } catch (e) {
      // ==================================================
      // ERROR
      // ==================================================

      print("Cloudinary error: $e");

      return null;
    }
  }
}