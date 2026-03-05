import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String fullName;
  final String title;
  final String summary;
  final String location;
  final String? profileImageUrl;
  final String? cvUrl;

  const SettingsEntity({
    required this.fullName,
    required this.title,
    required this.summary,
    required this.location,
    this.profileImageUrl,
    this.cvUrl,
  });

  @override
  List<Object?> get props => [
    fullName,
    title,
    summary,
    location,
    profileImageUrl,
    cvUrl,
  ];
}

class SkillEntity extends Equatable {
  final String name;

  const SkillEntity({required this.name});

  @override
  List<Object?> get props => [name];
}

class ExperienceEntity extends Equatable {
  final String companyText;
  final String role;
  final String startDate;
  final String? endDate;
  final String? description;

  const ExperienceEntity({
    required this.companyText,
    required this.role,
    required this.startDate,
    this.endDate,
    this.description,
  });

  @override
  List<Object?> get props => [
    companyText,
    role,
    startDate,
    endDate,
    description,
  ];
}

class EducationEntity extends Equatable {
  final String degree;
  final String institution;
  final String startYear;
  final String endYear;

  const EducationEntity({
    required this.degree,
    required this.institution,
    required this.startYear,
    required this.endYear,
  });

  @override
  List<Object?> get props => [degree, institution, startYear, endYear];
}

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String? playStoreUrl;
  final String? githubUrl;
  final String? driveUrl;
  final String? logoUrl;
  final int orderIndex;
  final List<String> imageUrls;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    this.technologies = const [],
    this.playStoreUrl,
    this.githubUrl,
    this.driveUrl,
    this.logoUrl,
    this.orderIndex = 0,
    this.imageUrls = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    technologies,
    playStoreUrl,
    githubUrl,
    driveUrl,
    logoUrl,
    orderIndex,
    imageUrls,
  ];
}

class ContactInfoEntity extends Equatable {
  final String platform;
  final String value;
  final String? url;

  const ContactInfoEntity({
    required this.platform,
    required this.value,
    this.url,
  });

  @override
  List<Object?> get props => [platform, value, url];
}

class PortfolioDataEntity extends Equatable {
  final SettingsEntity? settings;
  final List<SkillEntity> skills;
  final List<ExperienceEntity> experiences;
  final List<ProjectEntity> projects;
  final List<EducationEntity> education;
  final List<ContactInfoEntity> contacts;

  const PortfolioDataEntity({
    required this.settings,
    this.skills = const [],
    this.experiences = const [],
    this.projects = const [],
    this.education = const [],
    this.contacts = const [],
  });

  @override
  List<Object?> get props => [
    settings,
    skills,
    experiences,
    projects,
    education,
    contacts,
  ];
}
