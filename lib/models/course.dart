class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String category;
  final double price;
  final int duration; // in hours
  final String level; // Beginner, Intermediate, Advanced
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int maxStudents;
  final List<String> enrolledStudents;
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.category,
    required this.price,
    required this.duration,
    required this.level,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.maxStudents,
    required this.enrolledStudents,
    required this.tags,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? category,
    double? price,
    int? duration,
    String? level,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    int? maxStudents,
    List<String>? enrolledStudents,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      category: category ?? this.category,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxStudents: maxStudents ?? this.maxStudents,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'category': category,
      'price': price,
      'duration': duration,
      'level': level,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxStudents': maxStudents,
      'enrolledStudents': enrolledStudents,
      'tags': tags,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      category: json['category'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      level: json['level'],
      imageUrl: json['imageUrl'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxStudents: json['maxStudents'],
      enrolledStudents: List<String>.from(json['enrolledStudents']),
      tags: List<String>.from(json['tags']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Static method to create sample data
  static List<Course> getSampleCourses() {
    final now = DateTime.now();
    return [
      Course(
        id: '1',
        title: 'Flutter Development Masterclass',
        description: 'Complete Flutter development course covering widgets, state management, and app deployment.',
        instructor: 'John Smith',
        category: 'Mobile Development',
        price: 299.99,
        duration: 40,
        level: 'Intermediate',
        imageUrl: 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=Flutter',
        startDate: now.add(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 37)),
        maxStudents: 50,
        enrolledStudents: ['user1', 'user2', 'user3', 'user4', 'user5'],
        tags: ['Flutter', 'Mobile', 'Dart', 'Cross-platform'],
        isActive: true,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Course(
        id: '2',
        title: 'React Native Fundamentals',
        description: 'Learn React Native from scratch and build amazing mobile applications.',
        instructor: 'Sarah Johnson',
        category: 'Mobile Development',
        price: 249.99,
        duration: 35,
        level: 'Beginner',
        imageUrl: 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=React+Native',
        startDate: now.add(const Duration(days: 14)),
        endDate: now.add(const Duration(days: 49)),
        maxStudents: 40,
        enrolledStudents: ['user6', 'user7', 'user8'],
        tags: ['React Native', 'JavaScript', 'Mobile'],
        isActive: true,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Course(
        id: '3',
        title: 'Python for Data Science',
        description: 'Master Python programming for data analysis, machine learning, and visualization.',
        instructor: 'Dr. Michael Brown',
        category: 'Data Science',
        price: 399.99,
        duration: 60,
        level: 'Advanced',
        imageUrl: 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Python',
        startDate: now.add(const Duration(days: 21)),
        endDate: now.add(const Duration(days: 81)),
        maxStudents: 30,
        enrolledStudents: ['user9', 'user10', 'user11', 'user12'],
        tags: ['Python', 'Data Science', 'Machine Learning'],
        isActive: true,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Course(
        id: '4',
        title: 'Web Development Bootcamp',
        description: 'Full-stack web development using HTML, CSS, JavaScript, and Node.js.',
        instructor: 'Emily Davis',
        category: 'Web Development',
        price: 199.99,
        duration: 50,
        level: 'Beginner',
        imageUrl: 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Web+Dev',
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 55)),
        maxStudents: 60,
        enrolledStudents: ['user13', 'user14', 'user15', 'user16', 'user17', 'user18'],
        tags: ['HTML', 'CSS', 'JavaScript', 'Node.js'],
        isActive: true,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Course(
        id: '5',
        title: 'UI/UX Design Principles',
        description: 'Learn design thinking, user research, and create stunning user interfaces.',
        instructor: 'Alex Wilson',
        category: 'Design',
        price: 179.99,
        duration: 25,
        level: 'Intermediate',
        imageUrl: 'https://via.placeholder.com/300x200/E91E63/FFFFFF?text=UI%2FUX',
        startDate: now.add(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 35)),
        maxStudents: 35,
        enrolledStudents: ['user19', 'user20'],
        tags: ['UI', 'UX', 'Design', 'Figma'],
        isActive: false,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }
}
