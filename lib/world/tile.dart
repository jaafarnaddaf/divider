import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

class Tiles extends BodyComponent {
  Tiles({super.paint,
    super.children,
    super.priority,
    super.renderBody,
    super.bodyDef,
    super.fixtureDefs,
    super.key});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
        position: Vector2.zero(), type: BodyType.static, userData: this);

    return world.createBody(bodyDef);
  }
}

class Tile extends BodyComponent {
  final Vector2 tilePosition;
  int gridSize = 48;
  List<Vector4> buildingSizes = [
    Vector4(18.0, 20.0, 1.0, 0),
    Vector4(12.0, 18.0, 2.0, 1),
    Vector4(14.0, 16.0, 3.0, 2),
    Vector4(16.0, 16.0, 4.0, 3),
    Vector4(20.0, 10.0, 5.0, 4),
    Vector4(12.0, 18.0, 6.0, 5)
  ];
  List<Vector3> treeSizes = [Vector3(6, 7, 1), Vector3(4, 4, 2)];
  List<List<List<Vector2>>> buildingVertices = [
    [
      [Vector2(-8, -10), Vector2(5, -10), Vector2(5, -4), Vector2(-8, -4)],
      [Vector2(-8, 2), Vector2(5, 2), Vector2(5, 8), Vector2(-8, 8)],
      [Vector2(0, -10), Vector2(5, -10), Vector2(5, 8), Vector2(0, 8)],
      [Vector2(5, -4), Vector2(7, -4), Vector2(7, 2), Vector2(5, 2)]
    ],
    [
      [Vector2(-6, -5), Vector2(5, -5), Vector2(5, 5), Vector2(-6, 5)],
      [Vector2(-2, -9), Vector2(1, -9), Vector2(1, 7), Vector2(-2, 7)]
    ],
    [
      [Vector2(-5, -7), Vector2(4, -7), Vector2(4, 6), Vector2(-5, 6)],
      [Vector2(-7, -7), Vector2(6, -7), Vector2(6, -2), Vector2(-7, -2)],
      [Vector2(-7, 1), Vector2(6, 1), Vector2(6, 6), Vector2(-7, 6)]
    ],
    [
      [Vector2(-5, -7), Vector2(4, -7), Vector2(4, 6), Vector2(-5, 6)],
      [Vector2(-7, -7), Vector2(6, -7), Vector2(6, -2), Vector2(-7, -2)],
      [Vector2(-7, 1), Vector2(6, 1), Vector2(6, 6), Vector2(-7, 6)]
    ],
    [
      [Vector2(-10, -3), Vector2(8, -3), Vector2(8, 3), Vector2(-10, 3)],
      [Vector2(-5, -5), Vector2(2, -5), Vector2(2, -3), Vector2(-5, -3)]
    ],
    [
      [Vector2(-6, -6), Vector2(4, -6), Vector2(4, 5), Vector2(-6, 5)],
      [Vector2(-2, -9), Vector2(1, -9), Vector2(1, 7), Vector2(-2, 7)]
    ]
  ];

  Tile({super.paint,
    super.children,
    super.priority,
    super.renderBody,
    super.bodyDef,
    super.fixtureDefs,
    super.key,
    required this.tilePosition});

  @override
  Body createBody() {
    final bodyDef =
    BodyDef(position: tilePosition, type: BodyType.static, userData: this);

    Random random = Random();
    add(SolidColor(
        gridWidth: gridSize + 1,
        gridHeight: gridSize + 1,
        color: const Color(0xFFA7A9AC)));
    add(SolidColor(
        gridWidth: gridSize - 8,
        gridHeight: gridSize - 8,
        position: Vector2(2, 2),
        color: const Color(0xFFE3C596)));
    add(SolidColor(
        gridWidth: gridSize - 12,
        gridHeight: gridSize - 12,
        position: Vector2(4, 4),
        color: const Color(0xFF66A741)));

    // List<List<bool>> used = List.generate(gridSize - 16,
    //     (index) => List.generate(gridSize - 16, (index) => false));
    List<Building> buildingChildren = [];
    List<Tree> treeChildren = [];

    int startX = 0;
    int startY = 0;

    int size = gridSize - 8;

    for (int i = 0; i < size; i++) {
      double maxY = 0;
      for (int j = 0; j < size; j++) {
        int type = Random().nextInt(5);
        switch (type) {
          case 0:
          case 1:
            List<Vector4> eligible = buildingSizes
                .where((e) => e.x < size - j && e.y < size - i)
                .toList();
            if (eligible.isNotEmpty) {
              Vector4 building = eligible[random.nextInt(eligible.length)];
              buildingChildren.add(Building(
                  offset: tilePosition +
                      Vector2(j.toDouble(), i.toDouble()) +
                      Vector2(building.x / 2, building.y / 2) +
                      Vector2(4, 4),
                  index: building.z.toInt(),
                  gridWidth: building.x.toInt(),
                  gridHeight: building.y.toInt(),
                  vertices: buildingVertices[building.w.toInt()]));
              j += building.x.toInt();
              if (building.y > maxY) {
                maxY = building.y;
              }
            }
            break;
          case 2:
          case 3:
          case 4:
            List<Vector3> eligible = treeSizes
                .where((e) => e.x < size - j && e.y < size - i)
                .toList();
            if (eligible.isNotEmpty) {
              Vector3 tree = eligible[random.nextInt(eligible.length)];
              treeChildren.add(Tree(offset: tilePosition +
                  Vector2(j.toDouble(), i.toDouble()) +
                  Vector2(tree.x / 2, tree.y / 2) +
                  Vector2(4, 4),
                  index: tree.z.toInt(),
                  gridWidth: tree.x.toInt(),
                  gridHeight: tree.y.toInt()));
              j += tree.x.toInt();
              if (tree.y > maxY) {
                maxY = tree.y;
              }
            }
            break;
        }
      }
      i += maxY.toInt();
    }

    // for (int i = 4; i < gridSize - 4; i++) {
    //   for (int j = 4; j < gridSize - 4; j++) {
    //     buildingChildren.add(Building(
    //         offset: tilePosition + Vector2(j.toDouble(), i.toDouble()),
    //         index: building.z.toInt(),
    //         gridWidth: building.x.toInt(),
    //         gridHeight: building.y.toInt(),
    //         vertices: buildingVertices[building.w.toInt()]));
    //
    //     j += building.x.toInt();
    //   }
    // }

    // var k = (gridSize - 4);
    // for (int i = 0; i < k * k; i++) {
    //   int x = i % k;
    //   int y = i ~/ k;
    //   buildingChildren.add(Building(
    //       offset: tilePosition + Vector2(x.toDouble(), y.toDouble()),
    //       index: building.z.toInt(),
    //       gridWidth: building.x.toInt(),
    //       gridHeight: building.y.toInt(),
    //       vertices: buildingVertices[building.w.toInt()]));
    //   i += building.x.toInt();
    //   if (i > k) {
    //     i += i + k * 16;
    //   }
    // }
    // print(buildingChildren.length);

    //////////////////////////////////

    // int x= 4;
    // int y =4;
    // int i=0;
    // Map<int,int>shapesMap=new Map();
    // while (i<((gridSize - 4)*(gridSize - 4))){
    //   buildingChildren.add(Building(
    //            offset: tilePosition + Vector2(x.toDouble(), y.toDouble()),
    //            index: building.z.toInt(),
    //            gridWidth: building.x.toInt(),
    //            gridHeight: building.y.toInt(),
    //            vertices: buildingVertices[building.w.toInt()]));
    //   x=x+building.x.toInt();
    //
    //   if(x%gridSize==0){
    //     x=4;
    //     y++;
    //   }
    //
    // }

    //////////////////////////////////

    // int startX = 0;
    // int startY = 0;
    //
    // for (int i = 1; i < gridSize - 4; i++) {
    //   if (i < startX) {
    //     continue;
    //   }
    //   int maxY = 0;
    //   for (int j = 1; j < gridSize - 4; j++) {
    //     if (j < startY) {
    //       continue;
    //     }
    //
    //     List<Vector4> eligible = buildingSizes
    //         .where((e) =>
    //             e.x <= gridSize - startX - 4 && e.y <= gridSize - startY - 4)
    //         .toList();
    //     // 12 <= 48 - 30 - 4
    //
    //     if (eligible.isNotEmpty) {
    //       Vector4 building = eligible[random.nextInt(eligible.length)];
    //
    //       Vector2 offset = tilePosition +
    //               Vector2(4, 4) +
    //               Vector2(building.x / 2, building.y / 2) +
    //               Vector2(startX.toDouble(), startY.toDouble());
    //       print('$i $j $offset ${Vector2(building.x, building.y)} $gridSize ${Vector2(startX.toDouble(), startY.toDouble())}');
    //       buildingChildren.add(Building(
    //           offset: offset,
    //           index: building.z.toInt(),
    //           gridWidth: building.x.toInt(),
    //           gridHeight: building.y.toInt(),
    //           vertices: buildingVertices[building.w.toInt()]));
    //       startX += building.x.toInt();
    //       if (building.y > maxY) {
    //         maxY = building.y.toInt();
    //       }
    //     } else {
    //       startX = 0;
    //       startY += maxY;
    //     }
    //   }
    // }

    // int startX = 1;
    // int startY = 1;
    //
    // for (int i = 1; i < gridSize - 1; i++) {
    //   if (i < startX) {
    //     continue;
    //   }
    //   for (int j = 1; j < gridSize - 1; j++) {
    //     if (j < startY) {
    //       continue;
    //     }
    //     int type = random.nextInt(6);
    //     switch (type) {
    //       case 0:
    //       case 1:
    //         List<Vector4> eligible = buildingSizes
    //             .where((e) =>
    //                 e.x <= gridSize - startX - 1 &&
    //                 e.y <= gridSize - startY - 1)
    //             .toList();
    //         if (eligible.isNotEmpty) {
    //           int index = random.nextInt(eligible.length);
    //           Vector4 building = eligible[index];
    //           buildingChildren.add(Building(
    //               offset: tilePosition + Vector2(startX + 0.0, startY + 0.0),
    //               index: building.z.toInt(),
    //               gridWidth: building.x.toInt(),
    //               gridHeight: building.y.toInt(),
    //               vertices: buildingVertices[building.w.toInt()]));
    //           startX += building.x.toInt();
    //           if (startX >= gridSize - 1) {
    //             startX = 0;
    //             startY += building.y.toInt();
    //           }
    //         }
    //         break;
    //       case 2:
    //       case 3:
    //       case 4:
    //         break;
    //       default:
    //         continue;
    //     }
    //   }
    // }
    // int index = random.nextInt(6);
    // Vector3 building = buildingSizes[index];
    // buildingChildren.add(Building(
    //     offset: tilePosition + Vector2(0 + 16.0, 0 + 16.0),
    //     gridWidth: building.x.toInt(),
    //     gridHeight: building.y.toInt(),
    //     index: building.z.toInt(),
    //     vertices: buildingVertices[index]));
    // for (int i = 0; i < used.length; i++) {
    //   for (int j = 0; j < used.length; j++) {
    //     if (used[i][j]) {
    //       continue;
    //     }
    //     Vector2 area = calculateSpace(used, i, j);
    //     int type = Random().nextInt(5);
    //     switch (type) {
    //       case 0:
    //       case 1:
    //         List<Vector4> eligible = buildingSizes
    //             .where((b) => b.x <= area.x && b.y <= area.y)
    //             .toList();
    //         if (eligible.isNotEmpty) {
    //           int index = random.nextInt(eligible.length);
    //           Vector4 building = eligible[index];
    //           buildingChildren.add(Building(
    //               offset: tilePosition + Vector2(i + 16.0, j.toDouble() + 16.0),
    //               gridWidth: building.x.toInt(),
    //               gridHeight: building.y.toInt(),
    //               index: building.z.toInt(),
    //               vertices: buildingVertices[building.z.toInt() - 1]));
    //           // useArea(used, building + Vector4(2, 2, 0, 0), i, j);
    //         }
    //         break;
    //       case 2:
    //       case 3:
    //       case 4:
    //         List<Vector3> eligible =
    //             treeSizes.where((b) => b.x <= area.x && b.y <= area.y).toList();
    //         if (eligible.isNotEmpty) {
    //           int index = random.nextInt(eligible.length);
    //           Vector3 tree = eligible[index];
    //           treeChildren.add(Tree(
    //               offset: tilePosition + Vector2(i + 5, j + 5),
    //               gridWidth: tree.x.toInt(),
    //               gridHeight: tree.y.toInt(),
    //               index: tree.z.toInt()));
    //           useArea(used, tree, i, j);
    //         }
    //         break;
    //     }
    //   }
    // }

    for (Building element in buildingChildren) {
      world.add(element);
    }

    for (Tree element in treeChildren) {
      world.add(element);
    }

    return world.createBody(bodyDef);
  }

  Vector2 calculateSpace(List<List<bool>> used, int x, int y) {
    Vector2 area = Vector2.zero();

    for (int i = x; i < used.length; i++) {
      if (!used[i][y]) {
        area.x += 1;
      } else {
        break;
      }
    }
    for (int i = y; i < used.length; i++) {
      bool found = false;
      for (int j = 0; j < area.x; j++) {
        if (used[j + x][i]) {
          found = true;
          break;
        }
      }
      if (!found) {
        area.y += 1;
      }
    }
    return area;
  }

  void useArea(List<List<bool>> used, Vector3 area, int x, int y) {
    //
    for (int i = 0; i < area.x; i++) {
      for (int j = 0; j < area.y; j++) {
        if (i + x >= 32 || j + y >= 32) {
          continue;
        }
        used[i + x][j + y] = true;
      }
    }
  }
}

class SolidColor extends PositionComponent {
  final int gridWidth;
  final int gridHeight;
  final Color color;

  SolidColor({super.position,
    required this.gridWidth,
    required this.gridHeight,
    required this.color});

  @override
  void onLoad() {
    super.onLoad();
    add(RectangleComponent(
        paint: Paint()
          ..color = color,
        size: Vector2(gridWidth.toDouble(), gridHeight.toDouble())));
  }
}

class Building extends BodyComponent with CollisionCallbacks {
  final int gridWidth;
  final int gridHeight;
  final Vector2 offset;
  final int index;
  final List<List<Vector2>> vertices;

  Building({super.paint,
    super.children,
    super.priority,
    super.renderBody,
    super.bodyDef,
    super.fixtureDefs,
    super.key,
    required this.offset,
    required this.index,
    required this.gridWidth,
    required this.gridHeight,
    required this.vertices});

  @override
  onLoad() async {
    super.onLoad();
    renderBody = false;
  }

  @override
  Body createBody() {
    final bodyDef =
    BodyDef(position: offset, type: BodyType.static, userData: this);
    add(SvgImageComponent(
        path: 'images/building-$index.svg',
        size: Vector2(gridWidth.toDouble(), gridHeight.toDouble()),
        position: Vector2(-gridWidth / 2, -gridHeight / 2)));
    Body body = world.createBody(bodyDef);
    for (List<Vector2> vectors in vertices) {
      PolygonShape polygon = PolygonShape()
        ..set(vectors);
      body.createFixture(FixtureDef(polygon, friction: 0.3));
    }

    return body;
  }
}

class Tree extends BodyComponent {
  final int gridWidth;
  final int gridHeight;
  final Vector2 offset;
  final int index;

  Tree({super.paint,
    super.children,
    super.priority,
    super.renderBody,
    super.bodyDef,
    super.fixtureDefs,
    super.key,
    required this.offset,
    required this.index,
    required this.gridWidth,
    required this.gridHeight});

  @override
  Body createBody() {
    final bodyDef =
    BodyDef(position: offset, type: BodyType.static, userData: this);

    add(SvgImageComponent(
        path: 'images/tree-$index.svg',
        size: Vector2(gridWidth.toDouble(), gridHeight.toDouble()),
        position: Vector2(-gridWidth / 2, -gridHeight / 2)));
    return world.createBody(bodyDef);
  }
}

class SvgImageComponent extends Component {
  final String path;
  final Vector2 size;
  final Vector2? position;

  SvgImageComponent({super.children,
    super.priority,
    super.key,
    this.position,
    required this.path,
    required this.size});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final svgInstance = await Svg.load(path);
    final svgComponent = SvgComponent(
        size: size * 16,
        scale: Vector2(0.06125, 0.06125),
        svg: svgInstance,
        position: position);

    add(svgComponent);
  }
}
