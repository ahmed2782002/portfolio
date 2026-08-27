import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../extensions/context_extensions.dart';

/// Opens external URIs — `mailto:`, `tel:` and `https:` — and surfaces a
/// readable message if the platform refuses.
///
/// A blocked pop-up or a machine with no mail client is a normal outcome on the
/// web, so the failure path shows the raw value instead of failing silently:
/// the visitor can still read and copy the address.
abstract final class LinkLauncher {
  static Future<void> open(BuildContext context, String url) async {
    if (url.isEmpty) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    final colors = context.colors;
    final textStyle = context.type.bodySmall.copyWith(color: colors.background);

    try {
      final uri = Uri.parse(url);
      // `mailto:` / `tel:` must hand off in the current tab, or the browser is
      // left sitting on a blank one. Everything else opens alongside the site.
      final handoff = uri.scheme == 'mailto' || uri.scheme == 'tel';
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: handoff ? '_self' : '_blank',
      );
      if (launched) return;
    } catch (_) {
      // Fall through to the message below.
    }

    messenger?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.textPrimary,
        content: Text(
          "Couldn't open that automatically — $url",
          style: textStyle,
        ),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  /// Opens a bundled asset (the CV) in a new tab.
  ///
  /// Flutter Web serves bundled assets under `/assets/<asset key>`, and the key
  /// already begins with `assets/` — hence the doubled segment. Resolving
  /// against [Uri.base] keeps it correct when the site is hosted under a
  /// sub-path such as `example.com/portfolio/`.
  static Future<void> openAsset(BuildContext context, String assetKey) =>
      open(context, Uri.base.resolve('assets/$assetKey').toString());
}
