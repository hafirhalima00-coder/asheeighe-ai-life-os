import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/settings_provider.dart';
import '../widgets/api_key_input.dart';

class AiSettingsScreen extends ConsumerWidget {
  const AiSettingsScreen({super.key});

  static const providers = [
    'OpenAI',
    'Gemini',
    'Anthropic',
    'Ollama',
    'OpenRouter',
  ];

  static const models = {
    'OpenAI': ['gpt-4o', 'gpt-4o-mini', 'gpt-4-turbo', 'gpt-3.5-turbo'],
    'Gemini': ['gemini-1.5-pro', 'gemini-1.5-flash', 'gemini-1.5-flash-8b'],
    'Anthropic': ['claude-3-5-sonnet', 'claude-3-haiku', 'claude-3-opus'],
    'Ollama': ['llama3', 'mistral', 'codellama', 'mixtral'],
    'OpenRouter': ['auto', 'openai/gpt-4o', 'anthropic/claude-3.5-sonnet'],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Provider',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...providers.map((provider) {
              final selected =
                  settings.aiProvider == provider;
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => notifier
                      .setAiProvider(provider),
                  child: Container(
                    padding:
                        const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primaryLight
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.divider,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getProviderIcon(provider),
                          color: selected
                              ? AppTheme.primary
                              : AppTheme
                                  .textSecondary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                provider,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w600,
                                  color: selected
                                      ? AppTheme
                                          .primary
                                      : AppTheme
                                          .textPrimary,
                                ),
                              ),
                              Text(
                                _getProviderDesc(
                                    provider),
                                style:
                                    const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme
                                      .textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_circle,
                              color:
                                  AppTheme.primary),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            ApiKeyInput(
              label: 'API Key',
              value: settings.aiApiKey,
              maskedValue: settings.maskedAiApiKey,
              onChanged: (key) =>
                  notifier.setAiApiKey(key),
            ),
            const SizedBox(height: 24),
            const Text(
              'Model',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            if (settings.aiProvider != null &&
                models.containsKey(
                    settings.aiProvider)) ...[
              ...models[settings.aiProvider]!
                  .map((model) => RadioListTile<String>(
                        title: Text(model,
                            style: const TextStyle(
                                fontSize: 14)),
                        value: model,
                        groupValue: 'gpt-4o',
                        onChanged: (_) {},
                        activeColor:
                            AppTheme.primary,
                        contentPadding:
                            EdgeInsets.zero,
                        dense: true,
                      )),
            ] else
              const Padding(
                padding:
                    EdgeInsets.only(top: 8),
                child: Text(
                  'Select a provider first',
                  style: TextStyle(
                    color:
                        AppTheme.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getProviderIcon(String provider) {
    switch (provider) {
      case 'OpenAI':
        return Icons.auto_awesome;
      case 'Gemini':
        return Icons.g_translate;
      case 'Anthropic':
        return Icons.psychology;
      case 'Ollama':
        return Icons.computer;
      case 'OpenRouter':
        return Icons.hub;
      default:
        return Icons.smart_toy;
    }
  }

  String _getProviderDesc(String provider) {
    switch (provider) {
      case 'OpenAI':
        return 'GPT-4, GPT-4o, GPT-3.5';
      case 'Gemini':
        return 'Gemini 1.5 Pro, Flash';
      case 'Anthropic':
        return 'Claude 3.5 Sonnet, Haiku';
      case 'Ollama':
        return 'Local models (requires setup)';
      case 'OpenRouter':
        return 'Multi-model gateway';
      default:
        return '';
    }
  }
}
