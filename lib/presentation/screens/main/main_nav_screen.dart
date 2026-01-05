import 'package:flutter/material.dart';

import '../../../core/models/user_role.dart';
import '../../../core/chat/store.dart';

// Tabs
import '../home/home_screen.dart';
import '../chat/chat_list_screen.dart';
import '../profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({
    super.key,
    required this.isAnonymous,
    this.role,
    this.displayName,
  });

  final bool isAnonymous;
  final UserRole? role;
  final String? displayName;

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final store = ChatStore.instance;

    final bool isTherapist = widget.role == UserRole.therapist;

    // Demo chat identities
    final currentUserId = isTherapist ? store.demoTherapistId : store.demoPatientId;
    final currentUserName = isTherapist
        ? "Therapist"
        : (widget.isAnonymous ? "Friend" : (widget.displayName ?? "You"));

    final otherUserId = isTherapist ? store.demoPatientId : store.demoTherapistId;
    final otherUserName = isTherapist ? "Patient" : "Therapist";

    final tabs = <Widget>[
      HomeScreen(
        isAnonymous: widget.isAnonymous,
        role: widget.role,
        displayName: widget.displayName,
        asTab: true,
      ),
      ChatListScreen(
        currentUserId: currentUserId,
        currentUserName: currentUserName,
        otherUserId: otherUserId,
        otherUserName: otherUserName,
      ),
      ProfileScreen(
        isAnonymous: widget.isAnonymous,
        role: widget.role ?? UserRole.patient,
        displayName: widget.displayName,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
