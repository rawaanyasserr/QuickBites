import 'package:flutter/material.dart';
import 'package:finalproject/lib/services/api_service.dart';

class RecipeScreen extends StatefulWidget {
  final String searchQuery;

  // ✅ Make searchQuery optional with a default value
  const RecipeScreen({super.key, this.searchQuery = "quick recipes"});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<dynamic> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes(widget.searchQuery);
  }

  Future<void> fetchRecipes(String query) async {
    print("📡 Fetching recipes for: $query");
    final data = await ApiService.fetchRecipes(query);

    setState(() {
      recipes = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recipes for ${widget.searchQuery}")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : recipes.isEmpty
              ? Center(child: Text("❌ No recipes found!"))
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
                      leading: Image.network(recipe['image'] ?? ''),
                    ),
                  );
                },
              ),
    );
  }
}
