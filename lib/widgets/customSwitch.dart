import 'package:flutter/material.dart';
import 'package:snagom_app/globals/customTheme.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  int defaultDecoration = 0;
  CustomSwitch({Key key, this.value, this.onChanged, this.defaultDecoration})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 45.0,
            height: 25.0,
            decoration: widget.defaultDecoration == null
                ? switchDecoration()
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 14,
                          spreadRadius: -1,
                          color: Color(0x0ffcfcfe2)),
                    ],
                  ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                alignment:
                    widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20.0,
                  height: 30.0,
                  decoration: widget.defaultDecoration == null
                      ? switchCircleDecoration()
                      : switchCircleDecoration2(widget.value),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
