import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../services/api_service.dart';
import '../../models/course.dart';

class AddEditCourseScreen extends StatefulWidget {
  final Course? course;

  const AddEditCourseScreen({super.key, this.course});

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedLevel = 'beginner';
  bool _published = true;

  // Dropdown data
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _subcategories = [];
  List<Map<String, dynamic>> _instructors = [];
  String? _selectedCategoryId;
  String? _selectedSubcategoryId;
  String? _selectedInstructorId;
  // File uploads
  File? _selectedThumbnail;
  Uint8List? _selectedThumbnailBytes;
  File? _selectedIntroVideo;
  bool _isUploading = false;
  bool _isCreating = false;

  // Uploaded URLs
  String? _uploadedThumbnailUrl;
  String? _uploadedIntroVideoUrl;

  // Course sections
  final List<CourseSectionData> _sections = [];

  bool get isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadInstructors();
    if (isEditing) {
      _populateFields();
    } else {
      _addNewSection();
    }
  }

  void _populateFields() {
    final course = widget.course!;
    _titleController.text = course.title;
    _descriptionController.text = course.description;
    _priceController.text = course.price.toString();
    _selectedLevel = course.level;
    _published = course.published;
    
    // Set dropdown values for editing
    _selectedCategoryId = course.category.id;
    _selectedSubcategoryId = course.subcategory.id;
    _selectedInstructorId = course.instructor.id;
    
    // Load subcategories for the selected category
    if (_selectedCategoryId != null) {
      _loadSubcategories(_selectedCategoryId!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Course' : 'Create Course'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: (_isCreating || _isUploading) ? null : _saveCourse,
            child: (_isCreating || _isUploading)
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_isUploading ? 'UPLOADING...' : 'CREATING...'),
                    ],
                  )
                : const Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _buildSectionHeader('Basic Information', Icons.info_outline),
              const SizedBox(height: 16),
              _buildCard([
                _buildTextField(
                  controller: _titleController,
                  label: 'Course Title',
                  hint: 'Enter course title',
                  validator: isEditing ? null : (value) => value?.isEmpty == true ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter course description',
                  maxLines: 3,
                  validator: isEditing ? null : (value) => value?.isEmpty == true ? 'Description is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: 'Price (₹)',
                  hint: 'Enter course price',
                  keyboardType: TextInputType.number,
                  validator: isEditing ? null : (value) => value?.isEmpty == true ? 'Price is required' : null,
                ),
                const SizedBox(height: 16),
                _buildLevelDropdown(),
                const SizedBox(height: 16),
                _buildPublishedSwitch(),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                _buildSubcategoryDropdown(),
                const SizedBox(height: 16),
                _buildInstructorDropdown(),
              ]),

              const SizedBox(height: 24),

              // Media Files
              _buildSectionHeader('Media Files', Icons.attach_file),
              const SizedBox(height: 16),
              _buildCard([
                _buildFileUploadSection(),
              ]),

              const SizedBox(height: 24),

              // Course Sections
              _buildSectionHeader('Course Content', Icons.library_books),
              const SizedBox(height: 16),
              _buildCard([
                _buildSectionsSection(),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF9C27B0), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9C27B0)),
        ),
      ),
    );
  }

  Widget _buildLevelDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedLevel,
      decoration: InputDecoration(
        labelText: 'Level',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9C27B0)),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
        DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
        DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedLevel = value!;
        });
      },
    );
  }

  Widget _buildPublishedSwitch() {
    return Row(
      children: [
        const Text(
          'Published',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Switch(
          value: _published,
          onChanged: (value) {
            setState(() {
              _published = value;
            });
          },
          activeThumbColor: const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        Row(
          children: [
            const Text(
              'Course Thumbnail',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickThumbnail,
              icon: const Icon(Icons.add_photo_alternate, size: 18),
              label: const Text('Add Thumbnail'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedThumbnail != null || _selectedThumbnailBytes != null) ...[
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb && _selectedThumbnailBytes != null
                      ? Image.memory(
                          _selectedThumbnailBytes!,
                          width: 120,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                      : _selectedThumbnail != null
                          ? Image.file(
                              _selectedThumbnail!,
                              width: 120,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 120,
                              height: 90,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedThumbnail = null;
                        _selectedThumbnailBytes = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No thumbnail selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Intro Video
        Row(
          children: [
            const Text(
              'Intro Video',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickIntroVideo,
              icon: const Icon(Icons.video_call, size: 18),
              label: const Text('Add Intro Video'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedIntroVideo != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.videocam, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedIntroVideo!.path.split('/').last,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIntroVideo = null;
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
          ),
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No intro video selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Course Sections',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _addNewSection,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Section'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._sections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          return _buildSectionCard(section, index);
        }),
      ],
    );
  }

  Widget _buildSectionCard(CourseSectionData section, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Section ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _removeSection(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: section.titleController,
              decoration: const InputDecoration(
                labelText: 'Section Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: section.descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Section Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Videos:', style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _pickSectionVideo(index),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Video'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...section.videos.asMap().entries.map((videoEntry) {
              final videoIndex = videoEntry.key;
              final video = videoEntry.value;
              return _buildVideoItem(video, index, videoIndex);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoItem(CourseVideoData video, int sectionIndex, int videoIndex) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.videocam, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  video.file?.path.split('/').last ?? 'No video selected',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                onPressed: () => _removeVideo(sectionIndex, videoIndex),
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: video.titleController,
            decoration: const InputDecoration(
              labelText: 'Video Title',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: video.descriptionController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Video Description',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickThumbnail() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _isUploading = true;
        });

        Map<String, dynamic> uploadResult;
        if (kIsWeb) {
          // For web, read as bytes and upload immediately
          final bytes = await image.readAsBytes();
          uploadResult = await ApiService.uploadCourseImage('thumbnail.jpg', imageBytes: bytes);
          setState(() {
            _selectedThumbnailBytes = Uint8List.fromList(bytes);
            _selectedThumbnail = null;
          });
        } else {
          // For mobile, use File and upload immediately
          uploadResult = await ApiService.uploadCourseImage(image.path);
          setState(() {
            _selectedThumbnail = File(image.path);
            _selectedThumbnailBytes = null;
          });
        }

        if (uploadResult['success'] == true && uploadResult['data'] != null) {
          setState(() {
            _uploadedThumbnailUrl = uploadResult['data'].toString();
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thumbnail uploaded successfully'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        } else {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload thumbnail: ${uploadResult['message']}')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _pickIntroVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );
      
      if (result != null) {
        setState(() {
          _isUploading = true;
        });

        Map<String, dynamic> uploadResult;
        if (kIsWeb) {
          // For web, read as bytes and upload immediately
          final bytes = result.files.first.bytes;
          uploadResult = await ApiService.uploadCourseImage(result.files.first.name, imageBytes: bytes);
          setState(() {
            _selectedIntroVideo = File(result.files.first.name);
            // Store video file for upload
          });
        } else {
          // For mobile, use file path and upload immediately
          uploadResult = await ApiService.uploadCourseVideo(result.files.first.path!);
          setState(() {
            _selectedIntroVideo = File(result.files.first.path!);
            // Video file stored for upload
          });
        }

        if (uploadResult['success'] == true && uploadResult['data'] != null) {
          setState(() {
            _uploadedIntroVideoUrl = uploadResult['data'].toString();
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Intro video uploaded successfully'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        } else {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload intro video: ${uploadResult['message']}')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<void> _pickSectionVideo(int sectionIndex) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );
      
      if (result != null) {
        setState(() {
          if (kIsWeb) {
            // For web, store bytes and file name
            _sections[sectionIndex].videos.add(CourseVideoData(
              file: File(result.files.first.name),
              bytes: result.files.first.bytes,
              titleController: TextEditingController(),
              descriptionController: TextEditingController(),
            ));
          } else {
            // For mobile, use the actual file
            _sections[sectionIndex].videos.add(CourseVideoData(
              file: File(result.files.first.path!),
              bytes: null,
              titleController: TextEditingController(),
              descriptionController: TextEditingController(),
            ));
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  void _addNewSection() {
    setState(() {
      _sections.add(CourseSectionData(
        titleController: TextEditingController(),
        descriptionController: TextEditingController(),
        videos: [],
      ));
    });
  }

  void _removeSection(int index) {
    setState(() {
      _sections.removeAt(index);
    });
  }

  void _removeVideo(int sectionIndex, int videoIndex) {
    setState(() {
      _sections[sectionIndex].videos.removeAt(videoIndex);
    });
  }

  // Load categories from API
  Future<void> _loadCategories() async {
    // Loading categories

    try {
      final result = await ApiService.getCategories();
      print('DEBUG Categories API Response: $result');
      if (result['success'] == true && result['data'] != null) {
        print('DEBUG Categories Data: ${result['data']}');
        setState(() {
          _categories = List<Map<String, dynamic>>.from(result['data']);
        });
        print('DEBUG Categories List Length: ${_categories.length}');
      } else {
        print('DEBUG Categories API Failed: ${result['message']}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    } finally {
      // Categories loaded
    }
  }

  // Load subcategories based on selected category
  Future<void> _loadSubcategories(String categoryId) async {
    // Loading subcategories
    setState(() {
      _subcategories = [];
      _selectedSubcategoryId = null;
    });

    try {
      final result = await ApiService.getSubcategories(categoryId);
      if (result['success'] == true && result['data'] != null) {
        setState(() {
          _subcategories = List<Map<String, dynamic>>.from(result['data']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load subcategories: $e')),
      );
    } finally {
      // Subcategories loaded
    }
  }

  // Load instructors from API
  Future<void> _loadInstructors() async {
    // Loading instructors

    try {
      final result = await ApiService.getInstructors(limit: 100); // Load more instructors
      print('DEBUG Instructors API Response: $result');
      if (result['success'] == true && result['data'] != null) {
        print('DEBUG Instructors Data: ${result['data']}');
        setState(() {
          _instructors = List<Map<String, dynamic>>.from(result['data']);
        });
        print('DEBUG Instructors List Length: ${_instructors.length}');
      } else {
        print('DEBUG Instructors API Failed: ${result['message']}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load instructors: $e')),
      );
    } finally {
      // Instructors loaded
    }
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCreating = true;
      });

      try {
        // Use uploaded URLs (files are already uploaded when selected)
        String? thumbnailUrl = _uploadedThumbnailUrl;
        String? introVideoUrl = _uploadedIntroVideoUrl;

        // Prepare sections data
        List<Map<String, dynamic>> sectionsData = [];
        
        for (int i = 0; i < _sections.length; i++) {
          final section = _sections[i];
          
          // Skip sections with empty titles
          String sectionTitle = section.titleController.text.trim();
          if (sectionTitle.isEmpty) {
            sectionTitle = 'Section ${i + 1}'; // Default title
          }
          
          List<Map<String, dynamic>> videosData = [];
          
          for (int j = 0; j < section.videos.length; j++) {
            final video = section.videos[j];
            String videoTitle = video.titleController.text.trim();
            if (videoTitle.isEmpty) {
              videoTitle = 'Video ${j + 1}'; // Default video title
            }
            
            videosData.add({
              'title': videoTitle,
              'description': video.descriptionController.text.trim().isEmpty 
                  ? 'Video description' 
                  : video.descriptionController.text.trim(),
              'url': '', // Section videos would need similar upload logic
              'durationSeconds': 0,
              'order': j + 1,
              'isFreePreview': false,
            });
          }
          
          sectionsData.add({
            'title': sectionTitle,
            'description': section.descriptionController.text.trim().isEmpty 
                ? 'Section description' 
                : section.descriptionController.text.trim(),
            'videos': videosData,
          });
        }
        
        // If no sections exist, create a default section
        if (sectionsData.isEmpty) {
          sectionsData.add({
            'title': 'Getting Started',
            'description': 'Introduction to the course',
            'videos': [],
          });
        }

        // Create or update course
        final courseResult = isEditing 
          ? await ApiService.updateCourse(
              courseId: widget.course!.id,
              category: _selectedCategoryId ?? '',
              subcategory: _selectedSubcategoryId ?? '',
              title: _titleController.text,
              description: _descriptionController.text,
              price: _priceController.text.isEmpty ? '0' : _priceController.text,
              level: _selectedLevel,
              published: _published ? 1 : 0,
              instructor: _selectedInstructorId ?? '',
              thumbnail: thumbnailUrl ?? widget.course!.thumbnail,
              introVideo: introVideoUrl != null ? {'url': introVideoUrl} : null,
              sections: sectionsData,
            )
          : await ApiService.createCourse(
              category: _selectedCategoryId ?? '',
              subcategory: _selectedSubcategoryId ?? '',
              title: _titleController.text,
              description: _descriptionController.text,
              price: _priceController.text.isEmpty ? '0' : _priceController.text,
              level: _selectedLevel,
              published: _published ? 1 : 0,
              instructor: _selectedInstructorId ?? '',
              thumbnail: thumbnailUrl ?? '',
              introVideo: introVideoUrl != null ? {'url': introVideoUrl} : null,
              sections: sectionsData,
            );

        setState(() {
          _isCreating = false;
        });

        if (courseResult['success'] == true) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing ? 'Course updated successfully' : 'Course created successfully'),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create course: ${courseResult['message']}')),
          );
        }
      } catch (e) {
        setState(() {
          _isCreating = false;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      decoration: InputDecoration(
        labelText: 'Category *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9C27B0)),
        ),
      ),
      validator: isEditing ? null : (value) => value == null ? 'Please select a category' : null,
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category['_id']?.toString() ?? category['id']?.toString(),
          child: Text(category['name'] ?? 'Unknown Category'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value;
          _selectedSubcategoryId = null; // Reset subcategory when category changes
          _subcategories = []; // Clear subcategories
          if (value != null) {
            _loadSubcategories(value);
          }
        });
      },
    );
  }

  Widget _buildSubcategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSubcategoryId,
      decoration: InputDecoration(
        labelText: 'Subcategory *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9C27B0)),
        ),
      ),
      validator: isEditing ? null : (value) => value == null ? 'Please select a subcategory' : null,
      items: _subcategories.map((subcategory) {
        return DropdownMenuItem(
          value: subcategory['_id']?.toString() ?? subcategory['id']?.toString(),
          child: Text(subcategory['name'] ?? 'Unknown Subcategory'),
        );
      }).toList(),
      onChanged: _selectedCategoryId == null ? null : (value) {
        setState(() {
          _selectedSubcategoryId = value;
        });
      },
    );
  }

  Widget _buildInstructorDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedInstructorId,
      decoration: InputDecoration(
        labelText: 'Instructor *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9C27B0)),
        ),
      ),
      validator: isEditing ? null : (value) => value == null ? 'Please select an instructor' : null,
      items: _instructors.map((instructor) {
        return DropdownMenuItem(
          value: instructor['_id']?.toString() ?? instructor['id']?.toString(),
          child: Text(instructor['name'] ?? 'Unknown Instructor'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedInstructorId = value;
        });
      },
    );
  }
}

class CourseSectionData {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<CourseVideoData> videos;

  CourseSectionData({
    required this.titleController,
    required this.descriptionController,
    required this.videos,
  });
}

class CourseVideoData {
  final File? file;
  final Uint8List? bytes;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  CourseVideoData({
    this.file,
    this.bytes,
    required this.titleController,
    required this.descriptionController,
  });
}