import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:extera_next/config/app_config.dart';
import 'package:extera_next/config/app_settings.dart';
import 'package:extera_next/generated/l10n/l10n.dart';

class ProfileSourceDataDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProfileSourceDataDialog(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final encoder = JsonEncoder.withIndent(' ');
    final json = encoder.convert(data);
    final style = TextStyle(
      fontFamily: AppSettings.monospaceFont.value,
      fontFamilyFallback: AppSettings.monospaceFallbackFonts.value.split(','),
    );
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).showProfileSource)),
      body: Padding(
        padding: const .all(8),
        child: Material(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          color: theme.colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const .all(16),
            child: Column(
              mainAxisSize: .min,
              children: [Expanded(child: SelectableText(json, style: style))],
            ),
          ),
        ),
      ),
    );
  }
}
