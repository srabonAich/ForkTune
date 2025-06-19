import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MealPlanningPage extends StatefulWidget {
  const MealPlanningPage({super.key});

  @override
  State<MealPlanningPage> createState() => _MealPlanningPageState();
}

class _MealPlanningPageState extends State<MealPlanningPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planning'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Meal Planning'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 24),
              Text(
                'Meals on $formattedDate',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildMealCard("Breakfast", "Overnight Oats", "assets/oats.jpg"),
              const SizedBox(height: 8),
              _buildMealCard("Dinner", "Chicken Stir-Fry", "assets/stirfry.jpg"),
              const SizedBox(height: 16),

              // Don't use Spacer here — remove it completely
              // const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Recipe"),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7F56D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2030),
        currentDate: DateTime.now(),
        onDateChanged: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _buildMealCard(String mealType, String recipeTitle, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mealType,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(recipeTitle,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
