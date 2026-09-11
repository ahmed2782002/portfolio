import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter/widgets.dart' show IconData;

/// Domain models for everything the site renders.
///
/// All content is sourced from the CV and the supplied screenshots. Fields that
/// the CV does not provide (public repository links, live store URLs) are
/// nullable so they can be filled in later without touching any widget.
@immutable
class Profile {
  const Profile({
    required this.fullName,
    required this.shortName,
    required this.role,
    required this.summary,
    required this.tagline,
    required this.location,
    required this.email,
    required this.phone,
    required this.photoAsset,
    required this.cvAsset,
    required this.cvFileName,
    required this.stats,
    required this.focusAreas,
  });

  final String fullName;

  /// Used in the nav mark and the footer.
  final String shortName;
  final String role;

  /// The CV's professional summary, verbatim in substance.
  final String summary;

  /// One line the hero leads with.
  final String tagline;
  final String location;
  final String email;
  final String phone;
  final String photoAsset;
  final String cvAsset;
  final String cvFileName;

  /// Three at-a-glance numbers for the hero rail.
  final List<Stat> stats;

  /// Technology labels that float around the hero portrait.
  final List<String> focusAreas;

  String get mailtoUri => 'mailto:$email';

  /// `tel:` needs the number without separators.
  String get telUri => 'tel:${phone.replaceAll(RegExp(r'[^\d+]'), '')}';
}

@immutable
class Stat {
  const Stat({required this.value, required this.label});

  final String value;
  final String label;
}

/// An outbound link. The CV lists no public profiles, so [PortfolioData.links]
/// ships empty — add entries here and every consumer picks them up.
@immutable
class ContactLink {
  const ContactLink({
    required this.label,
    required this.value,
    required this.url,
    required this.kind,
  });

  final String label;
  final String value;
  final String url;
  final ContactKind kind;
}

enum ContactKind { email, phone, location, github, linkedin, website }

@immutable
class ExperienceEntry {
  const ExperienceEntry({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    required this.workMode,
    required this.highlights,
    required this.technologies,
    required this.products,
  });

  final String company;
  final String role;
  final String period;
  final String location;
  final String workMode;

  /// Responsibilities and contributions, one line each.
  final List<String> highlights;
  final List<String> technologies;

  /// Products touched inside this role.
  final List<String> products;
}

@immutable
class SkillGroup {
  const SkillGroup({required this.title, required this.items});

  final String title;
  final List<String> items;
}

/// A single application screenshot.
@immutable
class Screenshot {
  const Screenshot({
    required this.asset,
    required this.caption,
    required this.aspectRatio,
    this.hasDeviceFrame = false,
  });

  final String asset;

  /// What the screen shows — surfaced next to the active frame.
  final String caption;

  /// Intrinsic width / height. Declared so the stage can lay out before the
  /// image decodes, which avoids a reflow on load.
  final double aspectRatio;

  /// `true` when the supplied image *already* contains a phone mockup, in which
  /// case the UI must not draw another frame around it.
  final bool hasDeviceFrame;
}

@immutable
class Project {
  const Project({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.role,
    required this.platform,
    required this.context,
    required this.features,
    required this.technologies,
    required this.screenshots,
    required this.tint,
    required this.icon,
    this.bannerAsset,
    this.liveUrl,
    this.sourceUrl,
  });

  final String id;
  final String name;
  final String category;
  final String description;

  /// What Ahmed personally did on the project.
  final String role;
  final String platform;

  /// Where the work happened — employer, or "Graduation project".
  final String context;
  final List<String> features;
  final List<String> technologies;
  final List<Screenshot> screenshots;

  /// The product's *own* brand colour, sampled from its screenshots. Used only
  /// as a low-alpha wash behind the showcase so each case study feels like its
  /// own product without breaking the site palette.
  final Color tint;

  /// Icon representing the product's domain or function.
  final IconData icon;

  final String? bannerAsset;

  /// Not present in the CV — nullable so the buttons simply don't render.
  final String? liveUrl;
  final String? sourceUrl;
}

/// Projects the CV names but supplies no screenshots for.
@immutable
class AdditionalProject {
  const AdditionalProject({
    required this.name,
    required this.category,
    required this.contribution,
    this.description,
    this.icon,
  });

  final String name;
  final String category;

  /// e.g. "UI development", "REST API integration".
  final String contribution;

  /// Present only where the CV gives one.
  final String? description;

  /// Optional domain icon.
  final IconData? icon;
}

@immutable
class Education {
  const Education({
    required this.degree,
    required this.institution,
    required this.period,
    required this.location,
  });

  final String degree;
  final String institution;
  final String period;
  final String location;
}

@immutable
class Certification {
  const Certification({
    required this.name,
    required this.issuer,
    this.detail = '',
  });

  final String name;
  final String issuer;
  final String detail;
}

@immutable
class LanguageSkill {
  const LanguageSkill({required this.name, required this.level});

  final String name;
  final String level;
}
