import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(user['name'] ?? 'Student Details'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Card
            _buildProfileCard(),
            const SizedBox(height: 20),
            
            // Personal Information
            _buildPersonalInfo(),
            const SizedBox(height: 20),
            
            // Academic Information
            _buildAcademicInfo(),
            const SizedBox(height: 20),
            
            // Account Information
            _buildAccountInfo(),
            const SizedBox(height: 20),
            
            // Preferences
            _buildPreferences(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF9C27B0),
            child: Text(
              _getInitials(user['name'] ?? 'Student'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            user['name'] ?? 'Unknown Student',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          // Student ID
          if (user['studentId'] != null && user['studentId'].toString().isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ID: ${user['studentId']}',
                style: const TextStyle(
                  color: Color(0xFF9C27B0),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 16),
          
          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (user['isActive'] == true ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user['isActive'] == true ? 'ACTIVE' : 'INACTIVE',
              style: TextStyle(
                color: user['isActive'] == true ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _buildInfoCard(
      'Personal Information',
      [
        if (user['email'] != null && user['email'].toString().isNotEmpty)
          _buildInfoRow('Email', user['email'], Icons.email),
        if (user['phoneNumber'] != null && user['phoneNumber'].toString().isNotEmpty)
          _buildInfoRow('Phone', user['phoneNumber'], Icons.phone),
        if (user['dob'] != null && user['dob'].toString().isNotEmpty)
          _buildInfoRow('Date of Birth', user['dob'], Icons.cake),
        if (user['bio'] != null && user['bio'].toString().isNotEmpty)
          _buildInfoRow('Bio', user['bio'], Icons.person),
        if (user['address'] != null && user['address'].toString().isNotEmpty)
          _buildInfoRow('Address', user['address'], Icons.location_on),
      ],
    );
  }

  Widget _buildAcademicInfo() {
    return _buildInfoCard(
      'Academic Information',
      [
        if (user['college'] != null && user['college'].toString().isNotEmpty)
          _buildInfoRow('College', user['college'], Icons.school),
        if (user['state'] != null && user['state'].toString().isNotEmpty)
          _buildInfoRow('State', user['state'], Icons.location_city),
        if (user['city'] != null && user['city'].toString().isNotEmpty)
          _buildInfoRow('City', user['city'], Icons.location_on),
        _buildInfoRow('Enrolled Courses', '${user['enrolledCourses']?.length ?? 0}', Icons.book),
        _buildInfoRow('Favorite Courses', '${user['favoriteCourses']?.length ?? 0}', Icons.favorite),
        _buildInfoRow('Cart Items', '${user['cart']?.length ?? 0}', Icons.shopping_cart),
      ],
    );
  }

  Widget _buildAccountInfo() {
    return _buildInfoCard(
      'Account Information',
      [
        _buildInfoRow('Role', user['role'] ?? 'student', Icons.person_outline),
        _buildInfoRow('Created At', _formatDate(user['createdAt']), Icons.calendar_today),
        _buildInfoRow('Last Updated', _formatDate(user['updatedAt']), Icons.update),
        _buildInfoRow('Interests Set', user['isInterestsSet'] == true ? 'Yes' : 'No', Icons.interests),
        if (user['refreshTokenExpiry'] != null)
          _buildInfoRow('Token Expires', _formatDate(user['refreshTokenExpiry']), Icons.timer),
      ],
    );
  }

  Widget _buildPreferences() {
    final prefs = user['notificationPreferences'] as Map<String, dynamic>? ?? {};
    return _buildInfoCard(
      'Notification Preferences',
      [
        _buildInfoRow('Session Notifications', prefs['session'] == true ? 'Enabled' : 'Disabled', Icons.notifications),
        _buildInfoRow('Messages', prefs['messages'] == true ? 'Enabled' : 'Disabled', Icons.message),
        _buildInfoRow('Feedback', prefs['feedBack'] == true ? 'Enabled' : 'Disabled', Icons.feedback),
        _buildInfoRow('New Enrollments', prefs['newEnrollments'] == true ? 'Enabled' : 'Disabled', Icons.school),
        _buildInfoRow('Reviews', prefs['reviews'] == true ? 'Enabled' : 'Disabled', Icons.rate_review),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    for (int i = 0; i < names.length && i < 2; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }
    return initials.isEmpty ? 'S' : initials;
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
