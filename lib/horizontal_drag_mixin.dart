import 'package:flutter/material.dart';

// Make the mixin generic with a type parameter T that extends StatefulWidget.
mixin HorizontalDragMixin<T extends StatefulWidget> on State<T> {
  final double _minimumDragDistance = 100;
  double _startHorizontalDrag = 0.0;
  double _endHorizontalDrag = 0.0;

  void handleHorizontalDragStart(DragStartDetails details) {
    _startHorizontalDrag = details.globalPosition.dx;
  }

  void handleHorizontalDragUpdate(DragUpdateDetails details) {
    _endHorizontalDrag = details.globalPosition.dx;
  }

  void handleHorizontalDragEnd(DragEndDetails details, BuildContext context) {
    if (_endHorizontalDrag - _startHorizontalDrag > _minimumDragDistance) {
      Navigator.pop(context);
    }
  }
}
