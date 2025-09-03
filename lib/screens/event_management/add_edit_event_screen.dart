import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';

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

  DateTime? _selectedDateTime;
  EventMode _selectedMode = EventMode.offline;
  EventCategory _selectedCategory = EventCategory.workshop;
  List<String> _resources = [];
  String? _imageUrl;

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
    _selectedDateTime = event.dateTime;
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
            onPressed: _saveEvent,
            child: const Text(
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
                  validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter event description',
                  icon: Icons.description,
                  maxLines: 3,
                  validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
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
                  validator: (value) => value?.isEmpty == true ? 'Venue is required' : null,
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
                        if (value?.isEmpty == true) return 'Max attendees is required';
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
                        if (value?.isEmpty == true) return 'Price is required';
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
        const Text(
          'Date & Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDateTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: Color(0xFF9C27B0)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDateTime != null
                        ? DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime!)
                        : 'Select date and time',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDateTime != null ? Colors.black87 : Colors.grey[600],
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

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9C27B0),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF9C27B0),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
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

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
        return;
      }

      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final event = Event(
        id: widget.event?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        venue: _venueController.text,
        dateTime: _selectedDateTime!,
        maxAttendees: int.parse(_maxAttendeesController.text),
        price: _priceController.text.isEmpty ? null : double.parse(_priceController.text),
        contactEmail: _contactEmailController.text.isEmpty ? null : _contactEmailController.text,
        contactPhone: _contactPhoneController.text.isEmpty ? null : _contactPhoneController.text,
        meetingLink: _meetingLinkController.text.isEmpty ? null : _meetingLinkController.text,
        tags: tags,
        mode: _selectedMode,
        category: _selectedCategory,
        resources: _resources,
        imageUrl: _imageUrl,
        createdAt: widget.event?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        currentAttendees: widget.event?.currentAttendees ?? 0,
      );

      widget.onSave(event);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Event updated successfully' : 'Event created successfully'),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
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
