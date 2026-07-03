import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/app_settings.dart';
import '../providers/settings_provider.dart';
import '../widgets/api_key_input.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          children: [
            _buildProfileSection(context),
            const SizedBox(height: 16),
            _buildAppearanceSection(context, ref, settings),
            const SizedBox(height: 16),
            _buildNotificationsSection(context, ref, settings),
            const SizedBox(height: 16),
            _buildAiSection(context, settings),
            const SizedBox(height: 16),
            _buildComposioSection(context, settings),
            const SizedBox(height: 16),
            _buildDataPrivacySection(context),
            const SizedBox(height: 16),
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return SettingsSection(
      title: 'Profile',
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryLight,
            child: const Icon(Icons.person,
                color: AppTheme.primary, size: 28),
          ),
          title: const Text('Your Name',
              style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: const Text('email@example.com'),
          trailing: const Icon(Icons.edit, color: AppTheme.textHint),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => context.push('/settings/change-password'),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    return SettingsSection(
      title: 'Appearance',
      children: [
        const Text('Theme',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: ThemeModeType.values.map((mode) {
            final labels = {ThemeModeType.light: 'Light', ThemeModeType.dark: 'Dark', ThemeModeType.system: 'System'};
            final icons = {ThemeModeType.light: Icons.light_mode, ThemeModeType.dark: Icons.dark_mode, ThemeModeType.system: Icons.settings};
            final selected = settings.themeMode == mode;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(mode),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primaryLight
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.divider,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(icons[mode],
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.textSecondary),
                        const SizedBox(height: 4),
                        Text(labels[mode]!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? AppTheme.primary
                                    : AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Dynamic color'),
          subtitle: const Text('Match system accent color'),
          value: settings.useDynamicColor,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .updateSettings(settings.copyWith(useDynamicColor: v)),
          activeColor: AppTheme.primary,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Font Size',
                style: TextStyle(
                    fontSize: AppConstants.textMd,
                    color: AppTheme.textPrimary)),
            Expanded(
              child: Slider(
                value: settings.fontSize,
                min: 12,
                max: 24,
                divisions: 12,
                activeColor: AppTheme.primary,
                onChanged: (v) => ref
                    .read(settingsProvider.notifier)
                    .setFontSize(v),
              ),
            ),
            Text(
              '${settings.fontSize.toInt()}',
              style: const TextStyle(
                  fontSize: AppConstants.textSm,
                  color: AppTheme.textSecondary),
            ),
          ],
        ),
        SettingsTile(
          icon: settings.is24HourFormat
              ? Icons.twenty_four_mp
              : Icons.access_time,
          title: 'Time format',
          subtitle: settings.is24HourFormat ? '24-hour' : '12-hour',
          trailing: Switch(
            value: settings.is24HourFormat,
            onChanged: (v) => ref
                .read(settingsProvider.notifier)
                .updateSettings(
                    settings.copyWith(is24HourFormat: v)),
            activeColor: AppTheme.primary,
          ),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.calendar_view_week,
          title: 'Week starts on',
          subtitle:
              settings.weekStartsOnMonday ? 'Monday' : 'Sunday',
          trailing: Switch(
            value: settings.weekStartsOnMonday,
            onChanged: (v) => ref
                .read(settingsProvider.notifier)
                .updateSettings(
                    settings.copyWith(weekStartsOnMonday: v)),
            activeColor: AppTheme.primary,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    return SettingsSection(
      title: 'Notifications',
      children: [
        SwitchListTile(
          title: const Text('Enable notifications'),
          value: settings.notificationsEnabled,
          onChanged: (v) => ref
              .read(settingsProvider.notifier)
              .toggleNotifications(),
          activeColor: AppTheme.primary,
          contentPadding: EdgeInsets.zero,
        ),
        SettingsTile(
          icon: Icons.event,
          title: 'Event reminders',
          enabled: settings.notificationsEnabled,
          trailing: Switch(
            value: true,
            onChanged: (_) {},
            activeColor: AppTheme.primary,
          ),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.checklist,
          title: 'Task reminders',
          enabled: settings.notificationsEnabled,
          trailing: Switch(
            value: true,
            onChanged: (_) {},
            activeColor: AppTheme.primary,
          ),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.school,
          title: 'Study reminders',
          enabled: settings.notificationsEnabled,
          trailing: Switch(
            value: true,
            onChanged: (_) {},
            activeColor: AppTheme.primary,
          ),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.volume_up,
          title: 'Sound',
          enabled: settings.notificationsEnabled,
          trailing: Switch(
            value: true,
            onChanged: (_) {},
            activeColor: AppTheme.primary,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAiSection(
      BuildContext context, AppSettings settings) {
    return SettingsSection(
      title: 'AI',
      children: [
        SettingsTile(
          icon: Icons.smart_toy_outlined,
          title: 'AI Provider',
          subtitle: settings.aiProvider ?? 'Not configured',
          onTap: () =>
              context.push('/settings/ai'),
        ),
        ApiKeyInput(
          label: 'API Key',
          value: settings.aiApiKey,
          maskedValue: settings.maskedAiApiKey,
          onChanged: (v) => {},
        ),
      ],
    );
  }

  Widget _buildComposioSection(
      BuildContext context, AppSettings settings) {
    return SettingsSection(
      title: 'Composio',
      children: [
        ApiKeyInput(
          label: 'Composio API Key',
          value: settings.composioApiKey,
          maskedValue: settings.maskedComposioApiKey,
          onChanged: (v) => {},
        ),
        SettingsTile(
          icon: Icons.integration_instructions,
          title: 'Connected integrations',
          subtitle: 'View and manage',
          onTap: () => context.push('/composio'),
        ),
        SettingsTile(
          icon: Icons.add_circle_outline,
          title: 'Connect new integration',
          onTap: () => context.push('/composio'),
        ),
      ],
    );
  }

  Widget _buildDataPrivacySection(BuildContext context) {
    return SettingsSection(
      title: 'Data & Privacy',
      children: [
        SettingsTile(
          icon: Icons.download_outlined,
          title: 'Export data',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.delete_sweep_outlined,
          title: 'Clear cache',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.delete_forever_outlined,
          title: 'Delete account',
          titleColor: AppTheme.error,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return SettingsSection(
      title: 'About',
      children: [
        SettingsTile(
          icon: Icons.info_outline,
          title: 'App version',
          subtitle: '1.0.0',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.description_outlined,
          title: 'Licenses',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.article_outlined,
          title: 'Terms of Service',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {},
        ),
      ],
    );
  }
}
