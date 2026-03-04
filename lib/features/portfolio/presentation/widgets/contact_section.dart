import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/features/portfolio/domain/entities/portfolio_data_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final List<ContactInfoEntity> contacts;

  const ContactSection({super.key, required this.contacts});

  IconData _getIconForPlatform(String platform) {
    platform = platform.toLowerCase();
    if (platform.contains('email')) return Icons.alternate_email_rounded;
    if (platform.contains('whatsapp') || platform.contains('phone')) {
      return Icons.phone_android_rounded;
    }
    if (platform.contains('github')) return Icons.code_rounded;
    if (platform.contains('linkedin')) return Icons.work_rounded;
    if (platform.contains('twitter') || platform.contains('x')) {
      return Icons.share_rounded;
    }
    if (platform.contains('facebook')) return Icons.facebook_rounded;
    if (platform.contains('instagram')) return Icons.camera_alt_rounded;
    return Icons.link_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                  'CONNECT',
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
            'Get In Touch',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 64,
              color: Colors.white,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Currently open for new opportunities.',
            style: GoogleFonts.outfit(
              fontSize: 22,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: contacts.map((contact) {
                  return _buildSocialCard(
                    context,
                    _getIconForPlatform(contact.platform),
                    contact.platform,
                    contact.value,
                    contact.url ?? '',
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 150),
          Text(
            '© ${DateTime.now().year} ABDULLAH EL-AWADI. BUILT WITH FLUTTER WEB.',
            style: GoogleFonts.outfit(
              color: Colors.white.withAlpha(80),
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String url,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        if (url.isEmpty) return;
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withAlpha(20)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 28),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.outfit(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: 20,
              color: Colors.white.withAlpha(50),
            ),
          ],
        ),
      ),
    );
  }
}
