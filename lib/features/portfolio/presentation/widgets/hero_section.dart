import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/portfolio_data_entity.dart';

class HeroSection extends StatefulWidget {
  final SettingsEntity? settings;
  final PortfolioDataEntity? fullData;
  final VoidCallback? onContactTap;
  final VoidCallback? onExperienceTap;
  final VoidCallback? onSkillsTap;
  final VoidCallback? onProjectsTap;

  const HeroSection({
    super.key,
    required this.settings,
    this.fullData,
    this.onContactTap,
    this.onExperienceTap,
    this.onSkillsTap,
    this.onProjectsTap,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => _buildMobileLayout(context),
      desktop: (context) => _buildDesktopLayout(context),
    );
  }

  // --- DESKTOP LAYOUT ---
  Widget _buildDesktopLayout(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 150),
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                _buildAvailabilityBadge(theme),
                const SizedBox(height: 60),
                Text(
                  'Abdullah El-Awadi',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    fontSize: 100,
                    color: Colors.white,
                    letterSpacing: -4,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.settings?.title.toUpperCase() ?? 'FLUTTER DEVELOPER',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: theme.colorScheme.primary,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 48),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 750),
                  child: MarkdownBody(
                    data: widget.settings?.summary ?? '',
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.outfit(
                        color: Colors.grey.shade400,
                        fontSize: 22,
                        height: 1.8,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                _buildActionButtons(theme, centered: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- MOBILE LAYOUT ---
  // Requested order: Name -> Role -> Contact -> Skills -> Work Experience
  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Name (Top)
            Text(
              'Abdullah El-Awadi',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 50,
                color: Colors.white,
                letterSpacing: -2,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            // 2. Role
            Text(
              widget.settings?.title.toUpperCase() ?? 'FLUTTER DEVELOPER',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: theme.colorScheme.primary,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 48),
            // Summary Text
            MarkdownBody(
              data: widget.settings?.summary ?? '',
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.outfit(
                  color: Colors.grey.shade400,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // 3. Contact (Hire Me / Resume)
            _buildActionButtons(theme, centered: false),
            const SizedBox(height: 60),
            // 4. Skills Link
            _buildMobileNavLink(
              context,
              icon: Icons.code_rounded,
              title: 'TECHNICAL SKILLS',
              subtitle: 'Expertise in modern mobile architecture',
              onTap: widget.onSkillsTap,
            ),
            const SizedBox(height: 16),
            // 5. Work Experience Link
            _buildMobileNavLink(
              context,
              icon: Icons.work_history_rounded,
              title: 'WORK EXPERIENCE',
              subtitle: 'Proven track record of production apps',
              onTap: widget.onExperienceTap,
            ),
            const SizedBox(height: 16),
            // 6. Projects Link
            _buildMobileNavLink(
              context,
              icon: Icons.rocket_launch_rounded,
              title: 'FEATURED PROJECTS',
              subtitle: 'Production apps built with Flutter',
              onTap: widget.onProjectsTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(100),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'AVAILABLE FOR NEW OPPORTUNITIES',
            style: GoogleFonts.outfit(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, {required bool centered}) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            //CVGenerator.generateAndDownloadCV(widget.fullData!);

            final cvUrl = widget.settings?.cvUrl;
            if (cvUrl != null && cvUrl.isNotEmpty) {
              String downloadUrl = cvUrl;
              if (!downloadUrl.contains('download=')) {
                downloadUrl += downloadUrl.contains('?')
                    ? '&download='
                    : '?download=';
              }
              final uri = Uri.parse(downloadUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'CV not available right now. Please check back later.',
                    ),
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            shadowColor: theme.colorScheme.primary.withAlpha(80),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.download_rounded, size: 20),
              const SizedBox(width: 12),
              Text(
                'RESUME',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: widget.onContactTap,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.white.withAlpha(50), width: 2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mail_outline_rounded, size: 20),
              const SizedBox(width: 12),
              Text(
                'HIRE ME',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNavLink(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withAlpha(20)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white.withAlpha(80),
            ),
          ],
        ),
      ),
    );
  }
}
