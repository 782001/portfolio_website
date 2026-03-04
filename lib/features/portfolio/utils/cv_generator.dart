import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../domain/entities/portfolio_data_entity.dart';

// ─── Brand colours ─────────────────────────────────────────────────────────
const _accent = PdfColor.fromInt(0xFF0CAB60);
const _accentSoft = PdfColor.fromInt(0xFFEDECFF);
const _dark = PdfColor.fromInt(0xFF111111);
const _mid = PdfColor.fromInt(0xFF444444);
const _muted = PdfColor.fromInt(0xFF888888);
const _rule = PdfColor.fromInt(0xFFDDDDDD);

class CVGenerator {
  static Future<void> generateAndDownloadCV(PortfolioDataEntity data) async {
    // ── Fonts via PdfGoogleFonts (full Unicode, no asset needed) ────────────
    final pw.Font regular = await PdfGoogleFonts.notoSansRegular();
    final pw.Font bold = await PdfGoogleFonts.notoSansBold();
    final pw.Font italic = await PdfGoogleFonts.notoSansItalic();

    // ── Style helpers ────────────────────────────────────────────────────────
    pw.TextStyle ts(
      double size, {
      PdfColor color = _dark,
      double lineSpacing = 0,
    }) => pw.TextStyle(
      font: regular,
      fontSize: size,
      color: color,
      lineSpacing: lineSpacing,
    );

    pw.TextStyle tsBold(double size, {PdfColor color = _dark}) =>
        pw.TextStyle(font: bold, fontSize: size, color: color);

    pw.TextStyle tsItalic(double size, {PdfColor color = _mid}) =>
        pw.TextStyle(font: italic, fontSize: size, color: color);

    // ── Section header widget ────────────────────────────────────────────────
    pw.Widget section(String title) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 18, bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: tsBold(9, color: _accent).copyWith(letterSpacing: 1.5),
          ),
          pw.SizedBox(height: 4),
          pw.Divider(color: _rule, thickness: 1),
        ],
      ),
    );

    // ── Skill chip ───────────────────────────────────────────────────────────
    pw.Widget chip(String label, {bool filled = false}) => pw.Container(
      margin: const pw.EdgeInsets.only(right: 5, bottom: 5),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: pw.BoxDecoration(
        color: filled ? _accent : _accentSoft,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        label,
        style: tsBold(7.5, color: filled ? PdfColors.white : _accent),
      ),
    );

    // ── Link badge ───────────────────────────────────────────────────────────
    pw.Widget linkBadge(String label, String url) => pw.Padding(
      padding: const pw.EdgeInsets.only(right: 6),
      child: pw.UrlLink(
        destination: url,
        child: pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _accent, width: 0.7),
            borderRadius: pw.BorderRadius.circular(3),
          ),
          child: pw.Text(label, style: tsBold(7.5, color: _accent)),
        ),
      ),
    );

    final settings = data.settings;
    final pdf = pw.Document(
      title: '${settings?.fullName ?? 'Portfolio'} - Resume',
      author: settings?.fullName ?? '',
    );

    // ────────────────────────────────────────────────────────────────────────
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
        maxPages: 50,
        build: (ctx) {
          final List<pw.Widget> widgets = [];

          // ── HEADER ──────────────────────────────────────────────────────
          widgets.add(
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 16),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: _accent, width: 3),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          settings?.fullName ?? 'Your Name',
                          style: tsBold(28, color: _dark),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          settings?.title ?? '',
                          style: ts(13, color: _accent),
                        ),
                        if (settings?.location.isNotEmpty == true) ...[
                          pw.SizedBox(height: 3),
                          pw.Text(
                            settings!.location,
                            style: ts(9, color: _muted),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Contact info in top-right
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: data.contacts
                        .map(
                          (c) => pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 3),
                            child: c.url != null
                                ? pw.UrlLink(
                                    destination: c.url!,
                                    child: pw.Text(
                                      '${c.platform}: ${c.value}',
                                      style: ts(8, color: _accent),
                                    ),
                                  )
                                : pw.Text(
                                    '${c.platform}: ${c.value}',
                                    style: ts(8, color: _mid),
                                  ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          );

          // ── SUMMARY ─────────────────────────────────────────────────────
          if (settings?.summary.isNotEmpty == true) {
            widgets.add(section('Profile'));
            widgets.add(
              pw.Text(
                _stripMarkdown(settings!.summary),
                style: ts(9.5, color: _mid, lineSpacing: 3),
              ),
            );
          }

          // ── EXPERIENCE ──────────────────────────────────────────────────
          if (data.experiences.isNotEmpty) {
            widgets.add(section('Work Experience'));
            for (final exp in data.experiences) {
              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            exp.companyText,
                            style: tsItalic(9.5, color: _accent),
                          ),
                          pw.Text(
                            '${exp.startDate} - ${exp.endDate ?? 'Present'}',
                            style: ts(8.5, color: _muted),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(exp.role, style: tsBold(11)),
                      if (exp.description?.isNotEmpty == true) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          _stripMarkdown(exp.description!),
                          style: ts(8.5, color: _mid, lineSpacing: 2),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
          }

          // ── SKILLS ──────────────────────────────────────────────────────
          if (data.skills.isNotEmpty) {
            widgets.add(section('Skills'));
            widgets.add(
              pw.Wrap(children: data.skills.map((s) => chip(s.name)).toList()),
            );
          }

          // ── PROJECTS ────────────────────────────────────────────────────
          if (data.projects.isNotEmpty) {
            widgets.add(section('Featured Projects'));
            for (final proj in data.projects) {
              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 14),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Title + link badges row
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Expanded(
                            child: pw.Text(proj.title, style: tsBold(11)),
                          ),
                          if (proj.playStoreUrl != null)
                            linkBadge('Play Store', proj.playStoreUrl!),
                          if (proj.githubUrl != null)
                            linkBadge('GitHub', proj.githubUrl!),
                          if (proj.driveUrl != null)
                            linkBadge('Demo', proj.driveUrl!),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        _stripMarkdown(proj.description),
                        style: ts(8.5, color: _mid, lineSpacing: 2),
                        maxLines: 5,
                      ),
                      if (proj.technologies.isNotEmpty) ...[
                        pw.SizedBox(height: 5),
                        pw.Wrap(
                          children: proj.technologies
                              .map((t) => chip(t, filled: true))
                              .toList(),
                        ),
                      ],
                      // Clickable image links
                      if (proj.imageUrls.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Screenshots: ',
                              style: tsBold(8, color: _mid),
                            ),
                            ...proj.imageUrls.asMap().entries.map(
                              (e) => pw.Padding(
                                padding: const pw.EdgeInsets.only(right: 8),
                                child: pw.UrlLink(
                                  destination: e.value,
                                  child: pw.Text(
                                    'Image ${e.key + 1}',
                                    style: ts(8, color: _accent),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
          }

          // ── EDUCATION ───────────────────────────────────────────────────
          if (data.education.isNotEmpty) {
            widgets.add(section('Education'));
            for (final edu in data.education) {
              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(edu.degree, style: tsBold(10)),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            edu.institution,
                            style: tsItalic(9, color: _mid),
                          ),
                        ],
                      ),
                      pw.Text(
                        '${edu.startYear} - ${edu.endYear}',
                        style: ts(8.5, color: _muted),
                      ),
                    ],
                  ),
                ),
              );
            }
          }

          return widgets;
        },

        // ── Footer ────────────────────────────────────────────────────────
        footer: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: _rule, width: 0.5)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                settings?.fullName ?? '',
                style: tsBold(7, color: _muted),
              ),
              pw.Text(
                'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                style: ts(7, color: _muted),
              ),
            ],
          ),
        ),
      ),
    );

    // ── Immediate download ───────────────────────────────────────────────────
    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          '${(settings?.fullName ?? 'CV').replaceAll(' ', '_')}_Resume.pdf',
    );
  }

  /// Strips Markdown syntax for clean plain PDF text.
  static String _stripMarkdown(String md) {
    return md
        .replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (m) => m.group(1) ?? '')
        .replaceAllMapped(RegExp(r'\*(.*?)\*'), (m) => m.group(1) ?? '')
        .replaceAll(RegExp(r'#{1,6}\s?'), '')
        .replaceAll(RegExp(r'^[-*+]\s', multiLine: true), '- ')
        .replaceAllMapped(
          RegExp(r'\[([^\]]+)\]\([^)]+\)'),
          (m) => m.group(1) ?? '',
        )
        .replaceAllMapped(RegExp(r'`([^`]+)`'), (m) => m.group(1) ?? '')
        .replaceAll('\r\n', '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}
