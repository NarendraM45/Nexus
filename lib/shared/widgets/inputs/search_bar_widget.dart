import 'package:flutter/material.dart';
import '../../../features/auth/widgets/glass_text_field.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isFocused ? constraints.maxWidth : constraints.maxWidth * 0.6,
            child: Focus(
              onFocusChange: (focus) => setState(() => _isFocused = focus),
              child: const GlassTextField(
                hintText: 'Search...',
                prefixIcon: Icons.search,
              ),
            ),
          ),
        );
      }
    );
  }
}
