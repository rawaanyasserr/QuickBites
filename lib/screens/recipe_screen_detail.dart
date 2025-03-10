import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finalproject/lib/services/api_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  RecipeDetailScreenState createState() => RecipeDetailScreenState();
}

class RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic>? recipeDetails;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await ApiService.fetchRecipeDetails(widget.recipeId);
      setState(() {
        recipeDetails = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipeDetails?['title'] ?? "Recipe Details")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    recipeDetails?['image'] != null
                        ? Image.network(
                          recipeDetails!['image'],
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/placeholder.png');
                          },
                        )
                        : Image.asset('assets/images/placeholder.png'),
                    const SizedBox(height: 10),
                    Text(
                      "Ingredients",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...?recipeDetails?['extendedIngredients']?.map<Widget>(
                      (ingredient) => Text("- ${ingredient['original']}"),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Instructions",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      recipeDetails?['instructions'] ??
                          "No instructions available.",
                    ),
                  ],
                ),
              ),
    );
  }
}
