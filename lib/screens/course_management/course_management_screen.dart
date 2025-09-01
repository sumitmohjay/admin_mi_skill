import 'package:flutter/material.dart';
import '../../models/course.dart';
import 'course_details_screen.dart';
import 'add_edit_course_screen.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  List<Course> courses = Course.getSampleCourses();
  List<Course> filteredCourses = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedLevel = 'All';

  @override
  void initState() {
    super.initState();
    filteredCourses = courses;
  }

  void _filterCourses() {
    setState(() {
      filteredCourses = courses.where((course) {
        bool matchesSearch = course.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            course.instructor.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesCategory = selectedCategory == 'All' || course.category == selectedCategory;
        bool matchesLevel = selectedLevel == 'All' || course.level == selectedLevel;
        
        return matchesSearch && matchesCategory && matchesLevel;
      }).toList();
    });
  }

  void _deleteCourse(String courseId) {
    setState(() {
      courses.removeWhere((course) => course.id == courseId);
      _filterCourses();
    });
    _showSnackBar('Course deleted successfully');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header with stats
          _buildStatsHeader(),
          
          // Search and filters
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: _buildSearchAndFilters(),
            ),
          ),
          
          // Course list
          Expanded(
            child: filteredCourses.isEmpty
                ? _buildEmptyState()
                : _buildCourseList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddCourse(),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
      ),
    );
  }

  Widget _buildStatsHeader() {
    int totalCourses = courses.length;
    int activeCourses = courses.where((c) => c.isActive).length;
    int totalStudents = courses.fold(0, (sum, course) => sum + course.enrolledStudents.length);
    
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C27B0).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem('Total Courses', totalCourses.toString(), Icons.school),
            ),
            Container(width: 1, height: 40, color: Colors.white24),
            Expanded(
              child: _buildStatItem('Active', activeCourses.toString(), Icons.check_circle),
            ),
            Container(width: 1, height: 40, color: Colors.white24),
            Expanded(
              child: _buildStatItem('Students', totalStudents.toString(), Icons.people),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildCourseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return Center(child: _buildCourseCard(course));
      },
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToCourseDetails(course),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Course image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Course info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: course.isActive 
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                course.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: course.isActive ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${course.instructor}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Flexible(child: _buildInfoChip(Icons.category, course.category)),
                            const SizedBox(width: 8),
                            Flexible(child: _buildInfoChip(Icons.signal_cellular_alt, course.level)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Course stats
              Row(
                children: [
                  Flexible(child: _buildStatChip(Icons.people, '${course.enrolledStudents.length}/${course.maxStudents}')),
                  const SizedBox(width: 8),
                  Flexible(child: _buildStatChip(Icons.access_time, '${course.duration}h')),
                  const SizedBox(width: 8),
                  Flexible(child: _buildStatChip(Icons.attach_money, '\$${course.price}')),
                  const Spacer(),
                  
                  // Action buttons
                  IconButton(
                    onPressed: () => _navigateToEditCourse(course),
                    icon: const Icon(Icons.edit, color: Color(0xFF9C27B0)),
                    tooltip: 'Edit Course',
                  ),
                  IconButton(
                    onPressed: () => _showDeleteDialog(course),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete Course',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF9C27B0).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF9C27B0)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9C27B0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No courses found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddCourse(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add First Course'),
          ),
        ],
      ),
    );
  }

  void _navigateToCourseDetails(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailsScreen(course: course),
      ),
    );
  }

  void _navigateToAddCourse() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditCourseScreen(),
      ),
    );
    
    if (result != null && result is Course) {
      setState(() {
        courses.add(result);
        _filterCourses();
      });
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
    
    if (result != null && result is Course) {
      setState(() {
        int index = courses.indexWhere((c) => c.id == course.id);
        if (index != -1) {
          courses[index] = result;
          _filterCourses();
        }
      });
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
