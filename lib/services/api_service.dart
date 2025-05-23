import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = "https://your-api-endpoint.com";
  static const String powensUrl = "https://flowapi-sandbox.biapi.pro/2.0/auth/token";
  static const String linkWebview = "https://webview.powens.com/connect?domain=flowapi-sandbox&client_id=33780251&redirect_uri=https://flowapp.my.canva.site/landing-page&";

  Future<User> fetchUserData() async {
    final response = await http.get(Uri.parse('$baseUrl/userdata'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<String> fetchUserToken() async {
    final response = await http.get(Uri.parse('$baseUrl/get-user-token'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['token'];
    } else {
      throw Exception('Failed to fetch user token');
    }
  }

  Future<String> fetchBankBaseUrl() async {
    final response = await http.get(
      Uri.parse('https://flowapi-sandbox.biapi.pro/2.0/auth/token/code'), // Remplacez par l'URL réelle de l'API
      headers: {
        'Authorization': 'Bearer x7Wsq2st4lif92H1GzqS_rOe9xNFHIAUC1vDpdGaUuV7eUIQyELlXIlfcvrGeWvXtTjy_Trv89nCIKV5911nUOsK3IDJU9d4tHW_BGM3jinZEtE9KwAawgizCccmEgW5', // Assurez-vous que le token est valide
        'Content-Type': 'application/json', // Si nécessaire
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['code']; // Adaptez ceci selon la structure de la réponse de votre API
      } catch (e) {
        print("JSON parsing error: $e");
        throw Exception('Failed to parse JSON response');
      }
    } else {
      print('Error: ${response.statusCode}, Response Body: ${response.body}');
      throw Exception('Failed to fetch bank base URL: ${response.statusCode} - ${response.body}');
    }


  }

  Future<String> generateBankUrl() async {
    try {
      const String tokenAuth = "YOUR_TEST_TOKEN_HERE"; // Remplacez par le token fourni
      final token = await fetchBankBaseUrl();
      print("webURL : $linkWebview&code=$token");
      return "$linkWebview&code=$token"; // Assurez-vous que linkWebview est défini
    } catch (e) {
      print("Error generating bank URL: $e");
      throw Exception("Error generating bank URL: $e");
    }
  }

  Future<User?> getUser() async {
    try {
      final response = await http.get(Uri.parse("https://api.example.com/user"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception("Failed to load user data");
      }
    } catch (e) {
      print("API Error: $e");
      return null; // ✅ Return null instead of crashing
    }
  }
}
