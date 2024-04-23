import 'package:divider/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class DividerJoystick extends JoystickComponent {
  late Player player;
  DividerJoystick(
      {super.knob,
      super.background,
      super.margin,
      super.position,
      super.size,
      super.knobRadius,
      super.anchor,
      super.children,
      super.priority,
      super.key});

  void addPlayer(Player player) {
    this.player = player;
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    player.move(delta);
    return super.onDragUpdate(event);
  }

  @override
  bool onDragEnd(DragEndEvent event) {
    player.move(Vector2.zero());
    return super.onDragEnd(event);
  }
}
