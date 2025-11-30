import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final Color? color;
  final double? size;
  const LoadingIndicatorWidget({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: size ?? 60,
          height: size ?? 60,
          child: LoadingIndicator(
            colors: [color ?? Theme.of(context).primaryColor],
            indicatorType: Indicator.ballBeat,
          )),
    );
  }
}
