import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/portfolio_data_entity.dart';

class ExperienceSection extends StatelessWidget {
  final List<ExperienceEntity> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    if (experiences.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 15,
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'EXPERIENCE',
                  style: GoogleFonts.outfit(
                    letterSpacing: 6,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 15,
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ],
          ),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ScreenTypeLayout.builder(
              mobile: (context) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: experiences.length,
                itemBuilder: (context, index) {
                  return _buildExperienceCard(context, experiences[index]);
                },
              ),
              desktop: (context) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: experiences.length,
                itemBuilder: (context, index) {
                  final exp = experiences[index];
                  final isLast = index == experiences.length - 1;
                  return _buildExperienceTimelineItem(context, exp, isLast);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceTimelineItem(
    BuildContext context,
    ExperienceEntity exp,
    bool isLast,
  ) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  exp.startDate,
                  style: GoogleFonts.outfit(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  exp.endDate ?? 'Present',
                  style: GoogleFonts.outfit(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(100),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary.withAlpha(120),
                          theme.colorScheme.primary.withAlpha(25),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 48),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exp.companyText.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exp.role,
                    style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  if (exp.description != null) ...[
                    const SizedBox(height: 32),
                    MarkdownBody(
                      data: exp.description!,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.outfit(
                          color: Colors.grey.shade400,
                          height: 1.8,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        listBullet: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(BuildContext context, ExperienceEntity exp) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withAlpha(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(120),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  exp.companyText,
                  style: GoogleFonts.outfit(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${exp.startDate}  \n${exp.endDate}',
                  style: GoogleFonts.outfit(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            exp.role,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          if (exp.description != null) ...[
            const SizedBox(height: 24),
            MarkdownBody(
              data: exp.description!,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.outfit(
                  color: Colors.grey.shade400,
                  height: 1.7,
                  fontSize: 16,
                ),
                listBullet: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
