import 'package:flutter/widgets.dart';
import 'dart:math' as math show sin, pi;

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class ThemedSpinCircle extends StatefulWidget {
  const ThemedSpinCircle({
    Key? key,
    required this.color,
    this.size = 50.0,
    this.child,
    this.childPadding,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : super(key: key);

  final Color? color;
  final double size;
  final double? childPadding;
  final Duration duration;
  final Widget? child;
  final AnimationController? controller;

  @override
  _ThemedSpinCircleState createState() => _ThemedSpinCircleState();
}

class _ThemedSpinCircleState extends State<ThemedSpinCircle>
    with SingleTickerProviderStateMixin {
  final List<double> fadeDelays = [
    .0,
    -1.1,
    -1.0,
    -0.9,
    -0.8,
    -0.7,
    -0.6,
    -0.5,
    -0.4,
    -0.3,
    -0.2,
    -0.1
  ];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(children: [
          if (widget.child != null)
            Center(
                child: SizedBox.fromSize(
                    size: Size.square(widget.size),
                    child: Padding(
                      padding: EdgeInsets.all(widget.childPadding ?? 0),
                      child: FittedBox(fit: BoxFit.cover, child: widget.child!),
                    ))),
          ...List.generate(fadeDelays.length, (i) {
            final _position = widget.size * .5;
            return Positioned.fill(
              left: _position,
              top: _position,
              child: Transform(
                transform: Matrix4.rotationZ(30.0 * i * 0.0174533),
                child: Align(
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale:
                        DelayTween(begin: 0.0, end: 1.0, delay: fadeDelays[i])
                            .animate(_controller),
                    child: FadeTransition(
                      opacity:
                          DelayTween(begin: 0.0, end: 1.0, delay: fadeDelays[i])
                              .animate(_controller),
                      child: SizedBox.fromSize(
                          size: Size.square(widget.size * 0.15),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: widget.color,
                                  shape: BoxShape.circle))),
                    ),
                  ),
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }
}
