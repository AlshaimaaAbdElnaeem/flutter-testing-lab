import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Tab> _tabs = [
    const Tab(icon: Icon(Icons.person_add), text: 'Registration'),
    const Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping Cart'),
    const Tab(icon: Icon(Icons.wb_sunny), text: 'Weather'),
  ];

  final List<Widget> _tabViews = [
    const UserRegistrationForm(),
    const ShoppingCart(),
    const WeatherDisplay(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Testing Lab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                border: Border(
                  bottom: BorderSide(color: Colors.orange.shade300),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Current Widget: ${_getWidgetName(_currentIndex)} - Contains bugs that need fixing!',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabViews.map((widget) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: widget,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border(
            top: BorderSide(color: Colors.blue.shade200),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Find and fix the bugs in each widget!',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Switch between tabs to test different widgets',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWidgetName(int index) {
    switch (index) {
      case 0:
        return 'User Registration Form';
      case 1:
        return 'Shopping Cart';
      case 2:
        return 'Weather Display';
      default:
        return 'Unknown Widget';
    }
  }
}