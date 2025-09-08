import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../models/event.dart';
import '../../services/api_service.dart';

class AddEditEventScreen extends StatefulWidget {
  final Event? event;
  final Function(Event) onSave;

  const AddEditEventScreen({
    super.key,
    this.event,
    required this.onSave,
  });

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _maxAttendeesController = TextEditingController();
  final _priceController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _tagsController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  EventMode _selectedMode = EventMode.offline;
  EventCategory _selectedCategory = EventCategory.workshop;
  List<String> _resources = [];
  String? _imageUrl;

  // File uploads
  final List<File> _selectedImages = [];
  final List<Uint8List> _selectedImageBytes = [];
  final List<File> _selectedVideos = [];
  final List<String> _uploadedImageUrls = []; // Store uploaded image URLs
  final List<String> _uploadedVideoUrls = []; // Store uploaded video URLs
  bool _isUploading = false;
  bool _isCreating = false;

  bool get isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final event = widget.event!;
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _venueController.text = event.venue;
    _maxAttendeesController.text = event.maxAttendees.toString();
    _priceController.text = event.price?.toString() ?? '';
    _contactEmailController.text = event.contactEmail ?? '';
    _contactPhoneController.text = event.contactPhone ?? '';
    _meetingLinkController.text = event.meetingLink ?? '';
    _tagsController.text = event.tags.join(', ');
    _selectedStartDate = event.dateTime;
    _selectedEndDate = event.dateTime.add(const Duration(days: 1));
    _selectedStartTime = TimeOfDay.fromDateTime(event.dateTime);
    _selectedEndTime = TimeOfDay.fromDateTime(event.dateTime.add(const Duration(hours: 2)));
    _selectedMode = event.mode;
    _selectedCategory = event.category;
    _resources = List.from(event.resources);
    _imageUrl = event.imageUrl;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Event' : 'Create Event'),
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
            onPressed: (_isCreating || _isUploading) ? null : _saveEvent,
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
              // Basic Information Section
              _buildSectionHeader('Basic Information', Icons.info_outline),
              const SizedBox(height: 16),
              _buildCard([
                _buildTextField(
                  controller: _titleController,
                  label: 'Event Title',
                  hint: 'Enter event title',
                  icon: Icons.title,
                  validator: null, // Made optional
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter event description',
                  icon: Icons.description,
                  maxLines: 3,
                  validator: null, // Made optional
                ),
                const SizedBox(height: 16),
                _buildResponsiveRow(
                  context,
                  children: [
                    _buildDropdown<EventCategory>(
                      label: 'Category',
                      value: _selectedCategory,
                      items: EventCategory.values,
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                      itemBuilder: (category) => Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: category.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(category.displayName),
                        ],
                      ),
                    ),
                    _buildDropdown<EventMode>(
                      label: 'Mode',
                      value: _selectedMode,
                      items: EventMode.values,
                      onChanged: (value) => setState(() => _selectedMode = value!),
                      itemBuilder: (mode) => Row(
                        children: [
                          Icon(mode.icon, size: 16),
                          const SizedBox(width: 8),
                          Text(mode.displayName),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 24),

              // Date, Time & Venue Section
              _buildSectionHeader('Date, Time & Venue', Icons.schedule),
              const SizedBox(height: 16),
              _buildCard([
                _buildDateTimePicker(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _venueController,
                  label: 'Venue',
                  hint: _selectedMode == EventMode.online ? 'Online Platform' : 'Enter venue address',
                  icon: _selectedMode == EventMode.online ? Icons.computer : Icons.location_on,
                  validator: null, // Made optional
                ),
              ]),
              const SizedBox(height: 24),

              // Capacity & Pricing Section
              _buildSectionHeader('Capacity & Pricing', Icons.people),
              const SizedBox(height: 16),
              _buildCard([
                const SizedBox(height: 16),
                _buildResponsiveRow(
                  context,
                  children: [
                    _buildTextField(
                      controller: _maxAttendeesController,
                      label: 'Max Attendees',
                      hint: 'Enter maximum attendees',
                      icon: Icons.people,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return null; // Made optional
                        final number = int.tryParse(value!);
                        if (number == null || number <= 0) return 'Enter a valid number';
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _priceController,
                      label: 'Price (₹)',
                      hint: 'Enter price',
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return null; // Made optional
                        final number = double.tryParse(value!);
                        if (number == null || number < 0) return 'Enter a valid price';
                        return null;
                      },
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 24),

              // Contact Information Section
              _buildSectionHeader('Contact Information', Icons.contact_mail),
              const SizedBox(height: 16),
              _buildCard([
                _buildTextField(
                  controller: _contactEmailController,
                  label: 'Contact Email',
                  hint: 'Enter contact email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _contactPhoneController,
                  label: 'Contact Phone',
                  hint: 'Enter contact phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
              ]),
              const SizedBox(height: 24),

              // Additional Details Section
              _buildSectionHeader('Additional Details', Icons.more_horiz),
              const SizedBox(height: 16),
              _buildCard([
                _buildTextField(
                  controller: _tagsController,
                  label: 'Tags',
                  hint: 'Enter tags separated by commas',
                  icon: Icons.tag,
                ),
                const SizedBox(height: 16),
                _buildResourcesSection(),
                const SizedBox(height: 16),
                _buildImageUrlField(),
              ]),
              
              const SizedBox(height: 24),
              _buildSectionHeader('Media Files', Icons.attach_file),
              const SizedBox(height: 16),
              _buildCard([
                _buildFileUploadSection(),
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
            blurRadius: 8,
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
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF9C27B0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required Widget Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              onChanged: onChanged,
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: itemBuilder(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Date & Time Section
        const Text(
          'Start Date & Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectStartDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.event, color: Color(0xFF4CAF50)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedStartDate != null && _selectedStartTime != null
                        ? '${DateFormat('MMM dd, yyyy').format(_selectedStartDate!)} at ${_selectedStartTime!.format(context)}'
                        : 'Select start date and time',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedStartDate != null ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // End Date & Time Section
        const Text(
          'End Date & Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectEndDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_available, color: Color(0xFFF44336)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedEndDate != null && _selectedEndTime != null
                        ? '${DateFormat('MMM dd, yyyy').format(_selectedEndDate!)} at ${_selectedEndTime!.format(context)}'
                        : 'Select end date and time',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedEndDate != null ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Images Section
        Row(
          children: [
            const Text(
              'Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickImages,
              icon: const Icon(Icons.add_photo_alternate, size: 18),
              label: const Text('Add Images'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedImages.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedImages.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb && index < _selectedImageBytes.length
                          ? Image.memory(
                              _selectedImageBytes[index],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              file,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImages.removeAt(index);
                            if (kIsWeb && index < _selectedImageBytes.length) {
                              _selectedImageBytes.removeAt(index);
                            }
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
              );
            }).toList(),
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
                'No images selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        
        const SizedBox(height: 16),
        
        // Videos Section
        Row(
          children: [
            const Text(
              'Videos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickVideos,
              icon: const Icon(Icons.video_call, size: 18),
              label: const Text('Add Videos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedVideos.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedVideos.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.videocam,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedVideos.removeAt(index);
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
                    Positioned(
                      bottom: 4,
                      left: 4,
                      right: 4,
                      child: Text(
                        file.path.split('/').last,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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
                'No videos selected',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Resources',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addResource,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Resource'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: _resources.isEmpty
              ? Text(
                  'No resources added',
                  style: TextStyle(color: Colors.grey[600]),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _resources.map((resource) => Chip(
                        label: Text(resource),
                        onDeleted: () => _removeResource(resource),
                        backgroundColor: const Color(0xFF9C27B0).withOpacity(0.1),
                        labelStyle: const TextStyle(color: Color(0xFF9C27B0)),
                        deleteIconColor: const Color(0xFF9C27B0),
                      )).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildImageUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Image URL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _imageUrl,
          onChanged: (value) => _imageUrl = value.isEmpty ? null : value,
          decoration: InputDecoration(
            hintText: 'Enter image URL (optional)',
            prefixIcon: const Icon(Icons.image, color: Color(0xFF9C27B0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        if (_imageUrl?.isNotEmpty == true) ...[
          const SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[100],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _selectStartDate() async {
    // Select start date
    final startDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Start Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (startDate != null) {
      // Select start time
      final startTime = await showTimePicker(
        context: context,
        initialTime: _selectedStartTime ?? TimeOfDay.now(),
        helpText: 'Select Start Time',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF4CAF50),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (startTime != null) {
        setState(() {
          _selectedStartDate = startDate;
          _selectedStartTime = startTime;
        });
      }
    }
  }

  Future<void> _selectEndDate() async {
    // Select end date
    final endDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? (_selectedStartDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 2))),
      firstDate: _selectedStartDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select End Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF44336),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (endDate != null) {
      // Select end time
      final endTime = await showTimePicker(
        context: context,
        initialTime: _selectedEndTime ?? TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 2))),
        helpText: 'Select End Time',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFF44336),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (endTime != null) {
        setState(() {
          _selectedEndDate = endDate;
          _selectedEndTime = endTime;
        });
      }
    }
  }

  void _addResource() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Resource'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter resource name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _resources.add(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeResource(String resource) {
    setState(() {
      _resources.remove(resource);
    });
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _isUploading = true;
        });

        // Upload images immediately when selected
        List<String> uploadedUrls = [];
        
        for (XFile image in images) {
          try {
            Map<String, dynamic> uploadResult;
            
            if (kIsWeb) {
              // For web, read as bytes and upload with proper filename
              final bytes = await image.readAsBytes();
              uploadResult = await ApiService.uploadEventImage(image.name, imageBytes: bytes);
            } else {
              // For mobile, upload file
              uploadResult = await ApiService.uploadEventImage(image.path);
            }
            
            if (uploadResult['success'] == true && uploadResult['data'] != null) {
              uploadedUrls.add(uploadResult['data'].toString());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to upload image: ${uploadResult['message']}')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error uploading image: $e')),
            );
          }
        }

        // Update state with uploaded URLs and files for display
        _uploadedImageUrls.addAll(uploadedUrls);
        
        // Keep files for display purposes
        if (kIsWeb) {
          List<Uint8List> imageBytesList = [];
          for (XFile image in images) {
            final bytes = await image.readAsBytes();
            imageBytesList.add(bytes);
          }
          _selectedImageBytes.addAll(imageBytesList);
          _selectedImages.addAll(images.map((image) => File(image.name)).toList());
        } else {
          _selectedImages.addAll(images.map((image) => File(image.path)).toList());
        }
        
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<void> _pickVideos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );
      
      if (result != null) {
        setState(() {
          _isUploading = true;
        });

        // Upload videos immediately when selected
        List<String> uploadedUrls = [];
        
        for (var file in result.files) {
          try {
            Map<String, dynamic> uploadResult;
            
            if (kIsWeb) {
              // For web, read as bytes and upload
              uploadResult = await ApiService.uploadEventVideo(file.name, videoBytes: file.bytes);
            } else {
              // For mobile, upload file
              uploadResult = await ApiService.uploadEventVideo(file.path!);
            }
            
            if (uploadResult['success'] == true && uploadResult['data'] != null) {
              uploadedUrls.add(uploadResult['data'].toString());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to upload video: ${uploadResult['message']}')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error uploading video: $e')),
            );
          }
        }

        // Update state with uploaded URLs and files for display
        _uploadedVideoUrls.addAll(uploadedUrls);
        
        // Keep files for display purposes
        if (kIsWeb) {
          _selectedVideos.addAll(result.files.map((file) => File(file.name)).toList());
        } else {
          _selectedVideos.addAll(result.paths.map((path) => File(path!)).toList());
        }
        
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking videos: $e')),
      );
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedStartDate == null || _selectedEndDate == null || _selectedStartTime == null || _selectedEndTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end dates with times')),
        );
        return;
      }

      setState(() {
        _isCreating = true;
      });

      try {
        // Use already uploaded URLs from when user selected files
        List<String> uploadedImageUrls = _uploadedImageUrls;
        List<String> uploadedVideoUrls = _uploadedVideoUrls;

        // Create or update event
        final tags = _tagsController.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();

        final Map<String, dynamic> eventResult;
        
        if (isEditing) {
          // Update existing event
          eventResult = await ApiService.updateEvent(
            eventId: widget.event!.id,
            title: _titleController.text.isEmpty ? 'Untitled Event' : _titleController.text,
            description: _descriptionController.text.isEmpty ? 'No description provided' : _descriptionController.text,
            location: _venueController.text.isEmpty ? 'TBD' : _venueController.text,
            category: _selectedCategory.name,
            eventType: _selectedMode.name,
            startDate: DateFormat('yyyy-MM-dd').format(_selectedStartDate!),
            endDate: DateFormat('yyyy-MM-dd').format(_selectedEndDate!),
            registrationDeadline: DateFormat('yyyy-MM-dd').format(_selectedStartDate!.subtract(const Duration(days: 1))),
            maxParticipants: _maxAttendeesController.text.isEmpty ? 0 : int.parse(_maxAttendeesController.text),
            tags: tags,
            startTime: '${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}',
            endTime: '${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}',
            contactEmail: _contactEmailController.text.isEmpty ? null : _contactEmailController.text,
            contactPhone: _contactPhoneController.text.isEmpty ? null : _contactPhoneController.text,
            images: uploadedImageUrls.isNotEmpty ? uploadedImageUrls : null,
            videos: uploadedVideoUrls.isNotEmpty ? uploadedVideoUrls : null,
          );
        } else {
          // Create new event
          eventResult = await ApiService.createEvent(
            title: _titleController.text.isEmpty ? 'Untitled Event' : _titleController.text,
            description: _descriptionController.text.isEmpty ? 'No description provided' : _descriptionController.text,
            location: _venueController.text.isEmpty ? 'TBD' : _venueController.text,
            category: _selectedCategory.name,
            eventType: _selectedMode.name,
            startDate: DateFormat('yyyy-MM-dd').format(_selectedStartDate!),
            endDate: DateFormat('yyyy-MM-dd').format(_selectedEndDate!),
            registrationDeadline: DateFormat('yyyy-MM-dd').format(_selectedStartDate!.subtract(const Duration(days: 1))),
            maxParticipants: _maxAttendeesController.text.isEmpty ? 0 : int.parse(_maxAttendeesController.text),
            tags: tags,
            startTime: '${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}',
            endTime: '${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}',
            contactEmail: _contactEmailController.text.isEmpty ? null : _contactEmailController.text,
            contactPhone: _contactPhoneController.text.isEmpty ? null : _contactPhoneController.text,
            images: uploadedImageUrls.isNotEmpty ? uploadedImageUrls : null,
            videos: uploadedVideoUrls.isNotEmpty ? uploadedVideoUrls : null,
          );
        }

        setState(() {
          _isCreating = false;
        });

        if (eventResult['success'] == true) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing ? 'Event updated successfully' : 'Event created successfully'),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create event: ${eventResult['message']}')),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _maxAttendeesController.dispose();
    _priceController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _meetingLinkController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
