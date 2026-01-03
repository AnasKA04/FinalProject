import 'package:flutter/material.dart';

import '../../../core/chat/store.dart';
import '../../../core/chat/chat_models.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
  final String otherUserId;
  final String otherUserName;

  const ChatListScreen({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatStore _store = ChatStore.instance;

  @override
  Widget build(BuildContext context) {
    final sessions = _store.sessionsForUser(widget.currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final bool currentIsTherapist =
              widget.currentUserId == _store.demoTherapistId;

          final session = _store.getOrCreateSession(
            patientId: currentIsTherapist
                ? widget.otherUserId
                : widget.currentUserId,
            therapistId: currentIsTherapist
                ? widget.currentUserId
                : widget.otherUserId,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                chatId: session.id,
                currentUserId: widget.currentUserId,
                otherUserName: widget.otherUserName,
              ),
            ),
          ).then((_) => setState(() {}));
        },
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('New chat'),
      ),
      body: sessions.isEmpty
          ? const Center(child: Text('No chats yet. Tap "New chat" to start.'))
          : ListView.separated(
        itemCount: sessions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final ChatSession s = sessions[i];

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(widget.otherUserName),
            subtitle: Text(_store.lastMessagePreview(s.id)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chatId: s.id,
                    currentUserId: widget.currentUserId,
                    otherUserName: widget.otherUserName,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
          );
        },
      ),
    );
  }
}
