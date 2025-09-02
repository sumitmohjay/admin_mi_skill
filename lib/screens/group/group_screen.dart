import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  // Sample group data with members
  final List<Map<String, dynamic>> _groups = [
    {
      'id': '1',
      'name': 'Flutter Developers',
      'description': 'A group for Flutter developers to share knowledge and collaborate',
      'memberCount': 45,
      'createdDate': '2024-01-15',
      'status': 'Active',
      'category': 'Development',
      'avatar': 'FD',
      'color': Color(0xFF2196F3),
      'members': [
        {'id': '1', 'name': 'John Doe', 'email': 'john@example.com', 'role': 'Lead Developer', 'avatar': 'JD'},
        {'id': '2', 'name': 'Jane Smith', 'email': 'jane@example.com', 'role': 'Senior Developer', 'avatar': 'JS'},
        {'id': '3', 'name': 'Mike Johnson', 'email': 'mike@example.com', 'role': 'Flutter Developer', 'avatar': 'MJ'},
      ],
    },
    {
      'id': '2',
      'name': 'UI/UX Designers',
      'description': 'Creative minds working on user interface and experience design',
      'memberCount': 32,
      'createdDate': '2024-02-10',
      'status': 'Active',
      'category': 'Design',
      'avatar': 'UD',
      'color': Color(0xFF9C27B0),
      'members': [
        {'id': '4', 'name': 'Sarah Wilson', 'email': 'sarah@example.com', 'role': 'UI Designer', 'avatar': 'SW'},
        {'id': '5', 'name': 'David Brown', 'email': 'david@example.com', 'role': 'UX Designer', 'avatar': 'DB'},
      ],
    },
    {
      'id': '3',
      'name': 'Project Managers',
      'description': 'Coordination and management of various projects',
      'memberCount': 18,
      'createdDate': '2024-01-20',
      'status': 'Active',
      'category': 'Management',
      'avatar': 'PM',
      'color': Color(0xFF4CAF50),
      'members': [
        {'id': '6', 'name': 'Emily Davis', 'email': 'emily@example.com', 'role': 'Project Manager', 'avatar': 'ED'},
        {'id': '7', 'name': 'Robert Taylor', 'email': 'robert@example.com', 'role': 'Scrum Master', 'avatar': 'RT'},
      ],
    },
    {
      'id': '4',
      'name': 'Quality Assurance',
      'description': 'Testing and quality control team',
      'memberCount': 12,
      'createdDate': '2024-03-05',
      'status': 'Inactive',
      'category': 'Testing',
      'avatar': 'QA',
      'color': Color(0xFFFF9800),
      'members': [
        {'id': '8', 'name': 'Lisa Anderson', 'email': 'lisa@example.com', 'role': 'QA Engineer', 'avatar': 'LA'},
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredGroups {
    var filtered = _groups;
    
    if (_selectedFilter != 'All') {
      filtered = filtered.where((group) => group['status'] == _selectedFilter).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((group) {
        return group['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            group['description'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage and monitor group activities',
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
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search groups...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
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
                  icon: Icon(Icons.filter_list, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Groups List
          Expanded(
            child: filteredGroups.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildGroupCard(filteredGroups[index]),
                      );
                    },
                  ),
          ),
        ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGroupDialog(),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add New Group'),
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    return Container(
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
            CircleAvatar(
              radius: 30,
              backgroundColor: group['color'],
              child: Text(
                group['avatar'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: group['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            group['category'],
                            style: TextStyle(
                              color: group['color'],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showManageMembersDialog(group),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.people, size: 16, color: Colors.blue[600]),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${group['memberCount']} members',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(group['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        group['status'],
                        style: TextStyle(
                          color: _getStatusColor(group['status']),
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
                      onSelected: (value) => _handleGroupAction(value, group),
                      itemBuilder: (context) => [
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
                          value: 'members',
                          child: Row(
                            children: [
                              Icon(Icons.people, size: 16, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Manage Members'),
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
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Created: ${group['createdDate']}',
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No groups found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first group to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _handleGroupAction(String action, Map<String, dynamic> group) {
    switch (action) {
      case 'edit':
        _showEditGroupDialog(group);
        break;
      case 'members':
        _showManageMembersDialog(group);
        break;
      case 'delete':
        _showDeleteGroupDialog(group);
        break;
    }
  }

  void _showAddGroupDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Development';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Group'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Development', 'Design', 'Management', 'Testing', 'Marketing']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) => selectedCategory = value!,
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
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _groups.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'memberCount': 0,
                    'createdDate': DateTime.now().toString().substring(0, 10),
                    'status': 'Active',
                    'category': selectedCategory,
                    'avatar': nameController.text.substring(0, 2).toUpperCase(),
                    'color': const Color(0xFF2196F3),
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${nameController.text} group created successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditGroupDialog(Map<String, dynamic> group) {
    final nameController = TextEditingController(text: group['name']);
    final descriptionController = TextEditingController(text: group['description']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${group['name']}'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                group['name'] = nameController.text;
                group['description'] = descriptionController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${group['name']} updated successfully')),
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

  void _showManageMembersDialog(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Members - ${group['name']}'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current members: ${group['members'].length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: group['members'].length,
                  itemBuilder: (context, index) {
                    final member = group['members'][index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: group['color'],
                          child: Text(
                            member['avatar'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          member['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member['email']),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: group['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                member['role'],
                                style: TextStyle(
                                  color: group['color'],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 18),
                          onSelected: (value) => _handleMemberAction(value, member, group),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Edit Role'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'remove',
                              child: Row(
                                children: [
                                  Icon(Icons.remove_circle, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Remove'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showAddMemberDialog(group),
            child: const Text('Add Member'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleMemberAction(String action, Map<String, dynamic> member, Map<String, dynamic> group) {
    switch (action) {
      case 'edit':
        _showEditMemberDialog(member, group);
        break;
      case 'remove':
        _showRemoveMemberDialog(member, group);
        break;
    }
  }

  void _showAddMemberDialog(Map<String, dynamic> group) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'Member';
    
    final roles = ['Member', 'Admin', 'Moderator', 'Lead Developer', 'Senior Developer', 'UI Designer', 'UX Designer', 'Project Manager', 'QA Engineer'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add Member to ${group['name']}'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                  items: roles.map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  )).toList(),
                  onChanged: (value) => setDialogState(() => selectedRole = value!),
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
                if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  setState(() {
                    group['members'].add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': nameController.text,
                      'email': emailController.text,
                      'role': selectedRole,
                      'avatar': nameController.text.split(' ').map((n) => n[0]).take(2).join().toUpperCase(),
                    });
                    group['memberCount'] = group['members'].length;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${nameController.text} added to ${group['name']}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditMemberDialog(Map<String, dynamic> member, Map<String, dynamic> group) {
    String selectedRole = member['role'];
    final roles = ['Member', 'Admin', 'Moderator', 'Lead Developer', 'Senior Developer', 'UI Designer', 'UX Designer', 'Project Manager', 'QA Engineer'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit ${member['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                items: roles.map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                )).toList(),
                onChanged: (value) => setDialogState(() => selectedRole = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  member['role'] = selectedRole;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${member['name']} role updated')),
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
      ),
    );
  }

  void _showRemoveMemberDialog(Map<String, dynamic> member, Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove "${member['name']}" from this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                group['members'].removeWhere((m) => m['id'] == member['id']);
                group['memberCount'] = group['members'].length;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member['name']} removed from group'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupDialog(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete "${group['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _groups.removeWhere((g) => g['id'] == group['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${group['name']} deleted successfully'),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Groups'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All'),
              value: 'All',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Active'),
              value: 'Active',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Inactive'),
              value: 'Inactive',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF4CAF50);
      case 'Inactive':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }
}
