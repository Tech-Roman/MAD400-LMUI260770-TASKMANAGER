import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const primaryColor = Color(0xFF228B22);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Romanus Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          surface: const Color(0xFFFFFBF8),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBF8),
        
        // Modern Navigation Bar Theme
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: primaryColor.withValues(alpha: 0.1),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primaryColor);
            }
            return IconThemeData(color: Colors.grey.shade600);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontWeight: FontWeight.bold, color: primaryColor);
            }
            return TextStyle(color: Colors.grey.shade600);
          }),
        ),

        // Modern Navigation Rail Theme
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.white,
          indicatorColor: primaryColor.withValues(alpha: 0.1),
          selectedIconTheme: const IconThemeData(color: primaryColor),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          labelType: NavigationRailLabelType.all,
        ),
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TaskListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 750;

    return Scaffold(
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) => setState(() => _currentIndex = index),
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircleAvatar(
                  backgroundColor: MyApp.primaryColor,
                  child: Icon(Icons.rocket_launch, color: Colors.white),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.task_outlined),
                  selectedIcon: Icon(Icons.task),
                  label: Text("Tasks"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text("Profile"),
                ),
              ],
            ),
          
          if (isWide) const VerticalDivider(thickness: 1, width: 1),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
              child: _screens[_currentIndex],
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: isWide
          ? null
          : Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) => setState(() => _currentIndex = index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.task_outlined),
                    selectedIcon: Icon(Icons.task),
                    label: "Tasks",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
    );
  }
}
