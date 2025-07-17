/*========latest dynamic code updated by Sagor========*/
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ForkTune/screens/meal_planner_page.dart';

class AIReviewScreen extends StatefulWidget {
  final Recipe recipe;
  const AIReviewScreen({super.key, required this.recipe});

  @override
  State<AIReviewScreen> createState() => _AIReviewScreenState();
}

class _AIReviewScreenState extends State<AIReviewScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final TextEditingController _questionController = TextEditingController();
  final List<AIMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialAnalysisLoading = true;
  final Color _primaryColor = const Color(0xFF7F56D9);
  final ScrollController _scrollController = ScrollController();
  String _currentAIResponse = '';
  bool _isStreaming = false;
  final _focusNode = FocusNode();
  late Future<UserPreferences> _userPreferencesFuture;

  @override
  void initState() {
    super.initState();
    _userPreferencesFuture = _fetchUserPreferences();
    _performInitialAnalysis();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<UserPreferences> _fetchUserPreferences() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('http://localhost:8080/user/preferences'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserPreferences.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user preferences');
    }
  }

  Future<void> _performInitialAnalysis() async {
    setState(() => _isInitialAnalysisLoading = true);

    try {
      final userPreferences = await _userPreferencesFuture;

      final prompt = '''
      Analyze this recipe specifically for the user's dietary needs and preferences.
      User Preferences:
      - Dietary Restrictions: ${userPreferences.dietaryRestrictions?.join(', ') ?? 'None'}
      - Allergies: ${userPreferences.allergies?.join(', ') ?? 'None'}
      - Cuisine Preferences: ${userPreferences.cuisinePreferences?.join(', ') ?? 'None'}
      - Diabetic Friendly: ${userPreferences.diabeticFriendly ?? false ? 'Yes' : 'No'}
      
      Recipe: ${widget.recipe.title}
      Meal Type: ${widget.recipe.mealType}
      
      Provide focused analysis in these areas:
      1. **Compatibility with User's Diet**:
      - How well it matches their restrictions/preferences
      - Any potential issues with allergies
      
      2. **Health Assessment**:
      - Nutritional highlights (${widget.recipe.calories} kcal)
      - Specific benefits for user's dietary needs
      
      3. **Practical Adjustments**:
      - Suggested modifications if needed
      - Best ingredient substitutes
      
      Keep responses concise (max 6 bullet points per section) and directly relevant to both the recipe and user's profile.
      ''';

      await _getAIResponse(prompt, isInitialAnalysis: true);
    } catch (e) {
      final prompt = '''
      Analyze this recipe in detail:
      Recipe: ${widget.recipe.title}
      Meal Type: ${widget.recipe.mealType}
      
      1. **Health Assessment** (${widget.recipe.calories} kcal)
      2. **Dietary Considerations**
      3. **Cooking Tips**
      
      Provide concise, practical advice.
      ''';

      await _getAIResponse(prompt, isInitialAnalysis: true);
    } finally {
      setState(() => _isInitialAnalysisLoading = false);
    }
  }

  String _identifyAllergens(List<Map<String, String>> ingredients) {
    final allergens = {
      'dairy': ['milk', 'cheese', 'butter', 'yogurt'],
      'gluten': ['wheat', 'barley', 'rye'],
      'nuts': ['almond', 'peanut', 'walnut', 'cashew'],
      'seafood': ['fish', 'shrimp', 'prawn', 'crab'],
      'eggs': ['egg']
    };

    final foundAllergens = <String>[];

    for (final ingredient in ingredients) {
      final name = ingredient['name']?.toLowerCase() ?? '';
      for (final allergen in allergens.entries) {
        if (allergen.value.any((item) => name.contains(item))) {
          if (!foundAllergens.contains(allergen.key)) {
            foundAllergens.add(allergen.key);
          }
          break;
        }
      }
    }

    return foundAllergens.isEmpty ? 'None' : foundAllergens.join(', ');
  }

  Future<void> _sendMessage(String message, {bool isUser = true}) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(AIMessage(
        content: message,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
      _isLoading = !isUser;
      _currentAIResponse = '';
    });

    _scrollToBottom();

    if (isUser) {
      _questionController.clear();
      _focusNode.unfocus();
      await _getAIResponse(message);
    }
  }

  Future<void> _getAIResponse(String message, {bool isInitialAnalysis = false}) async {
    try {
      setState(() {
        _isStreaming = true;
        _isLoading = true;
      });

      if (!isInitialAnalysis) {
        _messages.add(AIMessage(
          content: '',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }

      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final recipeData = {
        'title': widget.recipe.title,
        'description': widget.recipe.description,
        'mealType': widget.recipe.mealType,
        'prepTime': widget.recipe.prepTime,
        'cookTime': widget.recipe.cookTime,
        'calories': widget.recipe.calories,
        'protein': widget.recipe.protein,
        'fat': widget.recipe.fat,
        'carbs': widget.recipe.carbs,
        'ingredients': widget.recipe.ingredients,
        'instructions': widget.recipe.instructions,
        'preferences': widget.recipe.preferences,
      };

      final userPreferences = await _userPreferencesFuture;

      final request = http.Request(
        'POST',
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer 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',
        'HTTP-Referer': 'https://www.forktune.com',
        'X-Title': 'ForkTune',
        'Content-Type': 'application/json',
      });

      request.body = json.encode({
        'model': 'anthropic/claude-3-haiku',
        'stream': true,
        'messages': [
          {
            'role': 'system',
            'content': 'You are a professional nutritionist analyzing recipes. '
                'Provide SPECIFIC advice about THIS recipe considering:'
                '- The user\'s dietary preferences and restrictions '
                '- The recipe\'s nutritional content '
                '- Practical cooking adjustments '
                'Be concise (4-6 bullet points max per section). '
                'Use clear headings and emojis where helpful. '
                'NEVER discuss unrelated topics.'
          },
          {
            'role': 'user',
            'content': 'User Preferences:\n'
                '- Dietary Restrictions: ${userPreferences.dietaryRestrictions?.join(', ') ?? 'None'}\n'
                '- Allergies: ${userPreferences.allergies?.join(', ') ?? 'None'}\n'
                '- Cuisine Preferences: ${userPreferences.cuisinePreferences?.join(', ') ?? 'None'}\n'
                '- Diabetic Friendly: ${userPreferences.diabeticFriendly ?? false ? 'Yes' : 'No'}'
          },
          {
            'role': 'user',
            'content': 'Recipe Data: ${json.encode(recipeData)}'
          },
          {
            'role': 'user',
            'content': 'Specific Question: $message'
          }
        ]
      });

      final streamedResponse = await request.send();
      final responseStream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in responseStream) {
        if (line.startsWith('data:') && line != 'data: [DONE]') {
          try {
            final data = json.decode(line.substring(5));
            final content = data['choices'][0]['delta']['content'] ?? '';
            if (content.isNotEmpty) {
              setState(() {
                _currentAIResponse += content;
                if (isInitialAnalysis && _messages.isEmpty) {
                  _messages.add(AIMessage(
                    content: _currentAIResponse,
                    isUser: false,
                    timestamp: DateTime.now(),
                  ));
                } else if (!isInitialAnalysis) {
                  _messages.last = AIMessage(
                    content: _currentAIResponse,
                    isUser: false,
                    timestamp: DateTime.now(),
                  );
                }
              });
              _scrollToBottom();
            }
          } catch (e) {
            debugPrint('Error parsing stream: $e');
          }
        }
      }
    } catch (e) {
      setState(() {
        if (!isInitialAnalysis || _messages.isEmpty) {
          _messages.add(AIMessage(
            content: '⚠️ Error: ${e.toString().replaceAll(RegExp(r'^Exception: '), '')}',
            isUser: false,
            timestamp: DateTime.now(),
          ));
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isStreaming = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Helper method to build info chips
  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.grey[100],
      visualDensity: VisualDensity.compact,
    );
  }

  // Helper method to build message bubbles
  Widget _buildMessageBubble(AIMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: _primaryColor,
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? _primaryColor.withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: message.isUser
                      ? _primaryColor.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: message.isUser
                  ? Text(
                message.content,
                style: const TextStyle(fontSize: 16),
              )
                  : _parseMarkdown(message.content),
            ),
          ),
          if (message.isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build suggested questions
  Widget _buildSuggestedQuestion(String question) {
    return GestureDetector(
      onTap: () => _sendMessage(question),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          question,
          style: TextStyle(
            color: _primaryColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Helper method to parse markdown content
  Widget _parseMarkdown(String markdown) {
    final lines = markdown.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('###')) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              line.replaceAll('###', '').trim(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          );
        } else if (line.startsWith('##')) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              line.replaceAll('##', '').trim(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (line.startsWith('#')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line.replaceAll('#', '').trim(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (line.startsWith('- ') || line.startsWith('* ') || line.startsWith('• ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    line.replaceAll(RegExp(r'^[-*•]\s'), '').trim(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        } else if (line.trim().isEmpty) {
          return const SizedBox(height: 8);
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              line,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recipe.title} AI Review'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipe.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.recipe.rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(widget.recipe.rating!.toStringAsFixed(1)),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.recipe.description,
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(Icons.timer, '${widget.recipe.prepTime + widget.recipe.cookTime} min'),
                      _buildInfoChip(Icons.local_fire_department, '${widget.recipe.calories} kcal'),
                      _buildInfoChip(Icons.restaurant, widget.recipe.mealType),
                      if (widget.recipe.preferences?['cuisinePreferences'] != null)
                        ...widget.recipe.preferences!['cuisinePreferences']
                            .take(2)
                            .map((cuisine) => _buildInfoChip(Icons.flag, cuisine))
                            .toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: _isInitialAnalysisLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing recipe details...'),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSuggestedQuestion('Will this work with my diet?'),
                      _buildSuggestedQuestion('Healthier alternatives?'),
                      _buildSuggestedQuestion('Quick preparation tips?'),
                      _buildSuggestedQuestion('Nutritional benefits?'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _questionController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Ask about this recipe...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSubmitted: (value) {
                          if (_questionController.text.trim().isNotEmpty && !_isLoading) {
                            _sendMessage(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else
                      IconButton(
                        icon: Icon(Icons.send, color: _primaryColor),
                        onPressed: _questionController.text.trim().isEmpty || _isLoading
                            ? null
                            : () => _sendMessage(_questionController.text),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AIMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  AIMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class UserPreferences {
  final List<String>? dietaryRestrictions;
  final List<String>? allergies;
  final List<String>? cuisinePreferences;
  final bool? diabeticFriendly;

  UserPreferences({
    this.dietaryRestrictions,
    this.allergies,
    this.cuisinePreferences,
    this.diabeticFriendly,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dietaryRestrictions: json['dietaryRestrictions'] != null
          ? List<String>.from(json['dietaryRestrictions'])
          : null,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      cuisinePreferences: json['cuisinePreferences'] != null
          ? List<String>.from(json['cuisinePreferences'])
          : null,
      diabeticFriendly: json['diabeticFriendly'],
    );
  }
}