import 'package:flutter/material.dart';
import '../../models/instructor.dart';
import 'instructor_detail_screen.dart';

class InstructorManagementScreen extends StatefulWidget {
  const InstructorManagementScreen({super.key});

  @override
  State<InstructorManagementScreen> createState() => _InstructorManagementScreenState();
}

class _InstructorManagementScreenState extends State<InstructorManagementScreen> {
  List<Instructor> instructors = Instructor.getSampleInstructors();
  List<Instructor> filteredInstructors = [];
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    filteredInstructors = instructors;
  }

  void _filterInstructors() {
    setState(() {
      filteredInstructors = instructors.where((instructor) {
        bool matchesSearch = instructor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            instructor.specialization.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesFilter = selectedFilter == 'All' || 
            (selectedFilter == 'Active' && instructor.isActive) ||
            (selectedFilter == 'Inactive' && !instructor.isActive);
        
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  double _getResponsiveWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      // Small screens (mobile)
      return screenWidth * 0.95;
    } else if (screenWidth < 1200) {
      // Medium screens (tablet)
      return screenWidth * 0.85;
    } else {
      // Large screens (desktop)
      return screenWidth * 0.7;
    }
  }

  double _getDialogWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      // Small screens (mobile) - use most of the screen
      return screenWidth * 0.95;
    } else if (screenWidth < 900) {
      // Medium screens (tablet) - use 80% of screen
      return screenWidth * 0.8;
    } else if (screenWidth < 1200) {
      // Large tablets/small desktop - use 70% of screen
      return screenWidth * 0.7;
    } else {
      // Large screens (desktop) - use 60% of screen
      return screenWidth * 0.6;                                   
    }
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
          Container(
            width: _getResponsiveWidth(context),
            child: _buildSearchAndFilters(),
          ),
          
          // Instructor list
          Expanded(
            child: filteredInstructors.isEmpty
                ? _buildEmptyState()
                : _buildInstructorList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddInstructorDialog(),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Instructor'),
      ),
    );
  }

  Widget _buildStatsHeader() {
    int totalInstructors = instructors.length;
    int activeInstructors = instructors.where((i) => i.isActive).length;
    int totalStudents = instructors.fold(0, (sum, instructor) => sum + instructor.totalStudents);
    
    return Container(
      width: _getResponsiveWidth(context),
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
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.school, totalInstructors.toString(), 'Total Instructors'),
          _buildStatItem(Icons.verified, activeInstructors.toString(), 'Active'),
          _buildStatItem(Icons.people, totalStudents.toString(), 'Students'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
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
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          Container(
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
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                _filterInstructors();
              },
              decoration: InputDecoration(
                hintText: 'Search instructors...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Filter buttons
          Row(
            children: [
              Expanded(
                child: _buildFilterButton('All'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('Active'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterButton('Inactive'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    bool isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
          _filterInstructors();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9C27B0) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF9C27B0) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          filter,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInstructorList() {
    return Center(
      child: Container(
        width: _getResponsiveWidth(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredInstructors.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInstructorCard(filteredInstructors[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInstructorCard(Instructor instructor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstructorDetailScreen(instructor: instructor),
          ),
        );
      },
      child: Container(
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
              // Profile Image/Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    instructor.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Instructor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            instructor.name,
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
                            color: instructor.isActive 
                                ? Colors.green.withOpacity(0.1) 
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            instructor.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: instructor.isActive ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      instructor.specialization,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          instructor.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.people, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${instructor.totalStudents} students',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.play_circle, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${instructor.totalCourses} courses',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.video_library, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${instructor.uploadedVideos} videos',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action button
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onSelected: (value) => _handleInstructorAction(value, instructor),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.green),
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
                ],
              ),
            ],
          ),
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
            Icons.school_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No instructors found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first instructor to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _handleInstructorAction(String action, Instructor instructor) {
    switch (action) {
      case 'view':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstructorDetailScreen(instructor: instructor),
          ),
        );
        break;
      case 'edit':
        _showEditInstructorDialog(instructor);
        break;
      case 'delete':
        _showDeleteInstructorDialog(instructor);
        break;
    }
  }

  void _showAddInstructorDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final bioController = TextEditingController();
    String selectedSpecialization = 'Mobile Development';
    List<String> selectedSkills = [];
    
    final specializations = [
      'Mobile Development',
      'Web Development',
      'UI/UX Design',
      'Backend Development',
      'Data Science',
      'DevOps',
    ];
    
    final availableSkills = [
      'Flutter', 'Dart', 'React', 'JavaScript', 'Python', 'Java',
      'Swift', 'Kotlin', 'Node.js', 'Firebase', 'AWS', 'Docker',
      'Figma', 'Adobe XD', 'MongoDB', 'PostgreSQL', 'REST APIs'
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Instructor'),
          content: SizedBox(
            width: _getDialogWidth(context),
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
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
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSpecialization,
                    decoration: const InputDecoration(
                      labelText: 'Specialization',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                    items: specializations.map((spec) => DropdownMenuItem(
                      value: spec,
                      child: Text(spec),
                    )).toList(),
                    onChanged: (value) => setDialogState(() => selectedSpecialization = value!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skills',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableSkills.map((skill) {
                          bool isSelected = selectedSkills.contains(skill);
                          return FilterChip(
                            label: Text(skill),
                            selected: isSelected,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  selectedSkills.add(skill);
                                } else {
                                  selectedSkills.remove(skill);
                                }
                              });
                            },
                            selectedColor: const Color(0xFF9C27B0).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF9C27B0),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && 
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  _addInstructor(
                    nameController.text,
                    emailController.text,
                    phoneController.text,
                    selectedSpecialization,
                    bioController.text,
                    selectedSkills,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Instructor'),
            ),
          ],
        ),
      ),
    );
  }

  void _addInstructor(String name, String email, String phone, String specialization, String bio, List<String> skills) {
    final newInstructor = Instructor(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      specialization: specialization,
      bio: bio.isEmpty ? 'No bio provided' : bio,
      profileImage: '',
      rating: 0.0,
      totalStudents: 0,
      totalCourses: 0,
      liveSessions: 0,
      uploadedVideos: 0,
      quizzesCreated: 0,
      skills: skills,
      joinDate: DateTime.now(),
      isActive: true,
    );

    setState(() {
      instructors.add(newInstructor);
      _filterInstructors();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added successfully as instructor'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showEditInstructorDialog(Instructor instructor) {
    final nameController = TextEditingController(text: instructor.name);
    final emailController = TextEditingController(text: instructor.email);
    final phoneController = TextEditingController(text: instructor.phone);
    final bioController = TextEditingController(text: instructor.bio);
    String selectedSpecialization = instructor.specialization;
    List<String> selectedSkills = List.from(instructor.skills);
    bool isActive = instructor.isActive;
    
    final specializations = [
      'Mobile Development',
      'Web Development',
      'UI/UX Design',
      'Backend Development',
      'Data Science',
      'DevOps',
    ];
    
    // Ensure the instructor's current specialization is in the list
    if (!specializations.contains(instructor.specialization)) {
      specializations.add(instructor.specialization);
    }
    
    final availableSkills = [
      'Flutter', 'Dart', 'React', 'JavaScript', 'Python', 'Java',
      'Swift', 'Kotlin', 'Node.js', 'Firebase', 'AWS', 'Docker',
      'Figma', 'Adobe XD', 'MongoDB', 'PostgreSQL', 'REST APIs'
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit ${instructor.name}'),
          content: SizedBox(
            width: _getDialogWidth(context),
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
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
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSpecialization,
                    decoration: const InputDecoration(
                      labelText: 'Specialization',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                    items: specializations.map((spec) => DropdownMenuItem(
                      value: spec,
                      child: Text(spec),
                    )).toList(),
                    onChanged: (value) => setDialogState(() => selectedSpecialization = value!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skills',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableSkills.map((skill) {
                          bool isSelected = selectedSkills.contains(skill);
                          return FilterChip(
                            label: Text(skill),
                            selected: isSelected,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  selectedSkills.add(skill);
                                } else {
                                  selectedSkills.remove(skill);
                                }
                              });
                            },
                            selectedColor: const Color(0xFF9C27B0).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF9C27B0),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Status: '),
                      Switch(
                        value: isActive,
                        onChanged: (value) {
                          setDialogState(() {
                            isActive = value;
                          });
                        },
                        activeColor: const Color(0xFF9C27B0),
                      ),
                      Text(isActive ? 'Active' : 'Inactive'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && 
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  _updateInstructor(
                    instructor,
                    nameController.text,
                    emailController.text,
                    phoneController.text,
                    selectedSpecialization,
                    bioController.text,
                    selectedSkills,
                    isActive,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateInstructor(Instructor instructor, String name, String email, String phone, String specialization, String bio, List<String> skills, bool isActive) {
    final updatedInstructor = Instructor(
      id: instructor.id,
      name: name,
      email: email,
      phone: phone,
      specialization: specialization,
      bio: bio.isEmpty ? 'No bio provided' : bio,
      profileImage: instructor.profileImage,
      rating: instructor.rating,
      totalStudents: instructor.totalStudents,
      totalCourses: instructor.totalCourses,
      liveSessions: instructor.liveSessions,
      uploadedVideos: instructor.uploadedVideos,
      quizzesCreated: instructor.quizzesCreated,
      skills: skills,
      joinDate: instructor.joinDate,
      isActive: isActive,
    );

    setState(() {
      int index = instructors.indexWhere((i) => i.id == instructor.id);
      if (index != -1) {
        instructors[index] = updatedInstructor;
      }
      _filterInstructors();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name updated successfully'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteInstructorDialog(Instructor instructor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Instructor'),
        content: Text('Are you sure you want to delete "${instructor.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                instructors.removeWhere((i) => i.id == instructor.id);
                _filterInstructors();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${instructor.name} deleted successfully'),
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
}
