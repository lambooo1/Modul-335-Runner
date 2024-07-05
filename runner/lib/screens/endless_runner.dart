import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:runner/constants/image_constant.dart';
import 'package:runner/models/player_data.dart';
import 'package:runner/screens/background.dart';
import 'package:runner/screens/dino.dart';
import 'package:runner/widgets/game_over_menu.dart';
import 'package:runner/widgets/hud.dart';
import 'package:runner/widgets/pause_menu.dart';
import 'package:runner/screens/enemy_manager.dart';
import 'package:vibration/vibration.dart';
import 'package:flame_audio/flame_audio.dart';


class EndlessRunner extends FlameGame with TapDetector, HasCollisionDetection {
  EndlessRunner({super.camera});

  Future<void> loadAssets() async{
    await images.loadAll([
      ImageConstants.layer0,
      ImageConstants.layer1,
      ImageConstants.layer2,
      ImageConstants.layer3,
      ImageConstants.layer4,
      ImageConstants.layer5,
      ImageConstants.layer6,
      ImageConstants.layer7,
      ImageConstants.layer8,
      ImageConstants.layer9,
      ImageConstants.light,
      ImageConstants.hyena,
      ImageConstants.vulture,
      ImageConstants.dino,
      ImageConstants.scorpio,
    ]);
    await FlameAudio.audioCache.load('game_over.mp3');
  }

  static const _imageAssets = [
    'dino.png',
    'hyena.png',
    'vulture.png',
    'scorpio.png',
  ];

  late Dino _dino;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  @override
  Future<void> onLoad() async {
    await loadAssets();
    await Flame.device.fullScreen(); 
    await Flame.device.setLandscape(); 
    
    playerData = await _readPlayerData();
    
    await images.loadAll(_imageAssets);
    camera.viewfinder.position = camera.viewport.virtualSize * 0.5; 
    camera.backdrop.add(BackGroundScreen(speed: 100));
  }

  void startGamePlay() {
    _dino = Dino(images.fromCache(ImageConstants.dino), playerData);
    _enemyManager = EnemyManager();

    world.add(_dino);
    world.add(_enemyManager);
  }

  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  void reset() {
    _disconnectActors();
    playerData.currentScore = 0;
    playerData.lives = 5;
  }

  @override
  void update(double dt) async {
    if (playerData.lives <= 0) {
      if (!overlays.isActive(GameOverMenu.id)) {
        overlays.add(GameOverMenu.id);
        overlays.remove(Hud.id);
        pauseEngine();
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 500);
        }
        FlameAudio.play('game_over.mp3');
      }
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
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden: 
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