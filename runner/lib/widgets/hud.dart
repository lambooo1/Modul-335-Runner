
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runner/models/player_data.dart';
import 'package:runner/screens/endless_runner.dart';
import 'package:runner/widgets/pause_menu.dart';

class Hud extends StatelessWidget {
  static const id = 'Hud';
  final EndlessRunner game;
  const Hud(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.currentScore,
                  builder: (_, score, __) {
                    return Text(
                      'Score: $score', 
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      );
                  },
                ),
                Selector<PlayerData, int>(
                  selector: (_, playData) => playData.highScore,
                  builder: (_, highScore, __) {
                    return Text(
                      'High Score: $highScore', 
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      );
                  },
                ),
              ],
              ),
              TextButton(
                onPressed: (){
                  game.overlays.remove(Hud.id);
                  game.overlays.add(PauseMenu.id);
                  game.pauseEngine();
                },
                child: const Icon(Icons.pause, color: Colors.white),
                ),
              Selector<PlayerData, int>(
                selector: (_, playerData) => playerData.lives,
                builder: (_, lives, __) {
                  return Row(
                    children: List.generate(5, (index) {
                      if (index < lives) {
                        return const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        );
                      } else {
                        return const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        );
                      }
                    }),
                  );
                }
                ),
              ],
            ),
        )
      );
  }
}