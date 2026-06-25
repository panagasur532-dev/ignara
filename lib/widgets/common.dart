import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/tier_system.dart';

class LCCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const LCCard({
    super.key,
    required this.child,
    this.borderColor,
    this.padding,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? LCColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor ?? LCColors.border),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: padding ?? const EdgeInsets.all(14),
            child: child,
          ),
        ),
      ),
    );
  }
}

class LCPill extends StatelessWidget {
  final String label;
  final Color color;

  const LCPill(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
    );
  }
}

class LCAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? color;

  const LCAvatar({super.key, required this.initials, this.size = 44, this.color});

  static const _colors = [LCColors.primary, LCColors.blue, LCColors.red, LCColors.gold, LCColors.purple, LCColors.orange];

  Color get _color => color ?? _colors[initials.codeUnitAt(0) % _colors.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color.withOpacity(0.12),
        border: Border.all(color: _color.withOpacity(0.4), width: 1.5),
      ),
      child: Center(
        child: Text(initials, style: TextStyle(fontSize: size * 0.32, fontWeight: FontWeight.w500, color: _color)),
      ),
    );
  }
}

class LCSectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const LCSectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Row(
        children: [
          Text(text.toUpperCase(),
            style: const TextStyle(fontSize: 10, color: LCColors.textDim, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}

class LCProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const LCProgressBar({super.key, required this.value, required this.color, this.height = 6});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) => Stack(children: [
      Container(height: height, width: c.maxWidth, decoration: BoxDecoration(
        color: LCColors.surfaceAlt, borderRadius: BorderRadius.circular(height / 2))),
      Container(height: height, width: c.maxWidth * value.clamp(0, 1), decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(height / 2))),
    ]));
  }
}

class LCStatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final String? sub;

  const LCStatBox({super.key, required this.label, required this.value, required this.valueColor, this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LCColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LCColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: valueColor)),
        if (sub != null) Text(sub!, style: const TextStyle(fontSize: 10, color: LCColors.textDim)),
      ]),
    );
  }
}

class LCDividerRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const LCDividerRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [left, right]),
    );
  }
}

class LCTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String brand;
  final String title;
  final Widget? trailing;
  final List<Widget>? bottomWidgets;

  const LCTopBar({super.key, required this.brand, required this.title, this.trailing, this.bottomWidgets});

  @override
  Size get preferredSize => Size.fromHeight(bottomWidgets != null ? 100 : 64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LCColors.bg,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 12),
      child: Column(children: [
        Row(children: [
          Row(children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.asset(
                'favicon/app logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'favicon/app logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(brand.toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: 2, color: LCColors.primary, fontWeight: FontWeight.w500)),
              Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
            ]),
          ]),
          const Spacer(),
          if (trailing != null) trailing!,
        ]),
        if (bottomWidgets != null) ...[const SizedBox(height: 10), ...bottomWidgets!],
      ]),
    );
  }
}

/// Display tier image badges with optional size customization
class LCTierImage extends StatelessWidget {
  final TierDefinition tier;
  final double size;
  final bool showLabel;
  final Color? labelColor;

  const LCTierImage({
    super.key,
    required this.tier,
    this.size = 24,
    this.showLabel = false,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          tier.imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'favicon/app logo.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            tier.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor ?? tier.color,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact tier badge for inline display
class LCTierBadge extends StatelessWidget {
  final TierDefinition tier;
  final double imageSize;
  final bool compact;

  const LCTierBadge({
    super.key,
    required this.tier,
    this.imageSize = 14,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: tier.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tier.color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            tier.imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'favicon/app logo.png',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              tier.displayName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: tier.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
