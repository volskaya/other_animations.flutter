import 'package:flutter/material.dart';
import 'package:sliver_transform/sliver_transform.dart';

class Animations {
  static Widget fade({
    Key? key,
    required Animation<double> opacity,
    required Widget child,
    bool sliver = false,
  }) =>
      sliver
          ? SliverFadeTransition(key: key, opacity: opacity, sliver: child)
          : FadeTransition(key: key, opacity: opacity, child: child);

  static Widget translate({
    Key? key,
    required Animation<Offset> offset,
    required Widget child,
    bool sliver = false,
  }) =>
      sliver
          ? _SliverTranslateTransition(key: key, offset: offset, sliver: child)
          : _TranslateTransition(key: key, offset: offset, child: child);

  static Widget scale({
    Key? key,
    required Animation<double> scale,
    required Widget child,
    bool sliver = false,
  }) =>
      sliver
          ? _SliverScaleTransition(key: key, scale: scale, sliver: child)
          : ScaleTransition(key: key, scale: scale, child: child);
}

class _SliverScaleTransition extends AnimatedWidget {
  const _SliverScaleTransition({
    super.key,
    required this.scale,
    this.alignment = Alignment.center,
    this.sliver,
  }) : super(listenable: scale);

  final Animation<double> scale;
  final Alignment alignment;
  final Widget? sliver;

  @override
  Widget build(BuildContext context) {
    final double scaleValue = scale.value;
    final Matrix4 transform = Matrix4.identity()..scale(scaleValue, scaleValue, 1.0);

    return SliverTransform(
      transform: transform,
      alignment: alignment,
      sliver: sliver,
    );
  }
}

class _TranslateTransition extends AnimatedWidget {
  const _TranslateTransition({
    super.key,
    required this.offset,
    this.child,
    this.transformHitTests = false, // I don't indend these to get transformed in material animations.
  }) : super(listenable: offset);

  final Widget? child;
  final Animation<Offset> offset;
  final bool transformHitTests;

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: offset.value,
        child: child,
        transformHitTests: transformHitTests,
      );
}

class _SliverTranslateTransition extends AnimatedWidget {
  const _SliverTranslateTransition({
    super.key,
    required this.offset,
    this.sliver,
  }) : super(listenable: offset);

  final Widget? sliver;
  final Animation<Offset> offset;

  @override
  Widget build(BuildContext context) => SliverTransform.translate(
        offset: offset.value,
        sliver: sliver,
      );
}
