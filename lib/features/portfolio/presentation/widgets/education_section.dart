import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/portfolio_data_entity.dart';

class EducationSection extends StatelessWidget {
  final List<EducationEntity> education;

  const EducationSection({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    if (education.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
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
                  'ACADEMIC',
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
                width: 60,
                color: theme.colorScheme.primary.withAlpha(80),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Education',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 50,
              color: Colors.white,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 30),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Row(
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
      ),
    );
  }
}
