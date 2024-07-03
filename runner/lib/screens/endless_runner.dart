import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/src/widgets/image.dart';
import 'package:runner/screens/background.dart';
import 'package:runner/models/player.dart';

class EndlessRunner extends FlameGame with TapDetector {
  EndlessRunner({super.camera});
  static const _imageAssets = [
    'dino_blue.png',
    'hyena.png'
  ];

  Vector2 get virtualSize => camera.viewport.virtualSize;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen(); 
    await Flame.device.setLandscape(); 
    await images.loadAll(_imageAssets);
    camera.viewfinder.position = camera.viewport.virtualSize * 0.5; 
    camera.backdrop.add(BackGroundScreen(speed: 100));
  startGamePlay();
  }
  void startGamePlay() {
    Dino dino = Dino(images.fromCache("dino_blue.png") as Image);
    world.add(dino);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(Hud.id)) {
      _dino.jump();
    }
    super.onTapDown(info);
  }
}