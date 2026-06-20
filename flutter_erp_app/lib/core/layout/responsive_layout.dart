import 'package:flutter/material.dart';
import 'design_tokens.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200 &&
      MediaQuery.of(context).size.width >= 600;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final double spacing;

  const ResponsiveGridView({
    Key? key,
    required this.children,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.spacing = AppSpacing.md,
  }) : super(key: key);

  int _getColumnsCount(BuildContext context) {
    if (ResponsiveLayout.isDesktop(context)) return 4;
    if (ResponsiveLayout.isTablet(context)) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _getColumnsCount(context),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      padding: padding,
      children: children,
    );
  }
}
