//old
/*

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
*/


//new

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MealPlanningPage extends StatefulWidget {
  const MealPlanningPage({super.key});

  @override
  State<MealPlanningPage> createState() => _MealPlanningPageState();
}

class _MealPlanningPageState extends State<MealPlanningPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  final Color primaryColor = const Color(0xFF7F56D9);

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, MMMM d').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _currentMonth = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Month Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                              _currentMonth.year, _currentMonth.month - 1);
                        });
                      },
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_currentMonth),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                              _currentMonth.year, _currentMonth.month + 1);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Weekday Headers
                Row(
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                      .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 8),

                // Calendar Grid
                _buildCalendarGrid(),
              ],
            ),
          ),

          // Meals List Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMealCard(
                    context,
                    "Breakfast",
                    "Overnight Oats with Berries",
                    "assets/oats.jpg",
                    "7:00 AM",
                    "320 cal",
                    primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    context,
                    "Lunch",
                    "Quinoa Salad with Avocado",
                    "assets/salad.jpg",
                    "12:30 PM",
                    "450 cal",
                    primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    context,
                    "Dinner",
                    "Chicken Stir-Fry with Vegetables",
                    "assets/stirfry.jpg",
                    "7:00 PM",
                    "520 cal",
                    primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    context,
                    "Snack",
                    "Greek Yogurt with Nuts",
                    "assets/yogurt.png",
                    "3:30 PM",
                    "210 cal",
                    primaryColor,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new meal
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Plan',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          }
        },
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 6 * 7, // Always show 6 rows for consistent height
      itemBuilder: (context, index) {
        // Calculate day number
        final day = index - startingWeekday + 1;
        final isCurrentMonth = day > 0 && day <= daysInMonth;
        final date = isCurrentMonth
            ? DateTime(_currentMonth.year, _currentMonth.month, day)
            : null;
        final isSelected = date != null && _isSameDay(date, _selectedDate);
        final isToday = date != null && _isSameDay(date, DateTime.now());

        return GestureDetector(
          onTap: isCurrentMonth
              ? () {
            setState(() {
              _selectedDate = date!;
            });
          }
              : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(
                color: isSelected ? Colors.white : primaryColor,
                width: 2,
              )
                  : null,
            ),
            child: Center(
              child: Text(
                isCurrentMonth ? day.toString() : '',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                      ? Colors.black
                      : Colors.grey[300],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMealCard(
      BuildContext context,
      String mealType,
      String recipeTitle,
      String imagePath,
      String time,
      String calories,
      Color primaryColor,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to recipe details
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipeTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          calories,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}