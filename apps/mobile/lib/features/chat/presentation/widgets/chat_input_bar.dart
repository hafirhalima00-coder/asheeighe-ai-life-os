import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String message)? onSend;
  final bool isStreaming;

  const ChatInputBar({
    super.key,
    this.onSend,
    this.isStreaming = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isStreaming) return;
    widget.onSend?.call(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingMd,
            AppConstants.paddingSm,
            AppConstants.paddingMd,
            AppConstants.paddingSm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.mic_outlined,
                    color: AppTheme.textSecondary,
                    size: AppConstants.iconMd,
                  ),
                  onPressed: () {},
                  splashRadius: 20,
                ),
              ),
              const SizedBox(width: AppConstants.paddingSm),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                    border: Border.all(
                      color: AppTheme.divider,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.send,
                          maxLines: 4,
                          minLines: 1,
                          onSubmitted: (_) => _handleSend(),
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMd,
                              vertical: AppConstants.paddingSm,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_controller.text.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            Icons.attach_file_outlined,
                            color: AppTheme.textSecondary.withOpacity(0.6),
                            size: AppConstants.iconMd,
                          ),
                          onPressed: () {},
                          splashRadius: 20,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingSm),
              AnimatedContainer(
                duration: 200.ms,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isStreaming
                      ? AppTheme.textHint
                      : AppTheme.primary,
                ),
                child: IconButton(
                  icon: Icon(
                    widget.isStreaming
                        ? Icons.stop
                        : Icons.send_rounded,
                    color: Colors.white,
                    size: AppConstants.iconMd,
                  ),
                  onPressed: _handleSend,
                  splashRadius: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
