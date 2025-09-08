import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/api_service.dart';
import 'course_details_screen.dart';
import 'add_edit_course_screen.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedLevel = 'All';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getAllCourses(limit: 50);
      print('API Response: $result');
      
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> coursesData = result['data']['courses'] ?? [];
        print('Found ${coursesData.length} courses in API response');
        setState(() {
          courses = coursesData.map((courseJson) {
            print('Processing course: ${courseJson['title']}');
            return Course.fromJson(courseJson);
          }).toList();
          filteredCourses = courses;
          _isLoading = false;
        });
        print('Total courses loaded: ${courses.length}');
        print('Total students across all courses: ${courses.fold(0, (sum, course) => sum + course.enrolledStudents.length)}');
      } else {
        setState(() {
          _error = result['message'] ?? 'Failed to load courses';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _filterCourses() {
    setState(() {
      filteredCourses = courses.where((course) {
        bool matchesSearch = course.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            course.instructor.name.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesCategory = selectedCategory == 'All' || course.category.name == selectedCategory;
        bool matchesLevel = selectedLevel == 'All' || course.level == selectedLevel;
        
        return matchesSearch && matchesCategory && matchesLevel;
      }).toList();
    });
  }

  void _deleteCourse(String courseId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final result = await ApiService.deleteCourse(courseId);
      
      if (result['success'] == true) {
        // Refresh data after delete operation
        await _fetchCourses();
        _showSnackBar('Course deleted successfully');
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to delete course: ${result['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error deleting course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage and monitor courses',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _fetchCourses,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToAddCourse(),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Course'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Courses',
                    '${courses.length}',
                    Icons.school,
                    const Color(0xFF9C27B0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Active Courses',
                    '${courses.where((c) => c.published).length}',
                    Icons.check_circle,
                    const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Inactive Courses',
                    '${courses.where((c) => !c.published).length}',
                    Icons.cancel,
                    const Color(0xFFF44336),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Students',
                    '${courses.fold(0, (sum, course) => sum + course.enrolledStudents.length)}',
                    Icons.people,
                    const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  searchQuery = value;
                  _filterCourses();
                },
                decoration: const InputDecoration(
                  hintText: 'Search courses...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF9C27B0)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Filters
            Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown(
                    'Category',
                    selectedCategory,
                    ['All', 'Mobile Development', 'Web Development', 'Data Science', 'Design'],
                    (value) {
                      selectedCategory = value!;
                      _filterCourses();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFilterDropdown(
                    'Level',
                    selectedLevel,
                    ['All', 'Beginner', 'Intermediate', 'Advanced'],
                    (value) {
                      selectedLevel = value!;
                      _filterCourses();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Courses List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 3, child: Text('Course', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        Expanded(flex: 2, child: Text('Instructor', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        Expanded(flex: 2, child: Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        Expanded(flex: 1, child: Text('Price', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        Expanded(flex: 1, child: Text('Rating', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        SizedBox(width: 50, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                      ],
                    ),
                  ),
                  // Course List
                  ...filteredCourses.map((course) => _buildCourseRow(course)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error loading courses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchCourses,
            child: const Text('Retry'),
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          hint: Text(label),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCourseRow(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Course info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: course.published 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    course.published ? 'Published' : 'Draft',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: course.published ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Instructor
          Expanded(
            flex: 2,
            child: Text(
              course.instructor.name,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          // Category
          Expanded(
            flex: 2,
            child: Text(
              course.category.name,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          // Price
          Expanded(
            flex: 1,
            child: Text(
              '\$${course.price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          // Rating
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 2),
                Text(
                  course.averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          // Actions
          SizedBox(
            width: 50,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 16),
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _navigateToCourseDetails(course);
                    break;
                  case 'edit':
                    _navigateToEditCourse(course);
                    break;
                  case 'delete':
                    _showDeleteDialog(course);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 16),
                      SizedBox(width: 8),
                      Text('View'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
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
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCourseDetails(Course course) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsScreen(courseId: course.id),
      ),
    );
    
    // Refresh data if course was updated from details screen
    if (result == true) {
      await _fetchCourses();
    }
  }

  void _navigateToAddCourse() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditCourseScreen(),
      ),
    );
    
    // Refresh data after add operation
    if (result == true) {
      await _fetchCourses();
      _showSnackBar('Course added successfully');
    }
  }

  void _navigateToEditCourse(Course course) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCourseScreen(course: course),
      ),
    );
    
    // Refresh data after edit operation
    if (result == true) {
      await _fetchCourses();
      _showSnackBar('Course updated successfully');
    }
  }

  void _showDeleteDialog(Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete "${course.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCourse(course.id);
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF9C27B0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
