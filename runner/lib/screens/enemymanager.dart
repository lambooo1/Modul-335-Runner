import 'dart:math';

import 'package:flame/components.dart';
import 'package:runner/constants/image_constant.dart';
import 'package:runner/models/enemy_data.dart';
import 'package:runner/screens/endless_runner.dart';
import 'package:runner/screens/enemy.dart';

class Enemymanager extends Component with HasGameRef<EndlessRunner> {
  final List<EnemyData> _data = [];
  final Random _random = Random();
  final Timer _timerStart = Timer(2, repeat: true);

  Enemymanager() {
    _timerStart.onTick = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = Enemy(enemyData);
    
    enemy.position = Vector2(
      game.virtualSize.x + 32,
      game.virtualSize.y - 12,
    );

    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * game.virtualSize.y;
      enemy.position.y -= newHeight;
    }

    enemy.size = enemyData.textureSize;  
    game.world.add(enemy);
  }

  @override
  void onMount(){
    if (isMounted) {
      removeFromParent(); 
    }

    if (_data.isEmpty) {
      _data.addAll([
        EnemyData(
          image: game.images.fromCache(ImageConstant.scorpio),
          nFrames: 4,
          stepTime: 0.1,
          textureSize: Vector2(48, 48),
          speedX: 80,
          canFly: false,
        ),
        EnemyData(
          image: game.images.fromCache(ImageConstant.vulture),
          nFrames: 6,
          stepTime: 0.09,
          textureSize: Vector2(48, 48),
          speedX: 150,
          canFly: true,
        ),
        EnemyData(
          image: game.images.fromCache(ImageConstant.hyena),
          nFrames: 6,
          stepTime: 0.09,
          textureSize: Vector2(48, 48),
          speedX: 150,
          canFly: false,
        ),
      ]);
    }
    _timerStart.start();
    super.onMount();
  }
  
  @override
  void update(double dt) {
    _timerStart.update(dt);
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = game.world.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}