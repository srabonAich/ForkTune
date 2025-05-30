/*
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> featuredRecipes = [];
  List<dynamic> recommendedRecipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    try {
      final featured = await ApiService.fetchFeaturedRecipes();
      final recommendations = await ApiService.fetchRecommendations('user123'); // replace with real user ID
      setState(() {
        featuredRecipes = featured;
        recommendedRecipes = recommendations;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build UI with featuredRecipes and recommendedRecipes
  }
}
*/