import 'package:flutter/material.dart';
import '../theme/pinkz_colors.dart';

class PinkzInput extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final bool enabled;
  final bool showCharacterCount;
  final int? maxLength;
  final int maxLines;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const PinkzInput({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.enabled = true,
    this.showCharacterCount = false,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    this.focusNode,
    this.contentPadding,
  });

  @override
  State<PinkzInput> createState() => _PinkzInputState();
}

class _PinkzInputState extends State<PinkzInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _obscured = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscured = widget.obscureText;
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          onChanged: (value) {
            setState(() {});
            widget.onChanged?.call(value);
          },
          validator: widget.validator,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: widget.enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(0.38),
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            errorText: widget.errorText,
            counterText:
                widget.showCharacterCount && widget.maxLength != null
                    ? '${_controller.text.length}/${widget.maxLength}'
                    : null,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: _hasFocus
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixTap ?? _toggleObscure,
                    child: Icon(
                      widget.obscureText
                          ? (_obscured ? Icons.visibility_off : Icons.visibility)
                          : widget.suffixIcon,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  void _toggleObscure() {
    if (widget.obscureText) {
      setState(() => _obscured = !_obscured);
    }
  }
}
