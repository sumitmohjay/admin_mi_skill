import 'package:flutter/material.dart';
import 'user_detail_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'role': 'Admin',
      'status': 'Active',
      'avatar': 'JD',
      'joinDate': '2024-01-15',
      'lastActive': '2 hours ago',
      'phone': '+1 234-567-8901',
      'location': 'New York, USA',
      'totalCourses': 5,
      'completedCourses': 3,
      'courses': [
        {
          'id': 1,
          'title': 'Flutter Development Masterclass',
          'progress': 85,
          'status': 'In Progress',
          'enrolledDate': '2024-01-20',
          'completionDate': null,
          'rating': null,
          'feedback': null,
        },
        {
          'id': 2,
          'title': 'Advanced Dart Programming',
          'progress': 100,
          'status': 'Completed',
          'enrolledDate': '2024-01-25',
          'completionDate': '2024-02-15',
          'rating': 5,
          'feedback': 'Excellent course! Very comprehensive.',
        },
        {
          'id': 3,
          'title': 'UI/UX Design Fundamentals',
          'progress': 60,
          'status': 'In Progress',
          'enrolledDate': '2024-02-01',
          'completionDate': null,
          'rating': null,
          'feedback': null,
        },
      ],
    },
    {
      'id': 2,
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'role': 'User',
      'status': 'Active',
      'avatar': 'JS',
      'joinDate': '2024-02-20',
      'lastActive': '1 day ago',
      'phone': '+1 234-567-8902',
      'location': 'California, USA',
      'totalCourses': 3,
      'completedCourses': 2,
      'courses': [
        {
          'id': 4,
          'title': 'React Native Development',
          'progress': 100,
          'status': 'Completed',
          'enrolledDate': '2024-02-25',
          'completionDate': '2024-03-20',
          'rating': 4,
          'feedback': 'Great course, learned a lot!',
        },
        {
          'id': 5,
          'title': 'JavaScript Fundamentals',
          'progress': 100,
          'status': 'Completed',
          'enrolledDate': '2024-02-28',
          'completionDate': '2024-03-15',
          'rating': 5,
          'feedback': 'Perfect for beginners.',
        },
        {
          'id': 6,
          'title': 'Mobile App Design',
          'progress': 40,
          'status': 'In Progress',
          'enrolledDate': '2024-03-01',
          'completionDate': null,
          'rating': null,
          'feedback': null,
        },
      ],
    },
    {
      'id': 3,
      'name': 'Mike Johnson',
      'email': 'mike.johnson@example.com',
      'role': 'Moderator',
      'status': 'Inactive',
      'avatar': 'MJ',
      'joinDate': '2024-01-10',
      'lastActive': '1 week ago',
      'phone': '+1 234-567-8903',
      'location': 'Texas, USA',
      'totalCourses': 2,
      'completedCourses': 1,
      'courses': [
        {
          'id': 7,
          'title': 'Python for Beginners',
          'progress': 100,
          'status': 'Completed',
          'enrolledDate': '2024-01-15',
          'completionDate': '2024-02-10',
          'rating': 4,
          'feedback': 'Good introduction to Python.',
        },
        {
          'id': 8,
          'title': 'Data Science Basics',
          'progress': 25,
          'status': 'Paused',
          'enrolledDate': '2024-02-15',
          'completionDate': null,
          'rating': null,
          'feedback': null,
        },
      ],
    },
    {
      'id': 4,
      'name': 'Sarah Wilson',
      'email': 'sarah.wilson@example.com',
      'role': 'User',
      'status': 'Active',
      'avatar': 'SW',
      'joinDate': '2024-03-05',
      'lastActive': '5 minutes ago',
      'phone': '+1 234-567-8904',
      'location': 'Florida, USA',
      'totalCourses': 4,
      'completedCourses': 1,
      'courses': [
        {
          'id': 9,
          'title': 'Web Development Bootcamp',
          'progress': 100,
          'status': 'Completed',
          'enrolledDate': '2024-03-10',
          'completionDate': '2024-04-25',
          'rating': 5,
          'feedback': 'Amazing course! Highly recommended.',
        },
        {
          'id': 10,
          'title': 'Node.js Backend Development',
          'progress': 70,
          'status': 'In Progress',
          'enrolledDate': '2024-04-01',
          'completionDate': null,
          'rating': null,
          'feedback': null,
        },
      ],
    },
    {
      'id': 5,
      'name': 'David Brown',
      'email': 'david.brown@example.com',
      'role': 'User',
      'status': 'Pending',
      'avatar': 'DB',
      'joinDate': '2024-03-10',
      'lastActive': 'Never',
      'phone': '+1 234-567-8905',
      'location': 'Washington, USA',
      'totalCourses': 1,
      'completedCourses': 0,
      'courses': [
        {
          'id': 11,
          'title': 'Introduction to Programming',
          'progress': 10,
          'status': 'Just Started',
          'enrolledDate': '2024-03-12',
          'completionDate': null,
          'rating': null,
          'feedback': null,
        },
      ],
    },
    {
      'id': 6,
      'name': 'Emily Johnson',
      'email': 'emily.johnson@example.com',
      'role': 'User',
      'status': 'Pending',
      'avatar': 'EJ',
      'joinDate': '2024-03-15',
      'lastActive': 'Never',
      'phone': '+1 234-567-8906',
      'location': 'California, USA',
      'totalCourses': 0,
      'completedCourses': 0,
      'courses': [],
    },
    {
      'id': 7,
      'name': 'Robert Davis',
      'email': 'robert.davis@example.com',
      'role': 'User',
      'status': 'Pending',
      'avatar': 'RD',
      'joinDate': '2024-03-18',
      'lastActive': 'Never',
      'phone': '+1 234-567-8907',
      'location': 'Texas, USA',
      'totalCourses': 0,
      'completedCourses': 0,
      'courses': [],
    },
    {
      'id': 8,
      'name': 'Lisa Anderson',
      'email': 'lisa.anderson@example.com',
      'role': 'User',
      'status': 'Pending',
      'avatar': 'LA',
      'joinDate': '2024-03-20',
      'lastActive': 'Never',
      'phone': '+1 234-567-8908',
      'location': 'Florida, USA',
      'totalCourses': 0,
      'completedCourses': 0,
      'courses': [],
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    var userRoleOnly = _users.where((user) => user['role'] == 'User').toList();
    if (_searchQuery.isEmpty) return userRoleOnly;
    return userRoleOnly.where((user) {
      return user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['email'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage and monitor user accounts',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search and Filter Section
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _showFilterDialog(),
                  icon: const Icon(Icons.filter_list),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Users', '${filteredUsers.length}', Icons.people, const Color(0xFF4CAF50)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Active', '${filteredUsers.where((u) => u['status'] == 'Active').length}', Icons.check_circle, const Color(0xFF9C27B0)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Pending', '${filteredUsers.where((u) => u['status'] == 'Pending').length}', Icons.schedule, const Color(0xFFFF9800)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Users List
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildUserCard(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return GestureDetector(
      onTap: () => _navigateToUserDetail(user),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: _getRoleColor(user['role'] ?? 'User'),
                child: Text(
                  user['avatar'] ?? 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'] ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'] ?? 'No email',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user['role'] ?? 'User').withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user['role'] ?? 'User',
                            style: TextStyle(
                              color: _getRoleColor(user['role'] ?? 'User'),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${user['completedCourses'] ?? 0}/${user['totalCourses'] ?? 0} courses',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status, last active, and menu
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(user['status'] ?? 'Pending').withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user['status'] ?? 'Pending',
                          style: TextStyle(
                            color: _getStatusColor(user['status'] ?? 'Pending'),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        onSelected: (value) => _handleUserAction(value, user),
                        itemBuilder: (context) => _buildMenuItems(user),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user['lastActive'] ?? 'Never',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return const Color(0xFFF44336);
      case 'Moderator':
        return const Color(0xFFFF9800);
      case 'User':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF4CAF50);
      case 'Inactive':
        return const Color(0xFFF44336);
      case 'Pending':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }


  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Users'),
        content: const Text('Filter options would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _navigateToUserDetail(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(user: user),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(Map<String, dynamic> user) {
    List<PopupMenuEntry<String>> items = [
      const PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit, size: 16, color: Colors.blue),
            SizedBox(width: 8),
            Text('Edit'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete, size: 16, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete'),
          ],
        ),
      ),
    ];

    // Add approve/reject for pending users
    if (user['status'] == 'Pending') {
      items.addAll([
        const PopupMenuItem(
          value: 'approve',
          child: Row(
            children: [
              Icon(Icons.check, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Text('Approve'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'reject',
          child: Row(
            children: [
              Icon(Icons.close, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text('Reject'),
            ],
          ),
        ),
      ]);
    } else {
      // Add suspend for active users
      items.add(
        const PopupMenuItem(
          value: 'suspend',
          child: Row(
            children: [
              Icon(Icons.block, size: 16, color: Colors.orange),
              SizedBox(width: 8),
              Text('Suspend'),
            ],
          ),
        ),
      );
    }

    return items;
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'delete':
        _showDeleteUserDialog(user);
        break;
      case 'suspend':
        _showSuspendUserDialog(user);
        break;
      case 'approve':
        _approveUser(user);
        break;
      case 'reject':
        _rejectUser(user);
        break;
    }
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);
    final phoneController = TextEditingController(text: user['phone']);
    final locationController = TextEditingController(text: user['location']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${user['name']}'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                user['name'] = nameController.text;
                user['email'] = emailController.text;
                user['phone'] = phoneController.text;
                user['location'] = locationController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user['name']} updated successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _approveUser(Map<String, dynamic> user) {
    setState(() {
      user['status'] = 'Active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user['name']} approved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject ${user['name']}'),
        content: Text('Are you sure you want to reject ${user['name']}? This will remove them from the system.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['name']} rejected and removed'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user['name']}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['name']} deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSuspendUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Suspend ${user['name']}'),
        content: Text('Are you sure you want to suspend ${user['name']}? They will not be able to access their account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['name']} suspended successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }

}
