import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../domain/entities/portfolio_data_entity.dart';
import 'project_detail_dialog.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectEntity> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 60,
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Projects',
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
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(height: 32),

          ScreenTypeLayout.builder(
            mobile: (_) => _buildGrid(context, 2),
            tablet: (_) => _buildGrid(context, 3),
            desktop: (_) => _buildGrid(context, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 48,
        crossAxisSpacing: 48,
        childAspectRatio: 0.4, // Optimized for 375x812 vertical screenshots
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _ProjectCard(project: projects[index]);
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectEntity project;

  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
        // color: Colors.brown.withOpacity(.1),
        transform: _isHovered
            ? (Matrix4.identity()
                ..translate(0, -20, 0)
                ..scale(1.05))
            : Matrix4.identity(),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProjectDetailDialog(project: widget.project),
                fullscreenDialog: true,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered
                            ? theme.colorScheme.primary.withOpacity(0.3)
                            : Colors.black.withOpacity(0.2),
                        blurRadius: _isHovered ? 60 : 30,
                        spreadRadius: _isHovered ? 10 : 0,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Image
                      Positioned.fill(
                        child: widget.project.imageUrls.isNotEmpty
                            ? Image.network(
                                widget.project.imageUrls.first,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: const Color(0xFF1A1A1A),
                                child: const Icon(
                                  Icons.image,
                                  size: 48,
                                  color: Colors.white12,
                                ),
                              ),
                      ),
                      // Overlay
                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                _isHovered
                                    ? Colors.black.withOpacity(0.2)
                                    : Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Logo
                      if (widget.project.logoUrl != null)
                        Positioned(
                          top: 24,
                          left: 24,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.project.logoUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      // Tag
                      Positioned(
                        bottom: 24,
                        left: 24,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _isHovered ? 1 : 0.8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'MOBILE APP',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: _isHovered
                            ? theme.colorScheme.primary
                            : Colors.white,
                        letterSpacing: -1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.project.description,
                      style: GoogleFonts.outfit(
                        color: Colors.grey.shade500,
                        height: 1.6,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'VIEW PROJECT',
                          style: GoogleFonts.outfit(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: _isHovered
                              ? (Matrix4.identity()..translate(8, 0, 0))
                              : Matrix4.identity(),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
