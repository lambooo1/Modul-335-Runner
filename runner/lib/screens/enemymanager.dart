import 'package:flame/extensions.dart';
import 'package:flame/game.dart';

final List<EnemyData> _data = [];

  void spawnRandomEnemy() {
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = Enemy(enemyData);
    
    enemy.position = Vector2(
      game.virtualSize.x + 32,
      game.virtualSize.y - 12,
    );
    enemy.size = enemyData.textureSize;  
    game.world.add(enemy);
  }

  @override
  void onMOunt(){
    if (isMounted) {
      removeFromParent(); 
    }

    if (_data.isEmpty) {
      _data.addAll([
        EnemyData(
          image: game.images.fromCache('hyena.png'),
          nFrames: 16,
          stepTimes: 0.1,
          textureSize: Vector2(36, 30),
          speedX: 80,
          canFly: false,
        )
      ]);
    }
    _timerStart.start();
    super.onMount();
  }