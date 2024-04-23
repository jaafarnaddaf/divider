import 'package:flame/extensions.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/cupertino.dart';

class ScreenSize {
  static Vector2 _size = Vector2.zero();
  static Vector2 _canvasSize = Vector2.zero();

  static void initialize(Forge2DGame game) {
    Rect rect = game.camera.visibleWorldRect;
    _size = Vector2(rect.width, rect.height);
    _canvasSize = game.canvasSize;
  }

  static Vector2 percentageSize(double width, double height) {
    final visibleWidth = _size.x;
    final sizedWidth = width * visibleWidth;
    final sizedHeight = height * visibleWidth;
    return Vector2(sizedWidth, sizedHeight);
  }

  static Vector2 coordinates(double x, double y) {
    return Vector2(x - _size.x / 2, y - _size.y / 2);
  }

  static Vector2 margin(EdgeInsets edgeInsets) {
    double x = edgeInsets.left;
    double y = edgeInsets.top;

    if(edgeInsets.left == 0 && edgeInsets.right == 0) {
      x = _size.x / 2;
    } else if(edgeInsets.left == 0) {
      x = _size.x - edgeInsets.right;
    }

    if(edgeInsets.top == 0 && edgeInsets.bottom == 0) {
      y = _size.y / 2;
    } else if(edgeInsets.top == 0) {
      y = _size.y - edgeInsets.bottom;
    }

    return coordinates(x, y);
  }
}
