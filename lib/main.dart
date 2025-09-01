import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/user/user_screen.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/custom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin MI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: const Color(0xFF9C27B0),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9C27B0),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const HomeScreen(),
    const UserScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'User Management',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomNavbar(
        title: _titles[_selectedIndex],
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: CustomDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
    );
  }
}