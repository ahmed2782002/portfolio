import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';

/// The strip below the stage: a thumbnail per screenshot, the active one marked
/// by a growing indigo rule rather than a border, so nothing shifts position.
class ScreenshotThumbnails extends StatelessWidget {
  const ScreenshotThumbnails({
    super.key,
    required this.screenshots,
    required this.activeIndex,
    required this.onSelect,
    required this.tint,
  });

  final List<Screenshot> screenshots;
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final Color tint;

  static const double _height = 66;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height + 12,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: screenshots.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => _Thumbnail(
          screenshot: screenshots[index],
          index: index,
          isActive: index == activeIndex,
          tint: tint,
          onTap: () => onSelect(index),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatefulWidget {
  const _Thumbnail({
    required this.screenshot,
    required this.index,
    required this.isActive,
    required this.tint,
    required this.onTap,
  });

  final Screenshot screenshot;
  final int index;
  final bool isActive;
  final Color tint;
  final VoidCallback onTap;

  @override
  State<_Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<_Thumbnail> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const height = ScreenshotThumbnails._height;
    final width = height * widget.screenshot.aspectRatio;
    final emphasised = widget.isActive || _hovering;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Semantics(
        button: true,
        selected: widget.isActive,
        label: 'Show screenshot ${widget.index + 1}',
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppAnimations.base,
                curve: AppAnimations.standard,
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.brXs,
                  border: Border.all(
                    color: emphasised ? widget.tint : colors.border,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xs - 1),
                  child: AnimatedOpacity(
                    duration: AppAnimations.base,
                    opacity: emphasised ? 1 : 0.55,
                    child: Image.asset(
                      widget.screenshot.asset,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      cacheWidth: (width * 2).round(),
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: AppAnimations.base,
                curve: AppAnimations.emphasized,
                height: 2,
                width: widget.isActive ? width : 0,
                color: widget.tint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
