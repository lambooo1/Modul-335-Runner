import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart';
import 'package:hive/hive.dart';
import 'package:runner/constants/image_constant.dart';
import 'package:runner/models/player_data.dart';
import 'package:runner/screens/background.dart';
import 'package:runner/models/player.dart';
import 'package:lifecycle/lifecycle.dart';



class EndlessRunner extends FlameGame with TapDetector, HasCollisionDetection {
  EndlessRunner({super.camera});

  static const _imageAssets = [
    'imageConstants.dino',
    'imageConstants.hyena',
    'imageConstants.vulture',
    'imageConstants.scoprio',
  ];

  late Dino _dino;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen(); 
    await Flame.device.setLandscape(); 
    
    PlayerData = await _readPlayerData();
    
    await images.loadAll(_imageAssets);
    camera.viewfinder.position = camera.viewport.virtualSize * 0.5; 
    camera.backdrop.add(BackGroundScreen(speed: 100));
  }

  void startGamePlay() {
    _dino = Dino(images.fromCache(ImageConstant.dino) playerData);
    _enemyManager = EnemyManager();

    world.add(_dino);
    world.add(_enemyManager);
  }

  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  void _reset() {
    _disconnectActors();
    playerData.currentScore = 0;
    playerData.lives = 5;
  }

  @override
  void update(double dt) {
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(Hud.id)) {
      _dino.jump();
    }
    super.onTapDown(info);
  }

  Future<PlayerData> _readPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerData>('DinoRun.PlayerDataBox');
    final playerData = playerDataBox.get('DinoRun.PlayerData');

    if (playerData == null) {
      await playerDataBox.put('DinoRun.PlayerData', PlayerData());
    }
    return playerDataBox.get('DinoRun.PlayerData')!;
  }

  @override
  void lifecycleStateChange(AppLifecycleListener state) {
    switch (state) {
      case AppLifecycleListener.resumed:
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleListener.paused:
      case AppLifecycleListener.detached:
      case AppLifecycleListener.inactive:
      case AppLifecycleListener.hidden: 
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}