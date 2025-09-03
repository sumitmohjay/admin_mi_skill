import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(user['name']),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit ${user['name']}')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            _buildProfileCard(),
            const SizedBox(height: 20),
            
            // Course Statistics
            _buildCourseStats(),
            const SizedBox(height: 20),
            
            // Courses List
            _buildCoursesSection(),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar and basic info
            CircleAvatar(
              radius: 40,
              backgroundColor: _getRoleColor(user['role'] ?? 'User'),
              child: Text(
                user['avatar'] ?? 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              user['name'] ?? 'Unknown User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user['email'] ?? 'No email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            // Status and role badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user['role'] ?? 'User').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
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
              ],
            ),
            const SizedBox(height: 20),
            
            // Personal details
            _buildDetailRow(Icons.phone, 'Phone', user['phone'] ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.location_on, 'Location', user['location'] ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.calendar_today, 'Joined', user['joinDate'] ?? 'Unknown'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.access_time, 'Last Active', user['lastActive'] ?? 'Never'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseStats() {
    // For pending users, show 0 courses
    if (user['status'] == 'Pending') {
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Courses',
              '0',
              Icons.book,
              const Color(0xFF2196F3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Completed',
              '0',
              Icons.check_circle,
              const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'In Progress',
              '0',
              Icons.play_circle,
              const Color(0xFFFF9800),
            ),
          ),
        ],
      );
    }
    
    final totalCourses = user['totalCourses'] ?? 0;
    final completedCourses = user['completedCourses'] ?? 0;
    final courses = user['courses'] as List<dynamic>? ?? [];
    final inProgressCourses = courses.where((course) => 
        course['status'] == 'In Progress').length;
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Courses',
            totalCourses.toString(),
            Icons.book,
            const Color(0xFF2196F3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            completedCourses.toString(),
            Icons.check_circle,
            const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'In Progress',
            inProgressCourses.toString(),
            Icons.play_circle,
            const Color(0xFFFF9800),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    // Don't show courses section for pending users
    if (user['status'] == 'Pending') {
      return Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enrolled Courses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.pending_actions,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'User approval pending',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Course enrollment will be available after approval',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final courses = user['courses'] as List<dynamic>? ?? [];
    
    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enrolled Courses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            ...courses.map((course) => _buildCourseCard(course as Map<String, dynamic>)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Builder(
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double cardWidth;

        if (screenWidth < 380) {
          cardWidth = screenWidth * 0.95; // very small screens
        } else if (screenWidth < 600) {
          cardWidth = screenWidth * 0.9;  // small screens
        } else {
          cardWidth = screenWidth * 0.8;  // larger screens
        }

        return Container(
          width: cardWidth,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      course['title'] ?? 'Unknown Course',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCourseStatusColor(course['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course['status'] ?? 'Just Started',
                      style: TextStyle(
                        color: _getCourseStatusColor(course['status'] ?? 'Just Started'),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- Progress bar ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${course['progress'] ?? 0}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (course['progress'] ?? 0) / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCourseStatusColor(course['status'] ?? 'Just Started'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Course details - responsive layout
            screenWidth < 380
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCourseDetailItem(
                        'Enrolled',
                        course['enrolledDate'] ?? 'Unknown',
                        Icons.calendar_today,
                      ),
                      if (course['completionDate'] != null) ...[
                        const SizedBox(height: 4),
                        _buildCourseDetailItem(
                          'Completed',
                          course['completionDate'] ?? 'Unknown',
                          Icons.check_circle,
                        ),
                      ],
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildCourseDetailItem(
                          'Enrolled',
                          course['enrolledDate'] ?? 'Unknown',
                          Icons.calendar_today,
                        ),
                      ),
                      if (course['completionDate'] != null)
                        Expanded(
                          child: _buildCourseDetailItem(
                            'Completed',
                            course['completionDate'] ?? 'Unknown',
                            Icons.check_circle,
                          ),
                        ),
                    ],
                  ),
            const SizedBox(height: 8),

            // Rating and feedback - responsive layout
            if (course['rating'] != null) ...[
              const SizedBox(height: 12),
              screenWidth < 380
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${course['rating'] ?? 0}/5',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        if (course['feedback'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            course['feedback'] ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    )
                  : Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${course['rating'] ?? 0}/5',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (course['feedback'] != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              course['feedback'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
            ],
          ],
        ),
      );
    },
  );
  }

  Widget _buildCourseDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
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

  Color _getCourseStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF4CAF50);
      case 'In Progress':
        return const Color(0xFF2196F3);
      case 'Paused':
        return const Color(0xFFFF9800);
      case 'Just Started':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }
}
