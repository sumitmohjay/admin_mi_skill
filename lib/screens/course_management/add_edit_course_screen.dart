import 'package:flutter/material.dart';
import '../../models/course.dart';

class AddEditCourseScreen extends StatefulWidget {
  final Course? course;

  const AddEditCourseScreen({
    super.key,
    this.course,
  });

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _maxStudentsController = TextEditingController();
  final _tagsController = TextEditingController();

  String _selectedCategory = 'Mobile Development';
  String _selectedLevel = 'Beginner';
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 37));
  bool _isActive = true;

  final List<String> _categories = [
    'Mobile Development',
    'Web Development',
    'Data Science',
    'Design',
    'DevOps',
    'AI/ML',
    'Cybersecurity',
  ];

  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final course = widget.course!;
    _titleController.text = course.title;
    _descriptionController.text = course.description;
    _instructorController.text = course.instructor;
    _priceController.text = course.price.toString();
    _durationController.text = course.duration.toString();
    _maxStudentsController.text = course.maxStudents.toString();
    _tagsController.text = course.tags.join(', ');
    _selectedCategory = course.category;
    _selectedLevel = course.level;
    _startDate = course.startDate;
    _endDate = course.endDate;
    _isActive = course.isActive;
  }

  double _getResponsiveWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 400) {
      // Very small screens - use full width minus padding
      return screenWidth - 32; // Account for 16px padding on each side
    } else if (screenWidth < 600) {
      // Small screens (mobile) - use 90% of screen width
      return screenWidth * 0.9;
    } else if (screenWidth < 900) {
      // Medium screens (tablet) - use 80% of screen width
      return screenWidth * 0.8;
    } else if (screenWidth < 1200) {
      // Large tablets/small desktop - use 75% of screen width
      return screenWidth * 0.75;
    } else {
      // Large screens (desktop) - use 65% of screen width
      return screenWidth * 0.65;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.course != null;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Course' : 'Add New Course',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveCourse,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              width: _getResponsiveWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Basic Information Section
              _buildSectionCard(
                title: 'Basic Information',
                icon: Icons.info_outline,
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'Course Title',
                    hint: 'Enter course title',
                    validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Enter course description',
                    maxLines: 3,
                    validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _instructorController,
                    label: 'Instructor Name',
                    hint: 'Enter instructor name',
                    validator: (value) => value?.isEmpty == true ? 'Instructor name is required' : null,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Course Details Section
              _buildSectionCard(
                title: 'Course Details',
                icon: Icons.school_outlined,
                children: [
                  _buildResponsiveRow(
                    context,
                    children: [
                      _buildDropdownField(
                        label: 'Category',
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (value) => setState(() => _selectedCategory = value!),
                      ),
                      _buildDropdownField(
                        label: 'Level',
                        value: _selectedLevel,
                        items: _levels,
                        onChanged: (value) => setState(() => _selectedLevel = value!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildResponsiveRow(
                    context,
                    children: [
                      _buildTextField(
                        controller: _priceController,
                        label: 'Price (\$)',
                        hint: '0.00',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Price is required';
                          if (double.tryParse(value!) == null) return 'Enter valid price';
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _durationController,
                        label: 'Duration (hours)',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Duration is required';
                          if (int.tryParse(value!) == null) return 'Enter valid duration';
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _maxStudentsController,
                    label: 'Maximum Students',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty == true) return 'Max students is required';
                      if (int.tryParse(value!) == null) return 'Enter valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _tagsController,
                    label: 'Tags',
                    hint: 'Enter tags separated by commas',
                    helperText: 'e.g., Flutter, Mobile, Dart',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Schedule Section
              _buildSectionCard(
                title: 'Schedule',
                icon: Icons.calendar_today_outlined,
                children: [
                  _buildResponsiveRow(
                    context,
                    children: [
                      _buildDateField(
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () => _selectDate(context, true),
                      ),
                      _buildDateField(
                        label: 'End Date',
                        date: _endDate,
                        onTap: () => _selectDate(context, false),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Status Section
              _buildSectionCard(
                title: 'Status',
                icon: Icons.toggle_on_outlined,
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Active Course',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      _isActive ? 'Course is active and visible to students' : 'Course is inactive and hidden',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    activeColor: const Color(0xFF9C27B0),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isEditing ? 'Update Course' : 'Create Course',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveRow(BuildContext context, {required List<Widget> children}) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    // For small screens (< 600px), stack fields vertically
    if (screenWidth < 600) {
      return Column(
        children: children.map((child) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: child,
        )).toList(),
      );
    }
    
    // For larger screens, display fields in a row
    List<Widget> rowChildren = [];
    for (int i = 0; i < children.length; i++) {
      rowChildren.add(Expanded(child: children[i]));
      if (i < children.length - 1) {
        rowChildren.add(const SizedBox(width: 16));
      }
    }
    
    return Row(children: rowChildren);
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF9C27B0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
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
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9C27B0),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Ensure end date is after start date
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      _showSnackBar('End date must be after start date');
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final course = Course(
      id: widget.course?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      instructor: _instructorController.text.trim(),
      category: _selectedCategory,
      price: double.parse(_priceController.text),
      duration: int.parse(_durationController.text),
      level: _selectedLevel,
      imageUrl: 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=${Uri.encodeComponent(_titleController.text.trim())}',
      startDate: _startDate,
      endDate: _endDate,
      maxStudents: int.parse(_maxStudentsController.text),
      enrolledStudents: widget.course?.enrolledStudents ?? [],
      tags: tags,
      isActive: _isActive,
      createdAt: widget.course?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, course);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _maxStudentsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
