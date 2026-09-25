import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter/widgets.dart' show IconData;

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
    this.iconAsset,
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

  /// The product's real app icon. When present it replaces [icon] in the
  /// project switcher.
  final String? iconAsset;

  final String? bannerAsset;

  /// Not present in the CV — nullable so the buttons simply don't render.
  final String? liveUrl;
  final String? sourceUrl;
}
