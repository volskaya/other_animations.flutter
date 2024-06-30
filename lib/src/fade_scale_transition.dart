import 'package:flutter/material.dart' hide decelerateEasing; // ignore: undefined_hidden_name
import 'package:other_animations/src/animations.dart';
import 'package:other_animations/src/compound_transition_animation/compound_transition_animation.dart';
import 'package:other_animations/src/compound_transition_animation/dual_transition_animation.dart';
import 'package:other_animations/src/dual_transition_animation_builder.dart';
import 'package:other_animations/src/motion.dart';

import 'modal.dart';

/// The modal transition configuration for a Material fade transition.
///
/// The fade pattern is used for UI elements that enter or exit from within
/// the screen bounds. Elements that enter use a quick fade in and scale from
/// 80% to 100%. Elements that exit simply fade out. The scale animation is
/// only applied to entering elements to emphasize new content over old.
///
/// ```dart
/// /// Sample widget that uses [showModal] with [FadeScaleTransitionConfiguration].
/// class MyHomePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: ElevatedButton(
///           onPressed: () {
///             showModal(
///               context: context,
///               configuration: FadeScaleTransitionConfiguration(),
///               builder: (BuildContext context) {
///                 return _CenteredFlutterLogo();
///               },
///             );
///           },
///           child: Icon(Icons.add),
///         ),
///       ),
///     );
///   }
/// }
///
/// /// Displays a centered Flutter logo with size constraints.
/// class _CenteredFlutterLogo extends StatelessWidget {
///   const _CenteredFlutterLogo();
///
///   @override
///   Widget build(BuildContext context) {
///     return Center(
///       child: SizedBox(
///         width: 250,
///         height: 250,
///         child: const Material(
///           child: Center(
///             child: FlutterLogo(size: 250),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class FadeScaleTransitionConfiguration extends ModalConfiguration {
  /// Creates the Material fade transition configuration.
  ///
  /// [barrierDismissible] configures whether or not tapping the modal's
  /// scrim dismisses the modal. [barrierLabel] sets the semantic label for
  /// a dismissible barrier. [barrierDismissible] cannot be null. If
  /// [barrierDismissible] is true, the [barrierLabel] cannot be null.
  const FadeScaleTransitionConfiguration({
    super.barrierColor,
    super.barrierDismissible,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.barrierLabel,
  });

  @override
  Widget transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeScaleTransition(
      animation: animation,
      child: child,
    );
  }
}

/// A widget that implements the Material fade transition.
///
/// The fade pattern is used for UI elements that enter or exit from within
/// the screen bounds. Elements that enter use a quick fade in and scale from
/// 80% to 100%. Elements that exit simply fade out. The scale animation is
/// only applied to entering elements to emphasize new content over old.
///
/// This widget is not to be confused with Flutter's [FadeTransition] widget,
/// which animates only the opacity of its child widget.
class FadeScaleTransition extends StatelessWidget {
  /// Creates a widget that implements the Material fade transition.
  ///
  /// The fade pattern is used for UI elements that enter or exit from within
  /// the screen bounds. Elements that enter use a quick fade in and scale from
  /// 80% to 100%. Elements that exit simply fade out. The scale animation is
  /// only applied to entering elements to emphasize new content over old.
  ///
  /// This widget is not to be confused with Flutter's [FadeTransition] widget,
  /// which animates only the opacity of its child widget.
  ///
  /// [animation] is typically an [AnimationController] that drives the transition
  /// animation. [animation] cannot be null.
  const FadeScaleTransition({
    super.key,
    required this.animation,
    required this.child,
    this.sliver = false,
  });

  /// The animation that drives the [child]'s entrance and exit.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.animate], which is the value given to this property
  ///    when it is used as a page transition.
  final Animation<double> animation;

  /// The widget below this widget in the tree.
  ///
  /// This widget will transition in and out as driven by [animation] and
  /// [secondaryAnimation].
  final Widget child;

  /// Whether to use sliver variants of animation widgets.
  final bool sliver;

  static final Animatable<double> _fadeInTransition = CurveTween(curve: const Interval(0.0, 0.3));
  static final Animatable<double> _scaleInTransition =
      Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: Motion.easing.emphasizedDecelerate));
  static final Animatable<double> _fadeOutTransition = Tween<double>(begin: 1.0, end: 0.0);

  @override
  Widget build(BuildContext context) => DualTransitionAnimationBuilder(
        child: child,
        animation: animation,
        getAnimations: (animation, secondaryAnimation) => [
          DualTransitionAnimation<double>(
            compound: CompoundTransitionAnimation.compoundOpacity,
            animation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundOpacity,
                animation: animation,
                forwardAnimatable: _fadeInTransition,
                reverseAnimatable: _fadeOutTransition),
          ),
          DualTransitionAnimation<double>(
            compound: CompoundTransitionAnimation.compoundScale,
            animation: CompoundTransitionAnimation<double>(
              compound: CompoundTransitionAnimation.compoundScale,
              animation: animation,
              forwardAnimatable: _scaleInTransition,
            ),
          ),
        ],
        builder: (context, animations, child) => Animations.scale(
          scale: animations[1] as DualTransitionAnimation<double>,
          sliver: sliver,
          child: Animations.fade(
            opacity: animations[0] as DualTransitionAnimation<double>,
            sliver: sliver,
            child: child,
          ),
        ),
      );
}
