import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey =
      "2c1663adf99b416e8d5156269aebbcaf"; // Replace with your actual API key
  static const String baseUrl = "https://api.spoonacular.com/recipes";

  static Future<List> fetchRecipes(String query) async {
    final String url = "$baseUrl/complexSearch?query=$query&apiKey=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception("Failed to load recipes");
    }
  }
}
