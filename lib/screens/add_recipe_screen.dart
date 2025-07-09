import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/models/recipe.dart';
import 'package:my_first_app/providers/user_provider.dart';
import 'package:my_first_app/services/api_service.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();

  List<List<String>> ingredients = [["", ""]];
  List<String> instructions = [""];
  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newRecipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        image: _selectedImagePath ?? 'assets/images/default_recipe.png', // Changed from imageUrl to image
        description: _descriptionController.text,
        prepTime: int.parse(_prepTimeController.text),
        cookTime: int.parse(_cookTimeController.text),
        calories: _caloriesController.text,
        protein: _proteinController.text,
        fat: _fatController.text,
        carbs: _carbsController.text,
        ingredients: ingredients.where((i) => i[0].isNotEmpty).toList(),
        instructions: instructions.where((i) => i.isNotEmpty).toList(),
        rating: 0.0,
        reviewCount: 0,
      );

      // Save to API
      await ApiService().addRecipe(newRecipe);

      // Add to user's recipes
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.addUserRecipe(newRecipe.id);

      Navigator.pop(context, newRecipe);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add recipe: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addIngredientField() {
    setState(() => ingredients.add(["", ""]));
  }

  void _removeIngredientField(int index) {
    setState(() => ingredients.removeAt(index));
  }

  void _addInstructionField() {
    setState(() => instructions.add(""));
  }

  void _removeInstructionField(int index) {
    setState(() => instructions.removeAt(index));
  }

  Future<void> _selectImage() async {
    // Implement image picking logic here
    // For now, we'll just use a placeholder
    setState(() => _selectedImagePath = 'assets/images/uploaded_recipe.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _submitRecipe,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImagePath == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo, size: 48),
                      Text('Add Recipe Image'),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      _selectedImagePath!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Basic Info
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Time Information
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prepTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Prep Time (mins)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cookTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Cook Time (mins)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Ingredients Section
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(ingredients.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Ingredient',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                          ingredients[index][0] = value,
                          validator: (value) => index == 0 &&
                              (value?.isEmpty ?? true)
                              ? 'At least one ingredient required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Qty',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                          ingredients[index][1] = value,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: ingredients.length > 1
                            ? () => _removeIngredientField(index)
                            : null,
                      ),
                    ],
                  ),
                );
              }),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Ingredient'),
                onPressed: _addIngredientField,
              ),
              const SizedBox(height: 24),

              // Instructions Section
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(instructions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Step ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onChanged: (value) => instructions[index] = value,
                          validator: (value) => index == 0 &&
                              (value?.isEmpty ?? true)
                              ? 'At least one instruction required'
                              : null,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: instructions.length > 1
                            ? () => _removeInstructionField(index)
                            : null,
                      ),
                    ],
                  ),
                );
              }),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Instruction'),
                onPressed: _addInstructionField,
              ),
              const SizedBox(height: 24),

              // Nutrition Facts
              const Text(
                'Nutrition Facts (per serving)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      decoration: const InputDecoration(
                        labelText: 'Protein',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      decoration: const InputDecoration(
                        labelText: 'Fat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration: const InputDecoration(
                        labelText: 'Carbs',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}