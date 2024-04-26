import 'dart:async';
import 'package:flutter/material.dart';

import '../../theme/palette.dart';

class DebouncedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Duration debounceDuration;

  DebouncedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _DebouncedButtonState createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  bool _isProcessing = false;
  Timer? _debounceTimer;

  void _handleTap() {
    if (_isProcessing) return;

    _isProcessing = true;
    widget.onPressed();

    _debounceTimer = Timer(widget.debounceDuration, () {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.themeColor,
      ),
      onPressed: _handleTap,
      child: widget.child,
    );
  }
}
