import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuPressed;

  const CustomNavbar({
    super.key,
    required this.title,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuPressed,
      ),
      // actions: [
      //   // Profile Menu
      //   PopupMenuButton<String>(
      //     icon: const CircleAvatar(
      //       radius: 16,
      //       backgroundColor: Colors.white,
      //       child: Icon(
      //         Icons.person,
      //         color: Color(0xFF9C27B0),
      //         size: 20,
      //       ),
      //     ),
      //     onSelected: (value) => _handleProfileAction(context, value),
      //     itemBuilder: (context) => [
      //       const PopupMenuItem(
      //         value: 'profile',
      //         child: Row(
      //           children: [
      //             Icon(Icons.person, size: 18),
      //             SizedBox(width: 8),
      //             Text('Profile'),
      //           ],
      //         ),
      //       ),
      //       const PopupMenuItem(
      //         value: 'settings',
      //         child: Row(
      //           children: [
      //             Icon(Icons.settings, size: 18),
      //             SizedBox(width: 8),
      //             Text('Settings'),
      //           ],
      //         ),
      //       ),
      //       const PopupMenuDivider(),
      //       const PopupMenuItem(
      //         value: 'logout',
      //         child: Row(
      //           children: [
      //             Icon(Icons.logout, size: 18, color: Colors.red),
      //             SizedBox(width: 8),
      //             Text('Logout', style: TextStyle(color: Colors.red)),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      //   const SizedBox(width: 8),
      // ],
      elevation: 0,
      backgroundColor: const Color(0xFF9C27B0),
      foregroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }


  void _handleProfileAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile page would open here')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings page would open here')),
        );
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
