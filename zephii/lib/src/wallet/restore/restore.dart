import 'package:flutter/material.dart';
import 'package:zephii/src/extensions/color.dart';
import 'package:zephii/src/uiwidgets/zbutton.dart';
import 'seedwords.dart';

class RestoreScreen extends StatefulWidget {
  const RestoreScreen({super.key});

  @override
  _RestoreScreenState createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> _selectedWords = [];
  String _filter = '';
  String _rawInput = '';
  final TextEditingController _searchController =
      TextEditingController(); // Add this line

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZephiiColors.zephPurp,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ZephiiColors.zephPurp,
        title: const Text('Restore Wallet'),
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          dividerColor: ZephiiColors.zephPurp,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Search & Select'),
            Tab(text: 'Raw Input'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildSearchSelectView(),
          buildRawInputView(),
        ],
      ),
    );
  }

  Widget buildSearchSelectView() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: _searchController, // Use the controller here
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search Seed Words',
                labelStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: SeedPhraseService.allWords
                  .where((word) => word.toLowerCase().contains(_filter
                      .toLowerCase())) // Improved case insensitive search
                  .map((word) => ListTile(
                        title:
                            Text(word, style: TextStyle(color: Colors.white)),
                        onTap: () {
                          if (!_selectedWords.contains(word)) {
                            setState(() {
                              _selectedWords.add(word);
                            });
                            _searchController.clear(); // Clear the search field
                            _filter = ''; // Reset the filter
                          }
                        },
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text('Selected Words: ${_selectedWords.join(', ')}',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      );

  Widget buildRawInputView() => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.grey),
                  labelText: 'Enter Seed Phrases',
                  helperText: 'Type your seed phrases separated by spaces',
                  helperStyle: TextStyle(color: Colors.grey)),
              onChanged: (value) {
                _rawInput = value;
              },
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            ZButton(
                text: "SUBMIT",
                onPressed: () {
                  setState(() {
                    _selectedWords = _rawInput
                        .split(' ')
                        .where((word) => word.isNotEmpty)
                        .toList();
                  });
                }),
            const SizedBox(height: 20),
            if (_selectedWords.isNotEmpty)
              Text('Entered Words: ${_selectedWords.join(', ')}',
                  style: TextStyle(color: Colors.white))
          ],
        ),
      );
}
