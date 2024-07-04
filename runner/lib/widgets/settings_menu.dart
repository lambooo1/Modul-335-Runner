import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runner/screens/endless_runner.dart';
import 'package:runner/widgets/main_menu.dart';

class SettingsMenu extends StatelessWidget {
  static const id = 'SettingsMenu';
  final EndlessRunner game;
  const SettingsMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {},
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
              color: Colors.black.withAlpha(100),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20, 
                  horizontal: 100
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        game.overlays.remove(SettingsMenu.id);
                        game.overlays.add(MainMenu.id);
                      }, 
                      child: const Icon(Icons.arrow_back_ios_rounded),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}