import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For saving
import 'dart:convert'; // For jsonEncode/Decode

// Assuming admin_feedback.dart is in the same directory or correctly imported
// This import gives access to the FeedbackEntry class
import 'admin_feedback.dart';

// FeedbackMessage for the local chat UI (could be different from FeedbackEntry)
class FeedbackMessage {
  final String content;
  final String sender;
  final DateTime timestamp;

  FeedbackMessage({
    required this.content,
    required this.sender,
    required this.timestamp,
  });
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<FeedbackMessage> _messages = [
    FeedbackMessage(
      content: 'I had a great experience with the delivery service!',
      sender: 'User',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    FeedbackMessage(
      content: 'The food arrived cold.',
      sender: 'User',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    FeedbackMessage(
      content: 'Thank you for your initial feedback! We are always working to improve.',
      sender: 'Admin',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  FeedbackEntry? _latestUserFeedbackEntryForNav; // To pass if navigating immediately
  static const String _feedbackStorageKey = 'admin_feedback_entries'; // MUST MATCH AdminFeedbackScreen

  Future<void> _persistFeedbackEntry(FeedbackEntry entryToSave) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 1. Load existing entries
      final List<String>? jsonList = prefs.getStringList(_feedbackStorageKey);
      List<FeedbackEntry> allEntries = [];
      if (jsonList != null) {
        allEntries = jsonList
            .map((jsonString) => FeedbackEntry.fromJson(jsonDecode(jsonString) as Map<String, dynamic>))
            .toList();
      }
      // 2. Add the new entry (avoid exact duplicates if necessary, though timestamp usually handles this)
      if (!allEntries.any((e) => e.timestamp == entryToSave.timestamp && e.feedbackText == entryToSave.feedbackText)) {
        allEntries.add(entryToSave);
      }

      // 3. Sort (optional, admin screen also sorts, but good for consistency)
      allEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // 4. Convert back to list of JSON strings
      final List<String> updatedJsonList =
      allEntries.map((entry) => jsonEncode(entry.toJson())).toList();

      // 5. Save
      await prefs.setStringList(_feedbackStorageKey, updatedJsonList);
      print("FeedbackScreen: User feedback persisted.");
    } catch (e) {
      print("Error persisting user feedback: $e");
      _showSnackBar("Could not save feedback. Please try again.");
    }
  }

  void _sendFeedback() {
    String feedbackContent = _feedbackController.text.trim();
    if (feedbackContent.isEmpty) {
      _showSnackBar('Please write your feedback before sending.');
      return;
    }

    final DateTime now = DateTime.now();

    // Create FeedbackEntry for persistence and potential direct navigation
    final FeedbackEntry userFeedbackEntry = FeedbackEntry(
      customerName: 'User', // Replace with actual user ID/name if available
      feedbackText: feedbackContent,
      timestamp: now,
    );

    _latestUserFeedbackEntryForNav = userFeedbackEntry; // Store for immediate navigation

    // Persist this feedback entry
    _persistFeedbackEntry(userFeedbackEntry);

    // Update local chat UI
    if (mounted) {
      setState(() {
        _messages.add(FeedbackMessage(
          content: feedbackContent,
          sender: 'User',
          timestamp: now,
        ));

        // Simulate admin auto-reply
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _messages.add(FeedbackMessage(
                content: 'Thank you for your feedback! We are always working to improve.',
                sender: 'Admin',
                timestamp: DateTime.now(),
              ));
            });
            _scrollToBottom();
          }
        });
      });
    }

    _feedbackController.clear();
    _scrollToBottom();
    _showSnackBar('Feedback sent! Tap title for Admin View (Demo).');
  }

  void _navigateToAdminView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Pass the most recent feedback entry directly for potentially faster UI update
        // on the admin screen if it's opened immediately.
        // The admin screen will also load from shared_preferences.
        builder: (context) => AdminFeedbackScreen(newFeedback: _latestUserFeedbackEntryForNav),
      ),
    ).then((_) {
      // Optional: Clear if you only want to pass it once
      // _latestUserFeedbackEntryForNav = null;
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) { // Double check after frame
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: _navigateToAdminView,
          child: const Text(
            'Feedback & Support (Tap for Admin)',
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.sender == 'User';
                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(10.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.red.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUserMessage ? const Radius.circular(12) : Radius.zero,
                        bottomRight: isUserMessage ? Radius.zero : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isUserMessage ? Colors.red.shade900 : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('hh:mm a').format(message.timestamp),
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feedbackController,
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Type your feedback here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _sendFeedback,
                  backgroundColor: Colors.red,
                  elevation: 0,
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}