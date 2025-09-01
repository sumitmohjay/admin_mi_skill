import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import 'add_edit_event_screen.dart';

class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  EventCategory? _selectedCategoryFilter;
  EventMode? _selectedModeFilter;

  // Static data - will be replaced with API calls later
  List<Event> _events = [
    Event(
      id: 1,
      title: 'Flutter Workshop: Building Beautiful UIs',
      description: 'Learn advanced Flutter UI techniques and best practices for creating stunning mobile applications.',
      venue: 'Tech Hub Conference Room A',
      dateTime: DateTime.now().add(const Duration(days: 7)),
      maxAttendees: 50,
      price: 299.99,
      contactEmail: 'events@techhub.com',
      contactPhone: '+1-555-0123',
      meetingLink: 'https://meet.google.com/abc-defg-hij',
      tags: ['Flutter', 'Mobile Development', 'UI/UX'],
      mode: EventMode.hybrid,
      category: EventCategory.workshop,
      resources: ['Presentation Slides', 'Code Examples', 'Certificate'],
      imageUrl: 'https://via.placeholder.com/300x200?text=Flutter+Workshop',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      currentAttendees: 32,
    ),
    Event(
      id: 2,
      title: 'AI & Machine Learning Seminar',
      description: 'Explore the latest trends in artificial intelligence and machine learning technologies.',
      venue: 'Innovation Center Auditorium',
      dateTime: DateTime.now().add(const Duration(days: 14)),
      maxAttendees: 100,
      price: 199.99,
      contactEmail: 'ai@innovationcenter.com',
      contactPhone: '+1-555-0456',
      tags: ['AI', 'Machine Learning', 'Technology'],
      mode: EventMode.offline,
      category: EventCategory.seminar,
      resources: ['Research Papers', 'Demo Videos'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      currentAttendees: 78,
    ),
    Event(
      id: 3,
      title: 'Remote Team Management Training',
      description: 'Best practices for managing distributed teams and remote collaboration.',
      venue: 'Online Platform',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      maxAttendees: 30,
      contactEmail: 'training@remotework.com',
      meetingLink: 'https://zoom.us/j/123456789',
      tags: ['Management', 'Remote Work', 'Leadership'],
      mode: EventMode.online,
      category: EventCategory.training,
      resources: ['Training Manual', 'Templates', 'Tools List'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      currentAttendees: 25,
    ),
    Event(
      id: 4,
      title: 'Tech Networking Mixer',
      description: 'Connect with fellow tech professionals and expand your network.',
      venue: 'Downtown Business Center',
      dateTime: DateTime.now().add(const Duration(days: 21)),
      maxAttendees: 80,
      price: 25.00,
      contactEmail: 'mixer@technetwork.com',
      contactPhone: '+1-555-0789',
      tags: ['Networking', 'Technology', 'Career'],
      mode: EventMode.offline,
      category: EventCategory.networking,
      resources: ['Name Tags', 'Business Card Holder'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      currentAttendees: 45,
    ),
  ];

  List<Event> get filteredEvents {
    List<Event> filtered = _events;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        return event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.venue.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Apply category filter
    if (_selectedCategoryFilter != null) {
      filtered = filtered.where((event) => event.category == _selectedCategoryFilter).toList();
    }

    // Apply mode filter
    if (_selectedModeFilter != null) {
      filtered = filtered.where((event) => event.mode == _selectedModeFilter).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Create, manage and monitor events',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _navigateToAddEvent(),
                icon: const Icon(Icons.add),
                label: const Text('Create Event'),
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
          const SizedBox(height: 24),

          // Stats Cards - 2x2 Grid
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Events',
                      '${_events.length}',
                      Icons.event,
                      const Color(0xFF9C27B0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Upcoming',
                      '${_events.where((e) => e.dateTime.isAfter(DateTime.now())).length}',
                      Icons.schedule,
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
                      'Total Attendees',
                      '${_events.fold(0, (sum, event) => sum + event.currentAttendees)}',
                      Icons.people,
                      const Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Revenue',
                      '\$${_events.fold(0.0, (sum, event) => sum + ((event.price ?? 0) * event.currentAttendees)).toStringAsFixed(0)}',
                      Icons.attach_money,
                      const Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search and Filter Section
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search events...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  'Category',
                  _selectedCategoryFilter?.displayName ?? 'All Categories',
                  () => _showCategoryFilter(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  'Mode',
                  _selectedModeFilter?.displayName ?? 'All Modes',
                  () => _showModeFilter(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Events List
          Expanded(
            child: Container(
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
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 6, child: Text('Event', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        Expanded(flex: 3, child: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        // Expanded(flex: 2, child: Text('Attendees', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        SizedBox(width: 50, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                      ],
                    ),
                  ),
                  // Events List
                  Expanded(
                    child: filteredEvents.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = filteredEvents[index];
                              return _buildEventRow(event);
                            },
                          ),
                  ),
                ],
              ),
            ),
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
        borderRadius: BorderRadius.circular(8),
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
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventRow(Event event) {
    final isUpcoming = event.dateTime.isAfter(DateTime.now());
    // final attendancePercentage = (event.currentAttendees / event.maxAttendees * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: Row(
        children: [
          // Event Info
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: event.category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        event.category.displayName,
                        style: TextStyle(
                          color: event.category.color,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (event.price != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '\$${event.price!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFFFF9800),
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          'FREE',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  event.venue,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Date & Time
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd').format(event.dateTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(event.dateTime),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Attendees - Commented out
          // Expanded(
          //   flex: 2,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         '${event.currentAttendees}/${event.maxAttendees}',
          //         style: const TextStyle(
          //           fontWeight: FontWeight.w500,
          //           fontSize: 11,
          //         ),
          //       ),
          //       const SizedBox(height: 3),
          //       LinearProgressIndicator(
          //         value: event.currentAttendees / event.maxAttendees,
          //         backgroundColor: Colors.grey[200],
          //         valueColor: AlwaysStoppedAnimation<Color>(
          //           attendancePercentage >= 80
          //               ? const Color(0xFFF44336)
          //               : attendancePercentage >= 60
          //                   ? const Color(0xFFFF9800)
          //                   : const Color(0xFF4CAF50),
          //         ),
          //         minHeight: 3,
          //       ),
          //     ],
          //   ),
          // ),
          // Status
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: isUpcoming ? const Color(0xFF4CAF50).withOpacity(0.1) : const Color(0xFFF44336).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isUpcoming ? 'Up' : 'Past',
                style: TextStyle(
                  color: isUpcoming ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Actions
          SizedBox(
            width: 50,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 16, color: Colors.grey),
              onSelected: (value) => _handleEventAction(value, event),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16, color: Color(0xFF9C27B0)),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Color(0xFFF44336)),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: Color(0xFF2196F3)),
                      SizedBox(width: 8),
                      Text('View Details'),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first event to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddEvent(),
            icon: const Icon(Icons.add),
            label: const Text('Create Event'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditEventScreen(
          onSave: (event) {
            setState(() {
              _events.add(event.copyWith(
                id: _events.length + 1,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ));
            });
          },
        ),
      ),
    );
  }

  void _handleEventAction(String action, Event event) {
    switch (action) {
      case 'edit':
        _navigateToEditEvent(event);
        break;
      case 'delete':
        _showDeleteDialog(event);
        break;
      case 'view':
        _showEventDetails(event);
        break;
    }
  }

  void _navigateToEditEvent(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditEventScreen(
          event: event,
          onSave: (updatedEvent) {
            setState(() {
              final index = _events.indexWhere((e) => e.id == event.id);
              if (index != -1) {
                _events[index] = updatedEvent.copyWith(updatedAt: DateTime.now());
              }
            });
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _events.removeWhere((e) => e.id == event.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Event "${event.title}" deleted successfully')),
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

  void _showEventDetails(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${event.description}'),
              const SizedBox(height: 8),
              Text('Venue: ${event.venue}'),
              const SizedBox(height: 8),
              Text('Date: ${DateFormat('MMM dd, yyyy - hh:mm a').format(event.dateTime)}'),
              const SizedBox(height: 8),
              Text('Attendees: ${event.currentAttendees}/${event.maxAttendees}'),
              if (event.price != null) ...[
                const SizedBox(height: 8),
                Text('Price: \$${event.price!.toStringAsFixed(2)}'),
              ],
              if (event.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Tags: ${event.tags.join(', ')}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCategoryFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Categories'),
              onTap: () {
                setState(() {
                  _selectedCategoryFilter = null;
                });
                Navigator.pop(context);
              },
              selected: _selectedCategoryFilter == null,
            ),
            ...EventCategory.values.map((category) => ListTile(
                  title: Text(category.displayName),
                  onTap: () {
                    setState(() {
                      _selectedCategoryFilter = category;
                    });
                    Navigator.pop(context);
                  },
                  selected: _selectedCategoryFilter == category,
                )),
          ],
        ),
      ),
    );
  }

  void _showModeFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Modes'),
              onTap: () {
                setState(() {
                  _selectedModeFilter = null;
                });
                Navigator.pop(context);
              },
              selected: _selectedModeFilter == null,
            ),
            ...EventMode.values.map((mode) => ListTile(
                  title: Text(mode.displayName),
                  leading: Icon(mode.icon, size: 20),
                  onTap: () {
                    setState(() {
                      _selectedModeFilter = mode;
                    });
                    Navigator.pop(context);
                  },
                  selected: _selectedModeFilter == mode,
                )),
          ],
        ),
      ),
    );
  }
}
