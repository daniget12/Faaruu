import 'package:flutter/material.dart';
import '../data/mezmur_data.dart';
import '../models/mezmur.dart';
import '../widgets/mezmur_card.dart';
import 'detail_screen.dart';
import 'events_screen.dart';
import 'notes_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _MezmurListTab(),
    const EventsScreen(),
    const NotesScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6B2737),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Mezmur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Ayyanoota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_outlined),
            activeIcon: Icon(Icons.note),
            label: 'Yaadannoo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: "Wa'ee",
          ),
        ],
      ),
    );
  }
}

class _MezmurListTab extends StatefulWidget {
  const _MezmurListTab();

  @override
  State<_MezmurListTab> createState() => _MezmurListTabState();
}

class _MezmurListTabState extends State<_MezmurListTab> {
  late List<Mezmur> _allMezmurs;
  late List<Mezmur> _filtered;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Sort: Oromo first A-Z, then Amharic/Bilingual A-Z
    _allMezmurs = MezmurData.getMezmurs()
      ..sort((a, b) {
        if (a.language == 'Oromo' && b.language != 'Oromo') return -1;
        if (a.language != 'Oromo' && b.language == 'Oromo') return 1;
        return a.title.compareTo(b.title);
      });
    _filtered = List.from(_allMezmurs);
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(_allMezmurs)
          : _allMezmurs
              .where((m) =>
                  m.title.toLowerCase().contains(q) ||
                  m.fullText.toLowerCase().contains(q))
              .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filtered = List.from(_allMezmurs);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2737),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white70,
                decoration: const InputDecoration(
                  hintText: 'Barbaadi...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                'Baafata Faaruu',
                style:
                    TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF6B2737).withOpacity(0.05),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.library_music,
                    size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(
                  '${_filtered.length} Mezmura',
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      'Hin argamne.',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final mezmur = _filtered[index];
                      final displayNum = _allMezmurs.indexOf(mezmur) + 1;
                      return MezmurCard(
                        mezmur: mezmur,
                        displayNumber: displayNum,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                mezmur: mezmur,
                                displayNumber: displayNum,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
