import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IslandData {
  double x;
  double y;
  int level;
  int type; // 1-10 painter index
  double buttonDx;
  double buttonDy;
  double rotation;

  IslandData({
    required this.x,
    required this.y,
    required this.level,
    required this.type,
    this.buttonDx = 0.0,
    this.buttonDy = 0.0,
    this.rotation = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'level': level,
    'type': type,
    'buttonDx': buttonDx,
    'buttonDy': buttonDy,
    'rotation': rotation,
  };

  factory IslandData.fromJson(Map<String, dynamic> json) => IslandData(
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    level: json['level'] as int,
    type: json['type'] as int,
    buttonDx: (json['buttonDx'] as num?)?.toDouble() ?? 0.0,
    buttonDy: (json['buttonDy'] as num?)?.toDouble() ?? 0.0,
    rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
  );
}

class StoneData {
  String id;
  double x;
  double y;
  double scale;
  double rotation;
  int type; // 1-6 painter index

  StoneData({
    required this.id,
    required this.x,
    required this.y,
    required this.scale,
    required this.rotation,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'x': x,
    'y': y,
    'scale': scale,
    'rotation': rotation,
    'type': type,
  };

  factory StoneData.fromJson(Map<String, dynamic> json) => StoneData(
    id: json['id'] as String,
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    scale: (json['scale'] as num).toDouble(),
    rotation: (json['rotation'] as num).toDouble(),
    type: json['type'] as int,
  );
}

class MapLayoutConfig {
  static final MapLayoutConfig instance = MapLayoutConfig._internal();
  MapLayoutConfig._internal();

  final ValueNotifier<List<IslandData>> islands = ValueNotifier([]);
  final ValueNotifier<List<StoneData>> stones = ValueNotifier([]);
  final ValueNotifier<List<double>?> editorCamera = ValueNotifier(null);

  // The base canvas height. Let's make it fixed so absolute coordinates work reliably.
  double virtualHeight = 2500.0;

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Always use the hardcoded layout as the fixed map for the game
    _generateDefaultLayout();

    String? cameraData = prefs.getString('map_camera');
    if (cameraData != null) {
      List<dynamic> parsedCamera = jsonDecode(cameraData);
      editorCamera.value = parsedCamera
          .map((e) => (e as num).toDouble())
          .toList();
    }
  }

  void _printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String islandsStr = jsonEncode(
      islands.value.map((e) => e.toJson()).toList(),
    );
    String stonesStr = jsonEncode(stones.value.map((e) => e.toJson()).toList());
    await prefs.setString('map_islands', islandsStr);
    await prefs.setString('map_stones', stonesStr);
    if (editorCamera.value != null) {
      await prefs.setString('map_camera', jsonEncode(editorCamera.value));
    }

    print('==============================');
    print('=== COPY THE DATA BELOW ====');
    print('==============================');
    print('MAP_ISLANDS_DATA:');
    _printWrapped(islandsStr);
    print('MAP_STONES_DATA:');
    _printWrapped(stonesStr);
    print('==============================');
    print('=== END OF DATA ====');
    print('==============================');
  }

  void updateIsland(int level, double dx, double dy) {
    var list = List<IslandData>.from(islands.value);
    int index = list.indexWhere((i) => i.level == level);
    if (index != -1) {
      list[index].x += dx;
      list[index].y += dy;
      islands.value = list;
    }
  }

  void updateStone(String id, double dx, double dy) {
    var list = List<StoneData>.from(stones.value);
    int index = list.indexWhere((s) => s.id == id);
    if (index != -1) {
      list[index].x += dx;
      list[index].y += dy;
      stones.value = list;
    }
  }

  void _generateDefaultLayout() {
    List<IslandData> defaultIslands = [
      IslandData(
        x: 74.81481481481508,
        y: 2286.1000,
        level: 1,
        type: 5,
        buttonDx: 0.7407407407407232,
        buttonDy: 36.29629629629689,
        rotation: 0.0,
      ),
      IslandData(
        x: 294.07407407407413,
        y: 2336.0445,
        level: 2,
        type: 4,
        buttonDx: -23.33333333333326,
        buttonDy: -33.70370370370423,
        rotation: 0.0,
      ),
      IslandData(
        x: 286.6666666666665,
        y: 2192.5445,
        level: 3,
        type: 7,
        buttonDx: 34.07407407407401,
        buttonDy: -2.5925925925922892,
        rotation: 0.0,
      ),
      IslandData(
        x: 121.85185185185205,
        y: 2107.9333,
        level: 4,
        type: 10,
        buttonDx: -23.703703703703713,
        buttonDy: -27.777777777777686,
        rotation: 0.0,
      ),
      IslandData(
        x: 267.4074074074074,
        y: 2006.1556,
        level: 5,
        type: 9,
        buttonDx: -11.111111111111072,
        buttonDy: 3.7037037037036904,
        rotation: 0.0,
      ),
      IslandData(
        x: 111.3300859922821,
        y: 1902.0004,
        level: 6,
        type: 8,
        buttonDx: -11.111111111111011,
        buttonDy: 1.851851851851847,
        rotation: 0.0,
      ),
      IslandData(
        x: 299.212962962963,
        y: 1816.7276,
        level: 7,
        type: 2,
        buttonDx: -7.777777777777752,
        buttonDy: -22.96296296296288,
        rotation: 0.0,
      ),
      IslandData(
        x: 154.78009259259292,
        y: 1618.0861,
        level: 8,
        type: 3,
        buttonDx: -9.259259259259197,
        buttonDy: 51.851851851851656,
        rotation: 0.0,
      ),
      IslandData(
        x: 156.45974164417726,
        y: 1458.0861, // Closer to level 8
        level: 9,
        type: 10,
        buttonDx: -22.962962962962884,
        buttonDy: -25.92592592592584,
        rotation: 0.0,
      ),
    ];

    List<StoneData> defaultStones = [
      StoneData(
        id: 'stone_7',
        x: 244.61540981361085,
        y: 2366.1848,
        scale: 0.8408392680818797,
        rotation: 0.2734329649607917,
        type: 6,
      ),
      StoneData(
        id: 'stone_10',
        x: 222.01613350253774,
        y: 1920.2697,
        scale: 0.7744999315388634,
        rotation: -0.17822569022914117,
        type: 5,
      ),
      StoneData(
        id: 'stone_11',
        x: 245.3840534644118,
        y: 1742.7106,
        scale: 0.8782746624903588,
        rotation: -0.245182278235656,
        type: 5,
      ),
      StoneData(
        id: 'stone_12',
        x: 161.27326951803764,
        y: 2029.5667,
        scale: 0.7787374745826761,
        rotation: -0.08802919013081978,
        type: 1,
      ),

      StoneData(
        id: 'stone_21',
        x: 209.72308264331102,
        y: 1882.7008,
        scale: 0.8554494772682775,
        rotation: 0.0029872160081841903,
        type: 4,
      ),
      StoneData(
        id: 'stone_22',
        x: 234.05663721772123,
        y: 1849.4201,
        scale: 0.7744986194069415,
        rotation: 0.1420683369913356,
        type: 3,
      ),
      StoneData(
        id: 'stone_23',
        x: 76.18720567113236,
        y: 1603.7725,
        scale: 0.7246040830481506,
        rotation: 0.09693860886090827,
        type: 1,
      ),
      StoneData(
        id: 'stone_level2_3_1',
        x: 290.0,
        y: 2264.0,
        scale: 0.8,
        rotation: 0.1,
        type: 3,
      ),
      StoneData(
        id: 'stone_1781298649056',
        x: 183.00925925925895,
        y: 2154.3083,
        scale: 1.0,
        rotation: 6.283185307179586,
        type: 3,
      ),
      StoneData(
        id: 'stone_1781298674807',
        x: 129.67592592592624,
        y: 2058.7528,
        scale: 1.0,
        rotation: 0.0,
        type: 4,
      ),
      StoneData(
        id: 'stone_1781298688223',
        x: 149.67592592592578,
        y: 2136.0861,
        scale: 1.0,
        rotation: 0.0,
        type: 4,
      ),

      StoneData(
        id: 'stone_level8_9_1',
        x: 140.0,
        y: 1564.0861,
        scale: 0.8,
        rotation: 0.1,
        type: 2,
      ),
      StoneData(
        id: 'stone_level8_9_2',
        x: 165.0,
        y: 1511.0861,
        scale: 0.9,
        rotation: -0.2,
        type: 5,
      ),
    ];

    // Crop empty space by finding the highest level and making it exactly 40px from the top
    double highestY = defaultIslands
        .map((e) => e.y)
        .reduce((a, b) => a < b ? a : b);
    double offsetY = highestY - 200.0;

    for (var i in defaultIslands) {
      i.y -= offsetY;
    }
    for (var s in defaultStones) {
      s.y -= offsetY;
    }

    // Shrink the virtual height to wrap the new bottom-most element
    double lowestY = 0;
    for (var i in defaultIslands) {
      if (i.y > lowestY) lowestY = i.y;
    }
    for (var s in defaultStones) {
      if (s.y > lowestY) lowestY = s.y;
    }

    virtualHeight = lowestY + 150.0; // Minimal padding below Level 1

    islands.value = defaultIslands;
    stones.value = defaultStones;
  }
}
