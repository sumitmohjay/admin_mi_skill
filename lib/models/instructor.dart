class Instructor {
  final String id;
  String name;
  String email;
  String phone;
  String specialization;
  String bio;
  final String profileImage;
  final double rating;
  final int totalStudents;
  final int totalCourses;
  final int liveSessions;
  final int uploadedVideos;
  final int quizzesCreated;
  List<String> skills;
  final DateTime joinDate;
  bool isActive;

  Instructor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.bio,
    required this.profileImage,
    required this.rating,
    required this.totalStudents,
    required this.totalCourses,
    required this.liveSessions,
    required this.uploadedVideos,
    required this.quizzesCreated,
    required this.skills,
    required this.joinDate,
    required this.isActive,
  });

  static List<Instructor> getSampleInstructors() {
    return [
      Instructor(
        id: '1',
        name: 'John Smith',
        email: 'john.smith@example.com',
        phone: '+1 234 567 8900',
        specialization: 'Mobile Development',
        bio: 'Experienced Flutter developer with 8+ years in mobile app development. Passionate about creating beautiful and functional mobile applications.',
        profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
        rating: 4.8,
        totalStudents: 1250,
        totalCourses: 5,
        liveSessions: 12,
        uploadedVideos: 45,
        quizzesCreated: 18,
        skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
        joinDate: DateTime(2022, 3, 15),
        isActive: true,
      ),
      Instructor(
        id: '2',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@example.com',
        phone: '+1 234 567 8901',
        specialization: 'React Native Development',
        bio: 'Full-stack developer specializing in React Native and Node.js. Expert in building scalable mobile and web applications.',
        profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
        rating: 4.9,
        totalStudents: 980,
        totalCourses: 4,
        liveSessions: 8,
        uploadedVideos: 32,
        quizzesCreated: 14,
        skills: ['React Native', 'JavaScript', 'Node.js', 'MongoDB'],
        joinDate: DateTime(2021, 8, 22),
        isActive: true,
      ),
      Instructor(
        id: '3',
        name: 'Michael Chen',
        email: 'michael.chen@example.com',
        phone: '+1 234 567 8902',
        specialization: 'UI/UX Design',
        bio: 'Creative designer with expertise in user interface and user experience design. Focused on creating intuitive and engaging digital experiences.',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        rating: 4.7,
        totalStudents: 750,
        totalCourses: 3,
        liveSessions: 6,
        uploadedVideos: 28,
        quizzesCreated: 10,
        skills: ['Figma', 'Adobe XD', 'Sketch', 'Prototyping'],
        joinDate: DateTime(2022, 1, 10),
        isActive: true,
      ),
      Instructor(
        id: '4',
        name: 'Emily Davis',
        email: 'emily.davis@example.com',
        phone: '+1 234 567 8903',
        specialization: 'Web Development',
        bio: 'Frontend specialist with deep knowledge of modern web technologies. Passionate about responsive design and performance optimization.',
        profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        rating: 4.6,
        totalStudents: 650,
        totalCourses: 4,
        liveSessions: 10,
        uploadedVideos: 38,
        quizzesCreated: 22,
        skills: ['React', 'Vue.js', 'TypeScript', 'CSS3'],
        joinDate: DateTime(2021, 11, 5),
        isActive: true,
      ),
      Instructor(
        id: '5',
        name: 'David Wilson',
        email: 'david.wilson@example.com',
        phone: '+1 234 567 8904',
        specialization: 'Backend Development',
        bio: 'Backend engineer with expertise in scalable server architectures. Experienced in microservices and cloud technologies.',
        profileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        rating: 4.5,
        totalStudents: 420,
        totalCourses: 2,
        liveSessions: 4,
        uploadedVideos: 18,
        quizzesCreated: 8,
        skills: ['Python', 'Django', 'PostgreSQL', 'AWS'],
        joinDate: DateTime(2023, 2, 18),
        isActive: false,
      ),
    ];
  }

  String get initials {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }
}
