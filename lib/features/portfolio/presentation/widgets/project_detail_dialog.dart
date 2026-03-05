import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/portfolio_data_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailDialog extends StatelessWidget {
  final ProjectEntity project;

  const ProjectDetailDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background subtle gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.12),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.2,
                                ),
                              ),
                            ),
                            child: Text(
                              'PROJECT CASE STUDY',
                              style: GoogleFonts.outfit(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            project.title,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w900,
                              fontSize: isMobile ? 48 : 96,
                              color: Colors.white,
                              letterSpacing: -2,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          _buildLinks(theme, project),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),

                    // Screenshots Section
                    if (project.imageUrls.isNotEmpty)
                      _buildImageSection(context, theme, isMobile),

                    const SizedBox(height: 100),

                    // Overview Section
                    _buildOverviewSection(context, theme, isMobile),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),

          // Close Button
          Positioned(
            top: 40,
            right: 40,
            child: Material(
              color: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'VISUAL INTERFACE',
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: isMobile ? 550 : 750,
          child: ScrollConfiguration(
            behavior: _WebScrollBehavior(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 150),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                physics: const BouncingScrollPhysics(),
                itemCount: project.imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: GestureDetector(
                      onTap: () =>
                          _showImageGallery(context, project.imageUrls, index),
                      child: Container(
                        width: isMobile ? 250 : 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(
                                0.15,
                              ),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                project.imageUrls[index],
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: const Color(0xFF111111),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 20,
                              right: 20,
                              child: Icon(
                                Icons.zoom_in_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 50, height: 2, color: theme.colorScheme.primary),
              const SizedBox(width: 20),
              Text(
                'OVERVIEW',
                style: GoogleFonts.outfit(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          MarkdownBody(
            data: project.description,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.outfit(
                fontSize: isMobile ? 20 : 24,
                height: 1.8,
                color: Colors.grey.shade300,
                fontWeight: FontWeight.w300,
              ),
              listBullet: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 60),
          if (project.technologies.isNotEmpty) ...[
            Text(
              'TECHNOLOGIES',
              style: GoogleFonts.outfit(
                color: Colors.white54,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: project.technologies
                  .map(
                    (tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        tech.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _showImageGallery(
    BuildContext context,
    List<String> imageUrls,
    int initialIndex,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, _, __) => _FullScreenGalleryViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildLinks(ThemeData theme, ProjectEntity proj) {
    return Wrap(
      spacing: 24,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        if (proj.playStoreUrl != null)
          _LinkButton(
            label: 'PLAY STORE',
            icon: Icons.shop,
            color: const Color(0xFF3DDC84),
            onTap: () => _launchUrl(proj.playStoreUrl!),
          ),
        if (proj.githubUrl != null)
          _LinkButton(
            label: 'SOURCE CODE',
            icon: Icons.code,
            color: Colors.white.withOpacity(0.1),
            onTap: () => _launchUrl(proj.githubUrl!),
          ),
        if (proj.driveUrl != null)
          _LinkButton(
            label: 'LIVE DEMO',
            icon: Icons.play_circle_fill,
            color: theme.colorScheme.primary,
            onTap: () => _launchUrl(proj.driveUrl!),
          ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _LinkButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label.toUpperCase()),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        textStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          fontSize: 13,
        ),
      ).copyWith(overlayColor: WidgetStateProperty.all(Colors.white10)),
    );
  }
}

class _FullScreenGalleryViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _FullScreenGalleryViewer({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGalleryViewer> createState() =>
      _FullScreenGalleryViewerState();
}

class _FullScreenGalleryViewerState extends State<_FullScreenGalleryViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.imageUrls.length > 1;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: Dismissible(
        key: const Key('gallery_dismissible'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => context.pop(),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            children: [
              // Swipeable Page Gallery (with mouse drag support)
              ScrollConfiguration(
                behavior: _WebScrollBehavior(),
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.imageUrls.length,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    return Center(
                      child: InteractiveViewer(
                        maxScale: 4.0,
                        child: Image.network(
                          widget.imageUrls[index],
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Close Button
              Positioned(
                top: 40,
                right: 40,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Image Counter
              if (hasMultiple)
                Positioned(
                  top: 48,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.imageUrls.length}',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

              // Left Arrow
              if (hasMultiple && _currentIndex > 0)
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

              // Right Arrow
              if (hasMultiple && _currentIndex < widget.imageUrls.length - 1)
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

              // Dot indicators at bottom
              if (hasMultiple)
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.imageUrls.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentIndex ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentIndex
                              ? Colors.white
                              : Colors.white38,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom scroll behavior that enables drag-to-scroll with a mouse on Flutter Web.
/// By default, web only allows mouse wheel scrolling; this adds drag support.
class _WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
