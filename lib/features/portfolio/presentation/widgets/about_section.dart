import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String? summary;

  const AboutSection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    if (summary == null || summary!.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
      color: Colors.black.withOpacity(0.3),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 50,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'STORY',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,fontSize: 30,
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 50,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'About Me',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Text(
              summary!,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.8,
                fontSize: 20,
                color: Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
