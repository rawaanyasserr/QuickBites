import 'package:flutter/material.dart';
import 'lib/services/api_service.dart'; // Import API service

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipeScreen(), // ✅ Make sure this is the starting screen
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<dynamic> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final data = await ApiService.fetchRecipes("pasta"); // Test with "pasta"
      setState(() {
        recipes = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching recipes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QuickBites Recipes")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Card(
                    child: ListTile(
                      title: Text(recipe['title']),
                      subtitle: Text(
                        "Ready in ${recipe['readyInMinutes']} mins",
                      ),
                      leading: Image.network(recipe['image']),
                    ),
                  );
                },
              ),
    );
  }
}
