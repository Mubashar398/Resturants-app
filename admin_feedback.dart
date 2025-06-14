import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:intl/intl.dart'; // For formatting the timestamp nicely

// Data model for a feedback entry
class FeedbackEntry {
  final String customerName;
  final String feedbackText;
  final DateTime timestamp;

  const FeedbackEntry({
    required this.customerName,
    required this.feedbackText,
    required this.timestamp,
  });

  // Method to convert a FeedbackEntry instance to a Map for JSON serialization
  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'feedbackText': feedbackText,
    'timestamp': timestamp.toIso8601String(), // Store timestamp as ISO 8601 string
  };

  // Factory constructor to create a FeedbackEntry instance from a Map (JSON)
  factory FeedbackEntry.fromJson(Map<String, dynamic> json) => FeedbackEntry(
    customerName: json['customerName'] as String,
    feedbackText: json['feedbackText'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String), // Parse ISO 8601 string
  );
}

class AdminFeedbackScreen extends StatefulWidget {
  final FeedbackEntry? newFeedback; // Optional: For immediate UI update if navigated with new data

  const AdminFeedbackScreen({super.key, this.newFeedback});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  List<FeedbackEntry> _feedbackEntries = [];
  bool _isLoading = true;
  static const String _feedbackStorageKey = 'admin_feedback_entries'; // Unique key for SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadFeedbackEntries();

    // If new feedback is passed directly, add it to the list for immediate display
    // and then trigger a save to ensure it's persisted with the rest.
    if (widget.newFeedback != null && mounted) {
      // Ensure it's not a duplicate if already loaded
      if (!_feedbackEntries.any((entry) =>
      entry.timestamp == widget.newFeedback!.timestamp &&
          entry.feedbackText == widget.newFeedback!.feedbackText)) {

        // Use WidgetsBinding to schedule the state update after the build phase
        // if initState is still ongoing or to avoid issues if called rapidly.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(mounted){
            setState(() {
              _feedbackEntries.add(widget.newFeedback!);
              _sortFeedbackEntries();
            });
            _saveFeedbackEntries(); // Save the updated list
          }
        });
      }
    }
  }

  Future<void> _loadFeedbackEntries() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(_feedbackStorageKey);
      if (jsonList != null && mounted) {
        setState(() {
          _feedbackEntries = jsonList
              .map((jsonString) => FeedbackEntry.fromJson(jsonDecode(jsonString) as Map<String, dynamic>))
              .toList();
          _sortFeedbackEntries();
        });
      }
    } catch (e) {
      print("Error loading feedback: $e");
      // Optionally show an error message to the user
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveFeedbackEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonList =
      _feedbackEntries.map((entry) => jsonEncode(entry.toJson())).toList();
      await prefs.setStringList(_feedbackStorageKey, jsonList);
      print("AdminFeedbackScreen: Feedback saved.");
    } catch (e) {
      print("Error saving feedback: $e");
    }
  }

  void _sortFeedbackEntries() {
    _feedbackEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
  }

  // Call this if you want to add feedback from within this screen (e.g., test button)
  // void _addAndPersistFeedback(FeedbackEntry entry) {
  //   if (mounted) {
  //     setState(() {
  //       _feedbackEntries.add(entry);
  //       _sortFeedbackEntries();
  //     });
  //     _saveFeedbackEntries();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Admin - Customer Feedback',
          style: TextStyle(
            fontFamily: 'RobotoSlab', // Ensure this font is in your project
            color: primaryRed,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadFeedbackEntries, // Allows manual refresh
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _feedbackEntries.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No feedback received yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
              onPressed: _loadFeedbackEntries,
            )
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _feedbackEntries.length,
        itemBuilder: (context, index) {
          final feedback = _feedbackEntries[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          feedback.customerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryRed,
                          ),
                        ),
                        Text(
                          DateFormat('MMM d, yyyy HH:mm').format(feedback.timestamp), // Example format
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feedback.feedbackText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}