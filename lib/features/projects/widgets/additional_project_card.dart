import 'package:flutter/material.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/constants/app_spacing.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/shared/widgets/hover_card.dart';
import 'package:portfolio/shared/widgets/tech_chip.dart';

/// A compact tile that expands in place to reveal what was built and the stack.
///
/// Tapping anywhere on the card toggles it; the chevron rotates to point up
/// while open. Tiles with nothing to reveal stay static.
class AdditionalProjectCard extends StatefulWidget {
  const AdditionalProjectCard({super.key, required this.project});

  final AdditionalProject project;

  @override
  State<AdditionalProjectCard> createState() => _AdditionalProjectCardState();
}

class _AdditionalProjectCardState extends State<AdditionalProjectCard> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final project = widget.project;
    final expandable = project.hasDetails;

    return HoverCard(
      onTap: expandable ? _toggle : null,
      semanticLabel: expandable
          ? '${project.name}, ${_expanded ? 'collapse' : 'expand'} details'
          : null,
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppRadius.brMd,
      lift: 3,
      accentAlpha: 0.4,
      shadow: false,
      pinned: _expanded,
      builder: (context, t) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (project.icon != null) _IconBadge(icon: project.icon!, t: t),
              Expanded(
                child: Text(
                  project.name,
                  style: type.subtitle.copyWith(
                    color: colors.textPrimary,
                    fontSize: type.subtitle.fontSize! * 0.85,
                  ),
                ),
              ),
              if (expandable)
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: AppAnimations.base,
                  curve: AppAnimations.standard,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: Color.lerp(colors.textTertiary, colors.primary, t),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            project.category,
            style: type.labelSmall.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 1, color: colors.border),
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.contribution,
            style: type.labelSmall.copyWith(color: colors.textSecondary),
          ),
          if (expandable)
            AnimatedCrossFade(
              duration: AppAnimations.base,
              sizeCurve: AppAnimations.standard,
              firstCurve: AppAnimations.standard,
              secondCurve: AppAnimations.standard,
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: _Details(project: project),
            ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.t});

  final IconData icon;
  final double t;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.lerp(
          colors.surface,
          colors.primary.withValues(alpha: 0.12),
          t,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color.lerp(
            colors.border,
            colors.primary.withValues(alpha: 0.35),
            t,
          )!,
        ),
      ),
      child: Icon(
        icon,
        size: 15,
        color: Color.lerp(colors.textSecondary, colors.primary, t),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.project});

  final AdditionalProject project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.type;
    final heading = type.labelSmall.copyWith(color: colors.textTertiary);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (project.description != null) ...[
            Text('OVERVIEW', style: heading),
            const SizedBox(height: AppSpacing.xs),
            Text(
              project.description!,
              style: type.bodySmall.copyWith(color: colors.textSecondary),
            ),
          ],
          if (project.technologies.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('TECHNOLOGIES', style: heading),
            const SizedBox(height: AppSpacing.sm),
            TechChipRail(items: project.technologies, dense: true),
          ],
        ],
      ),
    );
  }
}
