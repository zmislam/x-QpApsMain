import 'package:flutter/material.dart';

import 'matrix_gesture_detector.dart';

typedef PointerMoveCallBack = void Function(Offset offset, Key? key);

class OverlayWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onDragStart;
  final PointerMoveCallBack onDragEnd;
  final PointerMoveCallBack onDragUpdate;
  final void Function(Matrix4) onMatrixUpdate;

  const OverlayWidget(
      {required this.child,
      super.key,
      required this.onDragStart,
      required this.onDragUpdate,
      required this.onMatrixUpdate,
      required this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    late Offset offset;

    return Listener(
      onPointerMove: (event) {
        offset = event.position;
        onDragUpdate(offset, key);
      },
      child: MatrixGestureDetector(
          onMatrixUpdate: (m, tm, sm, rm) {
            notifier.value = m;
            onMatrixUpdate(notifier.value);
          },
          onScaleStart: () {
            onDragStart();
          },
          onScaleEnd: () {
            onDragEnd(offset, key);
          },
          child: AnimatedBuilder(
              animation: notifier,
              builder: (context, childWidget) => Transform(
                    transform: notifier.value,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: child,
                      ),
                    ),
                  ))),
    );
  }
}
