import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  final AutocompleteOptionsBuilder<String> suggestionsBuilder;
  final ValueChanged<String> onSuggestionSelected;
  final ValueChanged<String> onSearchChanged;

  const MapSearchBar({
    super.key,
    required this.suggestionsBuilder,
    required this.onSearchChanged,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      optionsBuilder: suggestionsBuilder,
      onSelected: onSuggestionSelected,
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 12.0,
            ),
            hintText: 'Search for a location',
            border: InputBorder.none,
            prefixIcon: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Open menu',
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: onFieldSubmitted,
              tooltip: 'Search',
            ),
          ),
          focusNode: focusNode,
          onChanged: onSearchChanged,
          controller: textEditingController,
        );
      },
    );
  }
}
