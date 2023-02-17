import 'package:flutter/material.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/colors.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class LoadingWidget extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;

  const LoadingWidget({
    super.key,
    this.backgroundColor = TColors.black50,
    this.foregroundColor = TColors.white,
  });

  @override
  State<StatefulWidget> createState() {
    return _LoadingState();
  }
}

class _LoadingState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant LoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_animationController.isAnimating) {
      _animationController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TripLog.d('Loading is tap block');
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.backgroundColor,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => child!,
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Icon(
              Icons.work,
              color: widget.foregroundColor,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
