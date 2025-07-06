//new
import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isSaved = false;
  late List<bool> _ingredientChecked;
  int _servings = 2;
  final Color _primaryColor = const Color(0xFF7F56D9);

  @override
  void initState() {
    super.initState();
    _ingredientChecked = List.filled(10, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spicy Thai Green Curry"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                isSaved = !isSaved;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isSaved ? "Recipe saved!" : "Recipe unsaved"),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
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
                  child: Image.asset(
                    'assets/greencurry.jpg',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.timer, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "45 mins",
                          style: TextStyle(color: Colors.white),
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
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Spicy Thai Green Curry",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "4.8",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag("Thai Cuisine"),
                      _buildTag("Spicy"),
                      _buildTag("Chicken"),
                      _buildTag("Dinner"),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Servings Selector
                  Row(
                    children: [
                      const Text(
                        "Servings:",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_servings > 1) {
                            setState(() {
                              _servings--;
                            });
                          }
                        },
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          _servings.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _servings++;
                          });
                        },
                      ),
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
                  const Text(
                    "Aromatic and creamy Thai Green Curry packed with vibrant vegetables and tender chicken. Perfect for a weeknight meal with a kick!",
                  ),
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
                      Text(
                        "$_servings servings",
                        style: TextStyle(color: Colors.grey[600]),
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
                    "Nutrition Facts",
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
          // Start cooking action
        },
        icon: const Icon(Icons.restaurant_menu),
        label: const Text("Start Cooking"),
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
    final ingredients = [
      ["Chicken breast, thinly sliced", "1 lb"],
      ["Green curry paste", "4 tbsp"],
      ["Coconut milk", "2 cans (13.5 oz each)"],
      ["Fish sauce", "2 tbsp"],
      ["Brown sugar", "1 tbsp"],
      ["Bamboo shoots, sliced", "1 cup"],
      ["Red bell pepper, sliced", "1/2"],
      ["Thai basil leaves", "1 cup"],
      ["Lime leaves", "4–5"],
      ["Vegetable oil", "1 tbsp"],
    ];

    return List.generate(ingredients.length, (i) {
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
                ingredients[i][0],
                style: TextStyle(
                  decoration: _ingredientChecked[i]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            Text(
              ingredients[i][1],
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
    final instructions = [
      "Heat oil in a large pot or wok over medium heat. Add green curry paste and cook, stirring, until fragrant, about 1 minute.",
      "Add chicken and cook until browned.",
      "Pour in coconut milk, fish sauce, and brown sugar. Add bamboo shoots, red bell pepper, and lime leaves. Bring to a simmer.",
      "Reduce heat and simmer for 10–15 minutes, or until chicken is cooked through and vegetables are tender.",
      "Stir in Thai basil leaves just before serving.",
      "Serve hot with steamed rice.",
    ];

    return List.generate(instructions.length, (i) {
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
                instructions[i],
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
            _buildNutritionRow("Calories", "450", Icons.local_fire_department),
            const Divider(),
            _buildNutritionRow("Protein", "35g", Icons.fitness_center),
            const Divider(),
            _buildNutritionRow("Fat", "28g", Icons.oil_barrel),
            const Divider(),
            _buildNutritionRow("Carbs", "18g", Icons.restaurant_menu),
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


//===================dynamic================//
/*
import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isSaved = false;
  late List<bool> _ingredientChecked;
  late String title;
  late String image;
  late String description;
  late List ingredients;
  late List instructions;

  @override
  void initState() {
    super.initState();
    _ingredientChecked = List.filled(10, false);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> recipeData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    title = recipeData['title'];
    image = recipeData['image'];
    description = recipeData['description'];
    ingredients = recipeData['ingredients'];
    instructions = recipeData['instructions'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Title + Info
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 4),
                Text("4.8 (124 reviews) · 15 mins prep · 30 mins cook"),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(description),
            const SizedBox(height: 20),

            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ..._buildIngredientList(),

            const SizedBox(height: 24),
            const Text(
              "Instructions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._buildInstructions(),

            const SizedBox(height: 24),
            const Text(
              "Nutrition Facts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildNutritionRow(Icons.local_fire_department, "Calories", "450"),
            _buildNutritionRow(Icons.fitness_center, "Protein", "35g"),
            _buildNutritionRow(Icons.oil_barrel, "Fat", "28g"),
            _buildNutritionRow(Icons.restaurant_menu, "Carbs", "18g"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          icon: Icon(
            isSaved ? Icons.check_circle : Icons.favorite_border,
            color: Colors.white,
          ),
          label: Text(isSaved ? "Saved" : "Save Recipe"),
          onPressed: () {
            setState(() {
              isSaved = !isSaved;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSaved ? Colors.green : const Color(0xFF7F56D9),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIngredientList() {
    return List.generate(ingredients.length, (i) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: _ingredientChecked[i],
              onChanged: (value) {
                setState(() {
                  _ingredientChecked[i] = value!;
                });
              },
            ),
            const SizedBox(width: 4),
            Expanded(child: Text(ingredients[i][0])),
            Text(
              ingredients[i][1],
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildInstructions() {
    return List.generate(instructions.length, (i) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF7F56D9),
              child: Text(
                "${i + 1}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(instructions[i])),
          ],
        ),
      );
    });
  }

  Widget _buildNutritionRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

 */


//old
/*
import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isSaved = false;
  late List<bool> _ingredientChecked;

  @override
  void initState() {
    super.initState();
    _ingredientChecked = List.filled(10, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spicy Thai Green Curry"),
        centerTitle: true,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth,
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/greencurry.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title + Info
                    const Text(
                      "Spicy Thai Green Curry",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "4.8 (124 reviews) · 15 mins prep · 30 mins cook",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Aromatic and creamy Thai Green Curry packed with vibrant vegetables and tender chicken. Perfect for a weeknight meal with a kick!",
                    ),
                    const SizedBox(height: 20),

                    // Ingredients
                    const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._buildIngredientList(),

                    const SizedBox(height: 24),
                    const Text(
                      "Instructions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildInstructions(),

                    const SizedBox(height: 24),
                    const Text(
                      "Nutrition Facts",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildNutritionRow(
                      Icons.local_fire_department,
                      "Calories",
                      "450",
                    ),
                    _buildNutritionRow(Icons.fitness_center, "Protein", "35g"),
                    _buildNutritionRow(Icons.oil_barrel, "Fat", "28g"),
                    _buildNutritionRow(Icons.restaurant_menu, "Carbs", "18g"),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          icon: Icon(
            isSaved ? Icons.check_circle : Icons.favorite_border,
            color: Colors.white,
          ),
          label: Text(isSaved ? "Saved" : "Save Recipe"),
          onPressed: () {
            setState(() {
              isSaved = !isSaved;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSaved ? Colors.green : const Color(0xFF7F56D9),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIngredientList() {
    final ingredients = [
      ["Chicken breast, thinly sliced", "1 lb"],
      ["Green curry paste", "4 tbsp"],
      ["Coconut milk", "2 cans (13.5 oz each)"],
      ["Fish sauce", "2 tbsp"],
      ["Brown sugar", "1 tbsp"],
      ["Bamboo shoots, sliced", "1 cup"],
      ["Red bell pepper, sliced", "1/2"],
      ["Thai basil leaves", "1 cup"],
      ["Lime leaves", "4–5"],
      ["Vegetable oil", "1 tbsp"],
    ];

    return List.generate(ingredients.length, (i) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: _ingredientChecked[i],
              onChanged: (value) {
                setState(() {
                  _ingredientChecked[i] = value!;
                });
              },
            ),
            const SizedBox(width: 4),
            Expanded(child: Text(ingredients[i][0])),
            Text(
              ingredients[i][1],
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildInstructions() {
    final instructions = [
      "Heat oil in a large pot or wok over medium heat. Add green curry paste and cook, stirring, until fragrant, about 1 minute.",
      "Add chicken and cook until browned.",
      "Pour in coconut milk, fish sauce, and brown sugar. Add bamboo shoots, red bell pepper, and lime leaves. Bring to a simmer.",
      "Reduce heat and simmer for 10–15 minutes, or until chicken is cooked through and vegetables are tender.",
      "Stir in Thai basil leaves just before serving.",
      "Serve hot with steamed rice.",
    ];

    return List.generate(instructions.length, (i) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF7F56D9),
              child: Text(
                "${i + 1}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(instructions[i])),
          ],
        ),
      );
    });
  }

  Widget _buildNutritionRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
*/