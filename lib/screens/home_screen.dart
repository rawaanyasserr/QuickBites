import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finalproject/lib/services/api_service.dart';
import 'package:finalproject/screens/recipe_screen_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<dynamic> popularRecipes = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  String? selectedCategory;

  final List<String> categories = ['One-Pot Meals', 'Healthy', 'Snacks'];

  String? selectedDiet;
  String? selectedCookingTime;
  String? selectedMealType;

  final List<String> dietOptions = [
    'None',
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
  ];

  final List<String> cookingTimeOptions = [
    'None',
    'Under 30 minutes',
    '30-60 minutes',
    'Over 60 minutes',
  ];

  final List<String> mealTypeOptions = [
    'None',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    fetchPopularRecipes();
  }

  Future<void> fetchPopularRecipes() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await ApiService.fetchPopularRecipes();
      setState(() {
        popularRecipes = data;
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

  Future<void> fetchRecipesByCategory(String category) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await ApiService.fetchRecipesByCategory(category);
      setState(() {
        popularRecipes = data;
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

  Future<void> fetchRecipes(String query) async {
    if (query.isEmpty) return;
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await ApiService.fetchRecipes(
        query,
        diet: selectedDiet,
        maxReadyTime: selectedCookingTime,
        mealType: selectedMealType,
      );
      setState(() {
        popularRecipes = data;
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

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Filters",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF337357),
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterDropdown('Diet', dietOptions, selectedDiet, (value) {
                setState(() {
                  selectedDiet = value;
                });
              }),
              _buildFilterDropdown(
                'Cooking Time',
                cookingTimeOptions,
                selectedCookingTime,
                (value) {
                  setState(() {
                    selectedCookingTime = value;
                  });
                },
              ),
              _buildFilterDropdown(
                'Meal Type',
                mealTypeOptions,
                selectedMealType,
                (value) {
                  setState(() {
                    selectedMealType = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  fetchRecipes(_searchController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF337357),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown(
    String title,
    List<String> options,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF337357),
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items:
              options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF337357)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'One-Pot Meals':
        return Icons.local_dining;
      case 'Healthy':
        return Icons.favorite;
      case 'Snacks':
        return Icons.emoji_food_beverage;
      default:
        return Icons.fastfood;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Color(0xFF337357),
        title: Text(
          "Welcome to QuickBites!",
          style: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            activeColor: Color(0xFFF3BABA),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Color(0xFF2E2E2E) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (value) => fetchRecipes(value),
                      decoration: InputDecoration(
                        hintText: 'Search for recipes...',
                        hintStyle: GoogleFonts.poppins(
                          color: Color(0xFF9E9E9E),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF337357),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3BABA),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () => _showFilterMenu(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ScaleCategoryButton(
                          category: category,
                          onPressed: () {
                            setState(() {
                              selectedCategory = category;
                            });
                            fetchRecipesByCategory(category);
                          },
                          icon: _getCategoryIcon(category),
                          isDarkMode: isDarkMode,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Most Popular Recipes",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Color(0xFF337357),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage.isNotEmpty
                      ? Center(
                        child: Text(
                          errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      )
                      : popularRecipes.isEmpty
                      ? Center(
                        child: Text(
                          "No recipes found.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: popularRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = popularRecipes[index];
                          return FadeInRecipeCard(
                            recipe: recipe,
                            isDarkMode: isDarkMode,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class FadeInRecipeCard extends StatelessWidget {
  final dynamic recipe;
  final bool isDarkMode;

  const FadeInRecipeCard({
    super.key,
    required this.recipe,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: _buildRecipeCard(recipe, context, isDarkMode),
    );
  }

  Widget _buildRecipeCard(
    dynamic recipe,
    BuildContext context,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF2E2E2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                recipe['image'] ?? 'https://via.placeholder.com/150',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/placeholder.png');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'] ?? 'Unknown Recipe',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Color(0xFF337357),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe['readyInMinutes'] != null
                        ? "Ready in ${recipe['readyInMinutes']} mins"
                        : "Cooking time not available",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScaleCategoryButton extends StatefulWidget {
  final String category;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isDarkMode;

  const ScaleCategoryButton({
    super.key,
    required this.category,
    required this.onPressed,
    required this.icon,
    required this.isDarkMode,
  });

  @override
  _ScaleCategoryButtonState createState() => _ScaleCategoryButtonState();
}

class _ScaleCategoryButtonState extends State<ScaleCategoryButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onPressed,
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.isDarkMode ? Color(0xFF2E2E2E) : Color(0xFFF3BABA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.isDarkMode ? Colors.white : Color(0xFF9E9E9E),
              ),
              const SizedBox(width: 8),
              Text(
                widget.category,
                style: GoogleFonts.poppins(
                  color: widget.isDarkMode ? Colors.white : Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
