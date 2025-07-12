import 'dart:io';
import 'dart:convert';  // Add this line
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:ForkTune/models/recipe.dart';
import 'package:ForkTune/providers/meal_plan_provider.dart';
import 'package:ForkTune/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddRecipeScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String? mealType;

  const AddRecipeScreen({
    super.key,
    required this.selectedDate,
    this.mealType,
  });

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
  final _secureStorage = const FlutterSecureStorage();

  List<List<String>> ingredients = [["", ""]];
  List<String> instructions = [""];
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  String _selectedMealType = 'Breakfast';

  @override
  void initState() {
    super.initState();
    if (widget.mealType != null) {
      _selectedMealType = widget.mealType!;
    }
  }

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
      // Step 1: Upload image (if selected)
      String? imageId;
      if (_selectedImage != null) {
        final token = await _secureStorage.read(key: 'token');
        if (token == null) throw Exception('No authentication token found');
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:8080/recipes/upload-image'),
        );
        request.headers['Authorization'] = 'Bearer $token';

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
          contentType: MediaType('image', 'jpeg'),
        ));

        var response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          imageId = json.decode(responseBody)['imageId'];
        } else {
          throw Exception('Image upload failed with status ${response.statusCode}');
        }
      }

      // Step 2: Prepare JSON recipe data
      final recipeData = {
        'title': _titleController.text,
        'imageId': imageId,
        'description': _descriptionController.text,
        'prepTime': int.parse(_prepTimeController.text),
        'cookTime': int.parse(_cookTimeController.text),
        'calories': _caloriesController.text,
        'protein': _proteinController.text,
        'fat': _fatController.text,
        'carbs': _carbsController.text,
        'ingredients': ingredients.where((i) => i[0].isNotEmpty).map((i) => {
          'name': i[0],
          'quantity': i[1],
        }).toList(),
        'instructions': instructions
            .asMap()
            .entries
            .where((entry) => entry.value.isNotEmpty)
            .map((entry) => 'Step-${entry.key + 1}: ${entry.value}')
            .toList(),
        'mealType': _selectedMealType,
        'date': widget.selectedDate.toIso8601String(),
      };
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      // Step 3: Send recipe data
      final response = await http.post(
        Uri.parse('http://localhost:8080/recipes/saveRecipes'),
        headers: {'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(recipeData),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Successfully saved recipe')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to save recipe: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add recipe: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  void _addIngredientField() {
    setState(() => ingredients.add(["", ""]));
  }

  void _removeIngredientField(int index) {
    if (ingredients.length > 1) {
      setState(() => ingredients.removeAt(index));
    }
  }

  void _addInstructionField() {
    setState(() => instructions.add(""));
  }

  void _removeInstructionField(int index) {
    if (instructions.length > 1) {
      setState(() => instructions.removeAt(index));
    }
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: _selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_a_photo, size: 48),
            Text('Add Recipe Image'),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      onChanged: (value) => ingredients[index][0] = value,
                      validator: (value) => index == 0 && (value?.isEmpty ?? true)
                          ? 'At least one ingredient required'
                          : null),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => ingredients[index][1] = value,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeIngredientField(index),
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
      ],
    );
  }

  Widget _buildInstructionFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instructions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    validator: (value) =>
                    index == 0 && (value?.isEmpty ?? true)
                        ? 'At least one instruction required'
                        : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeInstructionField(index),
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
      ],
    );
  }

  Widget _buildNutritionFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Facts (per serving)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _caloriesController,
          decoration: const InputDecoration(
            labelText: 'Calories',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                  controller: _proteinController,
                  decoration: const InputDecoration(
                    labelText: 'Protein (g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(
                  labelText: 'Fat (g)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(
                  labelText: 'Carbs (g)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealTypeSelector() {
    const mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meal Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedMealType,
          items: mealTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedMealType = value;
              });
            }
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          validator: (value) => value == null ? 'Please select a meal type' : null,
        ),
      ],
    );
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
              // Display context
              Text(
                'Adding to: ${DateFormat('EEEE, MMMM d').format(widget.selectedDate)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Meal type selector
              _buildMealTypeSelector(),
              const SizedBox(height: 16),

              // Recipe Image
              _buildImagePicker(),
              const SizedBox(height: 20),

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
              _buildIngredientFields(),
              const SizedBox(height: 24),

              // Instructions Section
              _buildInstructionFields(),
              const SizedBox(height: 24),

              // Nutrition Facts
              _buildNutritionFields(),
            ],
          ),
        ),
      ),
    );
  }
}