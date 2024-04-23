import 'package:divider/player.dart';
import 'package:divider/world/world.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/cupertino.dart';

import 'joystick.dart';

class DividerGame extends Forge2DGame {
  DividerGame() : super(world: DividerWorld(), gravity: Vector2.zero());

  @override
  void onLoad() async {
    await super.onLoad();

    // ScreenSize.initialize(this);
    // world.add(Tile(tilePosition: Vector2.zero()));
    // world.add(Tile(tilePosition: Vector2(-48, 0)));
    // world.add(Tile(tilePosition: Vector2(-48, -48)));
    // world.add(Tile(tilePosition: Vector2(0, -48)));

    DividerJoystick joystickComponent = DividerJoystick(
        knob: CircleComponent(
            radius: 16, paint: BasicPalette.red.withAlpha(255).paint()),
        background: CircleComponent(
            radius: 64, paint: BasicPalette.red.withAlpha(100).paint()),
        margin: const EdgeInsets.only(bottom: 100, left: 156));

    Player player = Player()..priority = 1000;
    await world.add(player);
    camera.follow(player);

    joystickComponent.addPlayer(player);
    camera.viewport.add(joystickComponent);

    world.addAll(createBoundaries());
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();

    return [
      // Wall(topLeft, topRight),
      // Wall(topRight, bottomRight),
      // Wall(bottomLeft, bottomRight),
      // Wall(topLeft, bottomLeft),
    ];
  }
}

class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;

  Wall(this._start, this._end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef);//..createFixture(fixtureDef);
  }
}