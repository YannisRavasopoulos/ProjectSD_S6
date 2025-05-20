import 'package:flutter/material.dart';
import 'package:frontend/ui/page/home/suggestion_list.dart';

class MapSearchBar extends StatefulWidget {
  const MapSearchBar({super.key});

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _allSuggestions = [
    'New York',
    'Los Angeles',
    'San Francisco',
    'Chicago',
    'Houston',
    'Miami',
    'Seattle',
  ];
  List<String> _filteredSuggestions = [];

  void _onSearchChanged(String query) {
    setState(() {
      _filteredSuggestions =
          _allSuggestions
              .where(
                (suggestion) =>
                    suggestion.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _onSuggestionSelected(int index) {}

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 10,
      right: 10,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16.0),
              ),
              onChanged: _onSearchChanged,
            ),
            if (_filteredSuggestions.isNotEmpty)
              Divider(height: 1, color: Colors.grey.shade300),
            if (_filteredSuggestions.isNotEmpty)
              SuggestionList(
                suggestions: _filteredSuggestions,
                onSuggestionSelected: _onSuggestionSelected,
              ),
          ],
        ),
      ),
    );
  }
}
