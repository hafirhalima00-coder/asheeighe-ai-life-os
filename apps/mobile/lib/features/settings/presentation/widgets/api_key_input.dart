import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class ApiKeyInput extends StatefulWidget {
  final String label;
  final String? value;
  final String? maskedValue;
  final ValueChanged<String?> onChanged;

  const ApiKeyInput({
    super.key,
    required this.label,
    this.value,
    this.maskedValue,
    required this.onChanged,
  });

  @override
  State<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends State<ApiKeyInput> {
  bool _obscured = true;
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(ApiKeyInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_isEditing) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      child: _isEditing
          ? Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  obscureText: _obscured,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(_obscured
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscured =
                                  !_obscured),
                        ),
                        IconButton(
                          icon: const Icon(
                              Icons.check,
                              color:
                                  AppTheme.primary),
                          onPressed: () {
                            widget.onChanged(
                                _controller.text);
                            setState(() =>
                                _isEditing =
                                    false);
                          },
                        ),
                      ],
                    ),
                  ),
                  autofocus: true,
                ),
              ],
            )
          : ListTile(
              leading: const Icon(Icons.key,
                  color: AppTheme.textSecondary,
                  size: 22),
              title: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Text(
                widget.maskedValue?.isNotEmpty == true
                    ? widget.maskedValue!
                    : 'Not configured',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.value != null
                      ? AppTheme.textSecondary
                      : AppTheme.textHint,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit,
                    color: AppTheme.textHint),
                onPressed: () => setState(
                    () => _isEditing = true),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
    );
  }
}
