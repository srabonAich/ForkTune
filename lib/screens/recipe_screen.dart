import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ForkTune/screens/meal_planner_page.dart';
import 'package:ForkTune/screens/AIReviewScreen.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _isSaved = false;
  late List<bool> _ingredientChecked;
  int _servings = 2;
  final Color _primaryColor = const Color(0xFF7F56D9);

  // Rating system variables
  double? _userRating;
  double _averageRating = 0.0;
  int _ratingCount = 0;
  bool _hasRated = false;
  double? _pendingRating;
  bool _isRatingLoading = false;

  @override
  void initState() {
    super.initState();
    _ingredientChecked = List.filled(widget.recipe.ingredients.length, false);
    _checkIfSaved();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    setState(() => _isRatingLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      // Get average rating
      final avgResponse = await http.get(
        Uri.parse('http://localhost:8080/recipes/${widget.recipe.id}/rating'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (avgResponse.statusCode == 200) {
        final avgData = json.decode(avgResponse.body);
        setState(() {
          _averageRating = avgData['averageRating']?.toDouble() ?? 0.0;
          _ratingCount = avgData['count'] ?? 0;
        });
      }

      // Check if user has already rated
      final userRatingResponse = await http.get(
        Uri.parse('http://localhost:8080/recipes/${widget.recipe.id}/user-rating'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userRatingResponse.statusCode == 200) {
        final userRatingData = json.decode(userRatingResponse.body);
        setState(() {
          _userRating = userRatingData['rating']?.toDouble();
          _hasRated = _userRating != null;
          _pendingRating = _userRating;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load ratings")),
      );
    } finally {
      setState(() => _isRatingLoading = false);
    }
  }

  Future<void> _submitRating() async {
    if (_pendingRating == null) return;

    setState(() => _isRatingLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.post(
        Uri.parse('http://localhost:8080/recipes/rate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'recipeId': widget.recipe.id,
          'rating': _pendingRating,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userRating = _pendingRating;
          _hasRated = true;
        });
        await _loadRatings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Rating submitted successfully!"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to submit rating"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isRatingLoading = false);
    }
  }

  Future<void> _deleteRating() async {
    setState(() => _isRatingLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.delete(
        Uri.parse('http://localhost:8080/recipes/${widget.recipe.id}/rating'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _userRating = null;
          _hasRated = false;
          _pendingRating = null;
        });
        await _loadRatings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Rating removed successfully!"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to remove rating"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isRatingLoading = false);
    }
  }

  Future<void> _checkIfSaved() async {
    setState(() => _isLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8080/recipes/is-saved/${widget.recipe.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSaved = json.decode(response.body)['isSaved'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to check saved status")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleSaveRecipe() async {
    setState(() => _isLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.post(
        Uri.parse('http://localhost:8080/recipes/toggle-save'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'id': widget.recipe.id}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSaved = !_isSaved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSaved ? "Recipe saved!" : "Recipe unsaved"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _isSaved ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update saved status"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: _isLoading
                ? const CircularProgressIndicator()
                : Icon(
              _isSaved ? Icons.favorite : Icons.favorite_border,
              color: _isSaved ? Colors.red : null,
            ),
            onPressed: _toggleSaveRecipe,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Stack(
              children: [
                ClipRRect(
                  child: Image.network(
                    widget.recipe.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "Prep: ${widget.recipe.prepTime} mins   Cook: ${widget.recipe.cookTime} mins",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Recipe Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Average Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipe.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(_averageRating.toStringAsFixed(1)),
                            ],
                          ),
                          Text(
                            "(${_ratingCount} ${_ratingCount == 1 ? 'rating' : 'ratings'})",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rating Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasRated ? "YOUR RATING" : "RATE THIS RECIPE",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),

                          if (_isRatingLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Column(
                              children: [
                                // Star Rating
                                StarRating(
                                  rating: _pendingRating ?? 0,
                                  onRatingChanged: (rating) {
                                    setState(() {
                                      _pendingRating = rating;
                                    });
                                  },
                                  starSize: 36,
                                ),
                                const SizedBox(height: 16),

                                // Submit/Remove buttons
                                if (_hasRated)
                                  OutlinedButton(
                                    onPressed: _deleteRating,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    child: const Text("REMOVE RATING"),
                                  )
                                else if (_pendingRating != null)
                                  ElevatedButton(
                                    onPressed: _submitRating,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Move padding here
                                    ),
                                    child: const Text(
                                      "SUBMIT RATING",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )

                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(widget.recipe.mealType),
                      if (widget.recipe.preferences?['diabeticFriendly'] == true)
                        _buildTag("Diabetic Friendly"),
                      if (widget.recipe.preferences?['cuisinePreferences'] != null &&
                          widget.recipe.preferences!['cuisinePreferences'].isNotEmpty)
                        ...widget.recipe.preferences!['cuisinePreferences']
                            .take(2)
                            .map((cuisine) => _buildTag(cuisine))
                            .toList(),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.recipe.description),
                  const SizedBox(height: 24),

                  // Ingredients
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ingredients",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._buildIngredientList(),
                  const SizedBox(height: 24),

                  // Instructions
                  Text(
                    "Instructions",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._buildInstructions(),
                  const SizedBox(height: 24),

                  // Nutrition
                  Text(
                    "Nutrition Facts (per serving)",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNutritionCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AIReviewScreen(recipe: widget.recipe),
            ),
          );
        },
        icon: const Icon(Icons.restaurant_menu),
        label: const Text("AI review"),
        backgroundColor: _primaryColor,
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _primaryColor,
          fontSize: 12,
        ),
      ),
    );
  }

  List<Widget> _buildIngredientList() {
    return List.generate(widget.recipe.ingredients.length, (i) {
      final ingredient = widget.recipe.ingredients[i];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: _ingredientChecked[i],
              onChanged: (value) {
                setState(() {
                  _ingredientChecked[i] = value!;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: _primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                ingredient['name'] ?? '',
                style: TextStyle(
                  decoration: _ingredientChecked[i]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            Text(
              ingredient['quantity'] ?? '',
              style: TextStyle(
                color: Colors.grey[600],
                decoration: _ingredientChecked[i]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildInstructions() {
    return List.generate(widget.recipe.instructions.length, (i) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${i + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.recipe.instructions[i],
                style: const TextStyle(height: 1.5),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNutritionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNutritionRow("Calories", "${widget.recipe.calories} kcal",
                Icons.local_fire_department),
            const Divider(),
            _buildNutritionRow(
                "Protein", "${widget.recipe.protein}g", Icons.fitness_center),
            const Divider(),
            _buildNutritionRow("Fat", "${widget.recipe.fat}g", Icons.oil_barrel),
            const Divider(),
            _buildNutritionRow(
                "Carbs", "${widget.recipe.carbs}g", Icons.restaurant_menu),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: _primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;
  final double starSize;
  final Color? color;

  const StarRating({
    super.key,
    this.rating = 0.0,
    required this.onRatingChanged,
    this.starSize = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1.0),
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: starSize,
            color: color ?? Colors.amber,
          ),
        );
      }),
    );
  }
}
