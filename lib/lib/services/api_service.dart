import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "2c1663adf99b416e8d5156269aebbcaf";
  static const String baseUrl = "https://api.spoonacular.com/recipes";

  static Future<List> fetchPopularRecipes() async {
    log("📡 Fetching popular recipes...");
    final String url =
        "$baseUrl/complexSearch?sort=popularity&maxReadyTime=30&apiKey=$apiKey&addRecipeInformation=true";

    try {
      final response = await http.get(Uri.parse(url));
      log("🔄 Response Status: ${response.statusCode}");
      log("🔄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else if (response.statusCode == 401) {
        log("❌ Unauthorized: Check your API key.");
        throw Exception("Unauthorized: Check your API key.");
      } else {
        log("❌ API Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to load recipes: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Network Error: $e");
      throw Exception("Network Error: $e");
    }
  }

  // Fetch Recipes Based on Search Query and Filters
  static Future<List> fetchRecipes(
    String query, {
    String? diet,
    String? maxReadyTime,
    String? mealType,
  }) async {
    log("📡 Searching recipes for: $query");
    String url =
        "$baseUrl/complexSearch?query=$query&apiKey=$apiKey&addRecipeInformation=true";

    // Add filters to the URL
    if (diet != null && diet != 'None') {
      url += "&diet=$diet";
    }
    if (maxReadyTime != null && maxReadyTime != 'None') {
      if (maxReadyTime == 'Under 30 minutes') {
        url += "&maxReadyTime=30";
      } else if (maxReadyTime == '30-60 minutes') {
        url += "&maxReadyTime=60";
      } else if (maxReadyTime == 'Over 60 minutes') {
        url += "&maxReadyTime=999";
      }
    }
    if (mealType != null && mealType != 'None') {
      url += "&type=$mealType";
    }

    try {
      final response = await http.get(Uri.parse(url));
      log("🔄 Response Status: ${response.statusCode}");
      log("🔄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else if (response.statusCode == 401) {
        log("❌ Unauthorized: Check your API key.");
        throw Exception("Unauthorized: Check your API key.");
      } else {
        log("❌ API Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to load recipes: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Network Error: $e");
      throw Exception("Network Error: $e");
    }
  }

  // Fetch Recipe Details by ID
  static Future<Map<String, dynamic>?> fetchRecipeDetails(int recipeId) async {
    log("📡 Fetching details for recipe ID: $recipeId");
    final String url =
        "$baseUrl/$recipeId/information?includeNutrition=false&apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      log("🔄 Response Status: ${response.statusCode}");
      log("🔄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        log("❌ Unauthorized: Check your API key.");
        throw Exception("Unauthorized: Check your API key.");
      } else {
        log("❌ API Error: ${response.statusCode} - ${response.body}");
        throw Exception(
          "Failed to load recipe details: ${response.statusCode}",
        );
      }
    } catch (e) {
      log("❌ Network Error: $e");
      throw Exception("Network Error: $e");
    }
  }

  // Fetch Recipes by Category
  static Future<List> fetchRecipesByCategory(String category) async {
    log("📡 Fetching recipes for category: $category");
    String url =
        "$baseUrl/complexSearch?apiKey=$apiKey&addRecipeInformation=true";

    // Map categories to Spoonacular's query parameters
    switch (category) {
      case 'One-Pot Meals':
        url += "&query=one pot";
        break;
      case 'Healthy':
        url += "&diet=healthy";
        break;
      case 'Snacks':
        url += "&type=snack";
        break;
      default:
        url += "&query=$category";
    }

    try {
      final response = await http.get(Uri.parse(url));
      log("🔄 Response Status: ${response.statusCode}");
      log("🔄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else if (response.statusCode == 401) {
        log("❌ Unauthorized: Check your API key.");
        throw Exception("Unauthorized: Check your API key.");
      } else {
        log("❌ API Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to load recipes: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Network Error: $e");
      throw Exception("Network Error: $e");
    }
  }
}
