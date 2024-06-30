import 'package:flutter/material.dart';
import 'package:other_animations/src/animations.dart';
import 'package:other_animations/src/compound_transition_animation/compound_transition_animation.dart';
import 'package:other_animations/src/compound_transition_animation/dual_transition_animation.dart';
import 'package:other_animations/src/dual_transition_animation_builder.dart';
import 'package:other_animations/src/motion.dart';

/// Determines which type of shared axis transition is used.
enum SharedAxisTransitionType {
  /// Creates a shared axis vertical (y-axis) page transition.
  vertical,

  /// Creates a shared axis horizontal (x-axis) page transition.
  horizontal,

  /// Creates a shared axis scaled (z-axis) page transition.
  scaled,
}

/// Used by [PageTransitionsTheme] to define a page route transition animation
/// in which outgoing and incoming elements share a fade transition.
///
/// The shared axis pattern provides the transition animation between UI elements
/// that have a spatial or navigational relationship. For example,
/// transitioning from one page of a sign up page to the next one.
///
/// The following example shows how the SharedAxisPageTransitionsBuilder can
/// be used in a [PageTransitionsTheme] to change the default transitions
/// of [MaterialPageRoute]s.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     pageTransitionsTheme: PageTransitionsTheme(
///       builders: {
///         TargetPlatform.android: SharedAxisPageTransitionsBuilder(
///           transitionType: SharedAxisTransitionType.horizontal,
///         ),
///         TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
///           transitionType: SharedAxisTransitionType.horizontal,
///         ),
///       },
///     ),
///   ),
///   routes: {
///     '/': (BuildContext context) {
///       return Container(
///         color: Colors.red,
///         child: Center(
///           child: ElevatedButton(
///             child: Text('Push route'),
///             onPressed: () {
///               Navigator.of(context).pushNamed('/a');
///             },
///           ),
///         ),
///       );
///     },
///     '/a' : (BuildContext context) {
///       return Container(
///         color: Colors.blue,
///         child: Center(
///           child: ElevatedButton(
///             child: Text('Pop route'),
///             onPressed: () {
///               Navigator.of(context).pop();
///             },
///           ),
///         ),
///       );
///     },
///   },
/// );
/// ```
class SharedAxisPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Construct a [SharedAxisPageTransitionsBuilder].
  const SharedAxisPageTransitionsBuilder({
    required this.transitionType,
    this.fillColor,
  });

  /// Determines which [SharedAxisTransitionType] to build.
  final SharedAxisTransitionType transitionType;

  /// The color to use for the background color during the transition.
  ///
  /// This defaults to the [Theme]'s [ThemeData.colorScheme.background].
  final Color? fillColor;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: transitionType,
        fillColor: fillColor,
        child: child,
      );
}

/// Defines a transition in which outgoing and incoming elements share a fade
/// transition.
///
/// The shared axis pattern provides the transition animation between UI elements
/// that have a spatial or navigational relationship. For example,
/// transitioning from one page of a sign up page to the next one.
///
/// Consider using [SharedAxisTransition] within a
/// [PageTransitionsTheme] if you want to apply this kind of transition to
/// [MaterialPageRoute] transitions within a Navigator (see
/// [SharedAxisPageTransitionsBuilder] for example code).
///
/// This transition can also be used directly in a
/// [PageTransitionSwitcher.transitionBuilder] to transition
/// from one widget to another as seen in the following example:
///
/// ```dart
/// int _selectedIndex = 0;
///
/// final List<Color> _colors = [Colors.white, Colors.red, Colors.yellow];
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(
///       title: const Text('Page Transition Example'),
///     ),
///     body: PageTransitionSwitcher(
///       // reverse: true, // uncomment to see transition in reverse
///       transitionBuilder: (
///         Widget child,
///         Animation<double> primaryAnimation,
///         Animation<double> secondaryAnimation,
///       ) {
///         return SharedAxisTransition(
///           animation: primaryAnimation,
///           secondaryAnimation: secondaryAnimation,
///           transitionType: SharedAxisTransitionType.horizontal,
///           child: child,
///         );
///       },
///       child: Container(
///         key: ValueKey<int>(_selectedIndex),
///         color: _colors[_selectedIndex],
///         child: Center(
///           child: FlutterLogo(size: 300),
///         )
///       ),
///     ),
///     bottomNavigationBar: BottomNavigationBar(
///       items: const <BottomNavigationBarItem>[
///         BottomNavigationBarItem(
///           icon: Icon(Icons.home),
///           title: Text('White'),
///         ),
///         BottomNavigationBarItem(
///           icon: Icon(Icons.business),
///           title: Text('Red'),
///         ),
///         BottomNavigationBarItem(
///           icon: Icon(Icons.school),
///           title: Text('Yellow'),
///         ),
///       ],
///       currentIndex: _selectedIndex,
///       onTap: (int index) {
///         setState(() {
///           _selectedIndex = index;
///         });
///       },
///     ),
///   );
/// }
/// ```
class SharedAxisTransition extends StatelessWidget {
  /// Creates a [SharedAxisTransition].
  ///
  /// The [animation] and [secondaryAnimation] argument are required and must
  /// not be null.
  const SharedAxisTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.transitionType,
    required this.child,
    this.fillColor,
    this.onEnd,
    this.onStatusChanged,
    this.sliver = false,
  });

  /// Callback to be called when the animation ends.
  final VoidCallback? onEnd;

  /// Callback when the animation status changes. This is called before [onEnd].
  final ValueChanged<AnimationStatus>? onStatusChanged;

  /// The animation that drives the [child]'s entrance and exit.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.animate], which is the value given to this property
  ///    when it is used as a page transition.
  final Animation<double> animation;

  /// The animation that transitions [child] when new content is pushed on top
  /// of it.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.secondaryAnimation], which is the value given to this
  ///    property when the it is used as a page transition.
  final Animation<double> secondaryAnimation;

  /// Determines which type of shared axis transition is used.
  ///
  /// See also:
  ///
  ///  * [SharedAxisTransitionType], which defines and describes all shared
  ///    axis transition types.
  final SharedAxisTransitionType transitionType;

  /// The color to use for the background color during the transition.
  ///
  /// This defaults to the [Theme]'s [ThemeData.canvasColor].
  final Color? fillColor;

  /// The widget below this widget in the tree.
  ///
  /// This widget will transition in and out as driven by [animation] and
  /// [secondaryAnimation].
  final Widget child;

  /// Whether to use sliver variants of animation widgets.
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        return DualTransitionAnimationBuilder(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          onStatusChanged: onStatusChanged,
          onEnd: onEnd,
          getAnimations: (animation, secondaryAnimation) => [
            DualTransitionAnimation<double>(
              compound: CompoundTransitionAnimation.compoundOpacity,
              animation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundOpacity,
                animation: animation,
                forwardAnimatable: _EnterTransition._fadeInTransition,
                reverseAnimatable: _ExitTransition._fadeOutTransition,
              ),
              secondaryAnimation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundOpacity,
                animation: secondaryAnimation!,
                forwardAnimatable: _EnterTransition._fadeInTransition,
                reverseAnimatable: _ExitTransition._fadeOutTransition,
              ),
            ),
            DualTransitionAnimation<Offset>(
              compound: CompoundTransitionAnimation.compoundTranslation,
              animation: CompoundTransitionAnimation<Offset>(
                compound: CompoundTransitionAnimation.compoundTranslation,
                animation: animation,
                forwardAnimatable: _EnterTransition._horizontalSlideInTransition,
                reverseAnimatable: _ExitTransition._horizontalSlideOutTransitionReversed,
              ),
              secondaryAnimation: CompoundTransitionAnimation<Offset>(
                compound: CompoundTransitionAnimation.compoundTranslation,
                animation: secondaryAnimation,
                forwardAnimatable: _EnterTransition._horizontalSlideInTransitionReversed,
                reverseAnimatable: _ExitTransition._horizontalSlideOutTransition,
              ),
            ),
          ],
          builder: (context, animations, child) => Animations.translate(
            offset: animations[1] as DualTransitionAnimation<Offset>,
            sliver: sliver,
            child: Animations.fade(
              opacity: animations[0] as DualTransitionAnimation<double>,
              sliver: sliver,
              child: child,
            ),
          ),
        );
      case SharedAxisTransitionType.vertical:
        return DualTransitionAnimationBuilder(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          onStatusChanged: onStatusChanged,
          onEnd: onEnd,
          getAnimations: (animation, secondaryAnimation) => [
            DualTransitionAnimation<double>(
              compound: CompoundTransitionAnimation.compoundOpacity,
              animation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundOpacity,
                animation: animation,
                forwardAnimatable: _EnterTransition._fadeInTransition,
                reverseAnimatable: _ExitTransition._fadeOutTransition,
              ),
              secondaryAnimation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundOpacity,
                animation: secondaryAnimation!,
                forwardAnimatable: _EnterTransition._fadeInTransition,
                reverseAnimatable: _ExitTransition._fadeOutTransition,
              ),
            ),
            DualTransitionAnimation<Offset>(
              compound: CompoundTransitionAnimation.compoundTranslation,
              animation: CompoundTransitionAnimation<Offset>(
                compound: CompoundTransitionAnimation.compoundTranslation,
                animation: animation,
                forwardAnimatable: _EnterTransition._verticalSlideInTransition,
                reverseAnimatable: _ExitTransition._verticalSlideOutTransitionReversed,
              ),
              secondaryAnimation: CompoundTransitionAnimation<Offset>(
                compound: CompoundTransitionAnimation.compoundTranslation,
                animation: secondaryAnimation,
                forwardAnimatable: _EnterTransition._verticalSlideInTransitionReversed,
                reverseAnimatable: _ExitTransition._verticalSlideOutTransition,
              ),
            ),
          ],
          builder: (context, animations, child) => Animations.translate(
            offset: animations[1] as DualTransitionAnimation<Offset>,
            sliver: sliver,
            child: Animations.fade(
              opacity: animations[0] as DualTransitionAnimation<double>,
              sliver: sliver,
              child: child,
            ),
          ),
        );
      case SharedAxisTransitionType.scaled:
        return DualTransitionAnimationBuilder(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          onStatusChanged: onStatusChanged,
          onEnd: onEnd,
          getAnimations: (animation, secondaryAnimation) => [
            DualTransitionAnimation<double>(
              compound: CompoundTransitionAnimation.compoundOpacity,
              animation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundOpacity,
                animation: animation,
                forwardAnimatable: _EnterTransition._fadeInTransition,
                reverseAnimatable: _ExitTransition._fadeOutTransition,
              ),
              secondaryAnimation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundOpacity,
                animation: secondaryAnimation!,
                forwardAnimatable: _EnterTransition._fadeInTransition,
                reverseAnimatable: _ExitTransition._fadeOutTransition,
              ),
            ),
            DualTransitionAnimation<double>(
              compound: CompoundTransitionAnimation.compoundScale,
              animation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundScale,
                animation: animation,
                forwardAnimatable: _EnterTransition._scaleUpTransition,
                reverseAnimatable: _ExitTransition._scaleDownTransition,
              ),
              secondaryAnimation: CompoundTransitionAnimation<double>(
                compound: CompoundTransitionAnimation.compoundScale,
                animation: secondaryAnimation,
                forwardAnimatable: _EnterTransition._scaleUpTransition,
                reverseAnimatable: _ExitTransition._scaleDownTransition,
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
  }
}

class _EnterTransition extends StatelessWidget {
  const _EnterTransition({
    required this.animation,
    required this.transitionType,
    required this.child,
    this.reverse = false,
    this.sliver = false,
    this.inherit = false,
  });

  final Animation<double> animation;
  final SharedAxisTransitionType transitionType;
  final Widget child;
  final bool reverse;
  final bool sliver;
  final bool inherit;

  static final Animatable<double> _fadeInTransition = CurveTween(
    curve: Motion.easing.emphasizedDecelerate,
  ).chain(CurveTween(curve: const Interval(0.3, 1.0)));

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.10,
    end: 1.00,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 0.80,
    end: 1.00,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _horizontalSlideInTransition = Tween<Offset>(
    begin: const Offset(30.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _horizontalSlideInTransitionReversed = Tween<Offset>(
    begin: const Offset(-30.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _verticalSlideInTransition = Tween<Offset>(
    begin: const Offset(0.0, 30.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _verticalSlideInTransitionReversed = Tween<Offset>(
    begin: const Offset(0.0, -30.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  @override
  Widget build(BuildContext context) {
    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        return Animations.fade(
          opacity: _fadeInTransition.animate(animation),
          sliver: sliver,
          child: Animations.translate(
            offset: (!reverse ? _horizontalSlideInTransition : _horizontalSlideInTransitionReversed).animate(animation),
            child: child,
            sliver: sliver,
          ),
        );
      case SharedAxisTransitionType.vertical:
        return Animations.fade(
          opacity: _fadeInTransition.animate(animation),
          sliver: sliver,
          child: Animations.translate(
            offset: (!reverse ? _verticalSlideInTransition : _verticalSlideInTransitionReversed).animate(animation),
            child: child,
            sliver: sliver,
          ),
        );
      case SharedAxisTransitionType.scaled:
        return Animations.fade(
          opacity: _fadeInTransition.animate(animation),
          sliver: sliver,
          child: Animations.scale(
            scale: (!reverse ? _scaleUpTransition : _scaleDownTransition).animate(animation),
            child: child,
            sliver: sliver,
          ),
        );
    }
  }
}

class _ExitTransition extends StatelessWidget {
  const _ExitTransition({
    required this.animation,
    required this.transitionType,
    required this.fillColor,
    required this.child,
    this.reverse = false,
    this.sliver = false,
    this.inherit = false,
  });

  final Animation<double> animation;
  final SharedAxisTransitionType transitionType;
  final bool reverse;
  final Color fillColor;
  final Widget child;
  final bool sliver;
  final bool inherit;

  static final Animatable<double> _fadeOutTransition = _FlippedCurveTween(
    curve: Motion.easing.emphasizedAccelerate,
  ).chain(CurveTween(curve: const Interval(0.0, 0.3)));

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 1.00,
    end: 1.10,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.00,
    end: 0.80,
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _horizontalSlideOutTransition = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-30.0, 0.0),
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _horizontalSlideOutTransitionReversed = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(30.0, 0.0),
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _verticalSlideOutTransition = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -30.0),
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  static final Animatable<Offset> _verticalSlideOutTransitionReversed = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 30.0),
  ).chain(CurveTween(curve: Motion.easing.emphasized));

  @override
  Widget build(BuildContext context) {
    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        Widget widget = Animations.translate(
          offset: (!reverse ? _horizontalSlideOutTransition : _horizontalSlideOutTransitionReversed).animate(animation),
          child: child,
          sliver: sliver,
        );

        if (!inherit && fillColor != Colors.transparent) {
          widget = ColoredBox(color: fillColor, child: child);
        }

        return Animations.fade(
          opacity: _fadeOutTransition.animate(animation),
          child: widget,
          sliver: sliver,
        );
      case SharedAxisTransitionType.vertical:
        Widget widget = Animations.translate(
          offset: (!reverse ? _verticalSlideOutTransition : _verticalSlideOutTransitionReversed).animate(animation),
          child: child,
          sliver: sliver,
        );

        if (!inherit && fillColor != Colors.transparent) {
          widget = ColoredBox(color: fillColor, child: child);
        }

        return Animations.fade(
          opacity: _fadeOutTransition.animate(animation),
          child: widget,
          sliver: sliver,
        );
      case SharedAxisTransitionType.scaled:
        Widget widget = Animations.scale(
          scale: (!reverse ? _scaleUpTransition : _scaleDownTransition).animate(animation),
          child: child,
          sliver: sliver,
        );

        if (!inherit && fillColor != Colors.transparent) {
          widget = ColoredBox(color: fillColor, child: widget);
        }

        return Animations.fade(
          opacity: _fadeOutTransition.animate(animation),
          child: widget,
          sliver: sliver,
        );
    }
  }
}

/// Enables creating a flipped [CurveTween].
///
/// This creates a [CurveTween] that evaluates to a result that flips the
/// tween vertically.
///
/// This tween sequence assumes that the evaluated result has to be a double
/// between 0.0 and 1.0.
class _FlippedCurveTween extends CurveTween {
  /// Creates a vertically flipped [CurveTween].
  _FlippedCurveTween({required super.curve});

  @override
  double transform(double t) => 1.0 - super.transform(t);
}
