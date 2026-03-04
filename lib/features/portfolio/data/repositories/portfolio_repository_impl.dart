import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/portfolio_data_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final SupabaseClient supabaseClient;

  PortfolioRepositoryImpl({required this.supabaseClient});

  @override
  Future<PortfolioDataEntity> getPortfolioData() async {
    // We can fetch all necessary data using future.wait for parallel execution
    final results = await Future.wait([
      supabaseClient.from('settings').select().limit(1).maybeSingle(),
      supabaseClient.from('skills').select('name').order('order_index'),
      supabaseClient.from('experiences').select().order('order_index'),
      supabaseClient
          .from('projects')
          .select('*, project_images(*)')
          .order('order_index'),
      supabaseClient.from('education').select().order('order_index'),
      supabaseClient.from('contacts').select().order('order_index'),
    ]);

    final settingsData = results[0] as Map<String, dynamic>?;
    final skillsData = results[1] as List<dynamic>;
    final expData = results[2] as List<dynamic>;
    final projData = results[3] as List<dynamic>;
    final eduData = results[4] as List<dynamic>;
    final contactsData = results[5] as List<dynamic>;

    final settings = settingsData != null
        ? SettingsEntity(
            fullName: settingsData['full_name']?.toString() ?? '',
            title: settingsData['title']?.toString() ?? '',
            summary: settingsData['summary']?.toString() ?? '',
            location: settingsData['location']?.toString() ?? '',
            profileImageUrl: settingsData['profile_image_url']?.toString(),
            cvUrl: settingsData['cv_url']?.toString(),
          )
        : null;

    final skills = skillsData
        .map((s) => SkillEntity(name: s['name']?.toString() ?? ''))
        .toList();

    final experiences = expData
        .map(
          (e) => ExperienceEntity(
            companyText:
                e['company_text']?.toString() ??
                e['company_id']?.toString() ??
                'Unknown Company',
            role: e['role']?.toString() ?? '',
            startDate: e['start_date']?.toString() ?? '',
            endDate: e['end_date']?.toString(),
            description: e['description']?.toString(),
          ),
        )
        .toList();

    final projects = projData.map((e) {
      final imagesList = (e['project_images'] as List?) ?? [];
      final imageUrls = imagesList
          .map((img) {
            if (img is Map && img['image_url'] != null) {
              return img['image_url']?.toString() ?? '';
            }
            return null;
          })
          .whereType<String>()
          .toList();

      return ProjectEntity(
        id: e['id']?.toString() ?? '',
        title: e['title']?.toString() ?? '',
        description: e['description']?.toString() ?? '',
        technologies:
            (e['technologies'] as List?)?.map((t) => t.toString()).toList() ??
            [],
        playStoreUrl: e['play_store_url']?.toString(),
        githubUrl: e['github_url']?.toString(),
        driveUrl: e['drive_url']?.toString(),
        logoUrl: e['logo_url']?.toString(),
        imageUrls: imageUrls,
      );
    }).toList();

    final education = eduData
        .map(
          (e) => EducationEntity(
            degree: e['degree']?.toString() ?? '',
            institution: e['institution']?.toString() ?? '',
            startYear: e['start_year']?.toString() ?? '',
            endYear: e['end_year']?.toString() ?? 'Present',
          ),
        )
        .toList();

    final contacts = contactsData
        .map(
          (e) => ContactInfoEntity(
            platform: e['platform']?.toString() ?? '',
            value: e['value']?.toString() ?? '',
            url: e['url']?.toString(),
          ),
        )
        .toList();

    return PortfolioDataEntity(
      settings: settings,
      skills: skills,
      experiences: experiences,
      projects: projects,
      education: education,
      contacts: contacts,
    );
  }
}
