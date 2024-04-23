import 'dart:async';

import 'package:divider/player.dart';
import 'package:divider/utility/size.dart';
import 'package:divider/world/tile.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class DividerWorld extends Forge2DWorld
    with TapCallbacks, DragCallbacks, HasGameReference<Forge2DGame> {
  final Player player = Player()..priority = 1000;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    ScreenSize.initialize(game);
    add(Tile(tilePosition: Vector2.zero()));
    add(Tile(tilePosition: Vector2(-48, 0)));
    add(Tile(tilePosition: Vector2(-48, -48)));
    add(Tile(tilePosition: Vector2(0, -48)));

    // await add(player);
    // game.camera.follow(player);
  }
}
