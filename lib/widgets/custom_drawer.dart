import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 40,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Admin MI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Management Interface',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: 'Close drawer',
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
                   Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16),
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  index: 0,
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTapped(0),
                ),
                _buildDrawerItem(
                  icon: Icons.school,
                  title: 'Student Management',
                  index: 1,
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTapped(1),
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Instructors Management',
                  index: 2,
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTapped(2),
                ),
                _buildDrawerItem(
                  icon: Icons.analytics,
                  title: 'Event Management',
                  index: 3,
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemTapped(3),
                ),
                _buildDrawerItem(
                  icon: Icons.inventory,
                  title: 'Course',
                  index: 4,
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemTapped(4),
                ),
                _buildDrawerItem(
                  icon: Icons.groups,
                  title: 'Group',
                  index: 5,
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemTapped(5),
                ),
                const Divider(height: 32),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  index: 6,
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemTapped(6),
                ),
                // _buildDrawerItem(
                //   icon: Icons.help_outline,
                //   title: 'Help & Support',
                //   index: 7,
                //   isSelected: selectedIndex == 7,
                //   onTap: () => onItemTapped(7),
                // ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: ApiService.getUserData(),
              builder: (context, snapshot) {
                final userData = snapshot.data;
                final displayName = userData?['name'] ?? 'Admin User';
                final displayEmail = userData?['email'] ?? 'admin@example.com';

                return ListTile(
                  leading: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF2196F3),
                    child: Text(
                      'AD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    displayEmail,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout, size: 20),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0xFF9C27B0).withOpacity(0.1) : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF9C27B0) : Colors.grey[600],
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF9C27B0) : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        selected: isSelected,
        selectedTileColor: const Color(0xFF9C27B0).withOpacity(0.1),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    bool isLoading = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  final result = await ApiService.adminLogout();
                  
                  Navigator.pop(context);
                  
                  if (result['success'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logged out successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Logout completed'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                  
                  // Navigate to login screen
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/login', 
                    (route) => false,
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error during logout: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: isLoading 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
