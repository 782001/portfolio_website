import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../injection_container.dart' as di;
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/hero_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/education_section.dart';
import '../widgets/contact_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final offset =
          box.localToGlobal(Offset.zero, ancestor: null).dy +
          _scrollController.offset -
          80;

      _scrollController.animateTo(
        offset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return BlocProvider(
      create: (_) => di.sl<PortfolioCubit>()..loadData(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: isMobile ? _buildMobileDrawer(theme) : null,
        appBar: AppBar(
          toolbarHeight: 90,
          leadingWidth: isMobile ? 60 : 0,
          leading: isMobile
              ? Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  ),
                )
              : const SizedBox.shrink(),
          title: Padding(
            padding: EdgeInsets.only(left: isMobile ? 0 : 20),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _scrollToSection(_heroKey),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar logo
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withAlpha(120),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: theme.colorScheme.primary.withAlpha(180),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),
                    Text(
                      'Abdullah El-Awadi',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          centerTitle: isMobile,
          elevation: 0,
          backgroundColor: Colors.black.withAlpha(200),
          actions: [
            if (!isMobile) ...[
              _buildNavButton('Skills', _skillsKey),
              _buildNavButton('Experience', _experienceKey),
              _buildNavButton('Projects', _projectsKey),
              _buildNavButton('Contact', _contactKey),
              const SizedBox(width: 40),
            ],
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: -200,
              right: -200,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withAlpha(12),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: -300,
              child: Container(
                width: 800,
                height: 800,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withAlpha(8),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: BlocBuilder<PortfolioCubit, PortfolioState>(
                builder: (context, state) {
                  if (state is PortfolioLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PortfolioError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is PortfolioLoaded) {
                    final data = state.data;
                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          HeroSection(
                            key: _heroKey,
                            settings: data.settings,
                            fullData: data,
                            onContactTap: () => _scrollToSection(_contactKey),
                            onExperienceTap: () =>
                                _scrollToSection(_experienceKey),
                            onSkillsTap: () => _scrollToSection(_skillsKey),
                            onProjectsTap: () => _scrollToSection(_projectsKey),
                          ),
                          SkillsSection(key: _skillsKey, skills: data.skills),
                          ExperienceSection(
                            key: _experienceKey,
                            experiences: data.experiences,
                          ),
                          ProjectsSection(
                            key: _projectsKey,
                            projects: data.projects,
                          ),
                          EducationSection(education: data.education),
                          ContactSection(
                            key: _contactKey,
                            contacts: data.contacts,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(ThemeData theme) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Drawer header with avatar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withAlpha(180),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Abdullah El-Awadi',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Flutter Developer',
                          style: GoogleFonts.outfit(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withAlpha(20), height: 32),
            _buildDrawerItem('HOME', Icons.home_rounded, _heroKey),
            _buildDrawerItem('SKILLS', Icons.code_rounded, _skillsKey),
            _buildDrawerItem(
              'EXPERIENCE',
              Icons.work_history_rounded,
              _experienceKey,
            ),
            _buildDrawerItem(
              'PROJECTS',
              Icons.rocket_launch_rounded,
              _projectsKey,
            ),
            _buildDrawerItem('CONTACT', Icons.mail_rounded, _contactKey),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String label, IconData icon, GlobalKey key) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(
        label,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _scrollToSection(key);
      },
    );
  }

  Widget _buildNavButton(String label, GlobalKey key) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: InkWell(
          onTap: () => _scrollToSection(key),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label.toUpperCase(),
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                fontSize: 14,
                color: Colors.white.withAlpha(200),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
