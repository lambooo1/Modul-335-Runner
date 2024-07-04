import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:runner/models/enemy_data.dart';
import 'package:runner/screens/endless_runner.dart';

class Enemy extends SpriteAnimationComponent with CollisionCallbacks, HasGameReference<EndlessRunner> {
  final EnemyData enemyData; 
  Enemy(this.enemyData){
    animation = SpriteAnimation.fromFrameData(
      enemyData.image, 
      SpriteAnimationData.sequenced(
        amount: enemyData.nFrames, 
        stepTime: enemyData.stepTime, 
        textureSize: enemyData.textureSize,
      ),
    ); 
  }

  @override
  void onMount() {
    size *= 0.6;

    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
      ),
    );
    super.onMount();
  }

  @override
  void update(double dt) {
    position.x = enemyData.speedX * dt;

    if (position.x < enemyData.textureSize.x) {
      removeFromParent();
      if (game.playerData.lives == 5) {
        game.playerData.currentScore += 150;
      } else if (game.playerData.lives == 4) {
        game.playerData.currentScore += 300;
      } else if (game.playerData.lives == 3) {
        game.playerData.currentScore += 450;
      } else if (game.playerData.lives == 2) {
        game.playerData.currentScore += 600;
      } else if (game.playerData.lives == 1) {
        game.playerData.currentScore += 750;
      }
    }
    super.update(dt);
  }
}