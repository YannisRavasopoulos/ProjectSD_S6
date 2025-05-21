import 'package:flutter/material.dart';
import 'package:frontend/ui/page/home/suggestion_list.dart';

class MapSearchBar extends StatefulWidget {
  final List<String> suggestions;
  final ValueChanged<int> onSuggestionSelected;
  final ValueChanged<String> onSearchChanged;

  const MapSearchBar({
    super.key,
    required this.suggestions,
    required this.onSearchChanged,
    required this.onSuggestionSelected,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search for a location',
            border: InputBorder.none,
            icon: const Icon(Icons.search),
          ),
          onChanged: widget.onSearchChanged,
        ),
        if (widget.suggestions.isNotEmpty)
          Divider(height: 1, color: Colors.grey.shade300),
        if (widget.suggestions.isNotEmpty)
          SuggestionList(
            suggestions: widget.suggestions,
            onSuggestionSelected: widget.onSuggestionSelected,
          ),
      ],
    );
  }
}
