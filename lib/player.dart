import 'package:divider/world/tile.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Player extends BodyComponent {
  double speed = 0.25;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    body.setFixedRotation(true);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(1.25, 2);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
        position: Vector2.zero(), type: BodyType.dynamic, userData: this);
    SvgImageComponent component = SvgImageComponent(
        path: 'images/fighter-ak-l.svg',
        size: Vector2(4, 4),
        position: Vector2(-2, -2));
    add(component);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void move(Vector2 delta) {
    body.linearVelocity = delta * speed;
  }
}
