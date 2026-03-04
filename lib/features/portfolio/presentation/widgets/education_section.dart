import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../domain/entities/portfolio_data_entity.dart';

class EducationSection extends StatelessWidget {
  final List<EducationEntity> education;

  const EducationSection({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    if (education.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 24,
          tablet: 40,
          desktop: 40,
        ),
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 60,
          desktop: 120,
        ),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 60,
                color: theme.colorScheme.primary.withAlpha(80),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'EDUCATION',
                  style: GoogleFonts.outfit(
                    letterSpacing: getValueForScreenType<double>(
                      context: context,
                      mobile: 4,
                      desktop: 6,
                    ),
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                    fontSize: getValueForScreenType<double>(
                      context: context,
                      mobile: 24,
                      desktop: 30,
                    ),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 60,
                color: theme.colorScheme.primary.withAlpha(80),
              ),
            ],
          ),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: education.length,
              separatorBuilder: (context, index) => const SizedBox(height: 48),
              itemBuilder: (context, index) {
                final edu = education[index];
                return _buildEducationCard(context, edu);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(BuildContext context, EducationEntity edu) {
    final isMobile = getValueForScreenType<bool>(
      context: context,
      mobile: true,
      tablet: false,
      desktop: false,
    );

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(isMobile ? 24 : 30),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: isMobile
          ? _buildMobileEducationContent(context, edu)
          : _buildDesktopEducationContent(context, edu),
    );
  }

  Widget _buildDesktopEducationContent(
    BuildContext context,
    EducationEntity edu,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.school_rounded,
            color: theme.colorScheme.primary,
            size: 32,
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                edu.degree,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                edu.institution,
                style: GoogleFonts.outfit(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${edu.startYear} - ${edu.endYear}',
                  style: GoogleFonts.outfit(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileEducationContent(
    BuildContext context,
    EducationEntity edu,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.school_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                edu.degree,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          edu.institution,
          style: GoogleFonts.outfit(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${edu.startYear} - ${edu.endYear}',
            style: GoogleFonts.outfit(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
