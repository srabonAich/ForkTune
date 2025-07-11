import 'package:flutter/foundation.dart';
import 'package:ForkTune/models/recipe.dart';
import 'package:ForkTune/services/api_service.dart';

class MealPlanProvider with ChangeNotifier {
  final ApiService apiService;
  Map<DateTime, Map<String, dynamic>> _mealPlans = {};
  Map<String, Recipe> _recipes = {};

  MealPlanProvider({required this.apiService});

  Future<void> loadMealPlan(DateTime date) async {
    try {
      final plan = await apiService.getMealPlan(date);
      _mealPlans[date] = plan;

      for (final mealId in plan['meals'].values.whereType<String>()) {
        if (!_recipes.containsKey(mealId)) {
          final recipes = await apiService.getRecipesByCategory('');
          final recipe = recipes.firstWhere((r) => r.id == mealId);
          _recipes[mealId] = recipe;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading meal plan: $e');
      rethrow;
    }
  }

  Future<Recipe> saveRecipe(Recipe recipe) async {
    try {
      final savedRecipe = await apiService.addRecipe(recipe);
      _recipes[savedRecipe.id] = savedRecipe;
      notifyListeners();
      return savedRecipe;
    } catch (e) {
      debugPrint('Error saving recipe: $e');
      rethrow;
    }
  }

  Future<void> updateMealPlan(DateTime date, String mealType, Recipe recipe) async {
    try {
      final plan = _mealPlans[date] ?? {
        'date': date,
        'meals': {},
      };

      plan['meals'][mealType.toLowerCase()] = recipe.id;

      await apiService.saveMealPlan(date, plan);

      _mealPlans[date] = plan;
      _recipes[recipe.id] = recipe;

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating meal plan: $e');
      rethrow;
    }
  }

  Map<String, dynamic>? getMealPlan(DateTime date) => _mealPlans[date];
  Recipe? getRecipe(String id) => _recipes[id];

  List<Recipe> getRecipesForDate(DateTime date) {
    final plan = _mealPlans[date];
    if (plan == null) return [];

    return plan['meals'].values
        .whereType<String>()
        .map((id) => _recipes[id])
        .where((recipe) => recipe != null)
        .cast<Recipe>()
        .toList();
  }
}