import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:runner/models/player_data.dart';
import 'package:runner/screens/endless_runner.dart';
import 'package:runner/widgets/game_over_menu.dart';
import 'package:runner/widgets/hud.dart';
import 'package:runner/widgets/main_menu.dart';
import 'package:runner/widgets/pause_menu.dart';
import 'package:runner/widgets/settings_menu.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();
  runApp(const MyApp()); 
}

Future<void> initHive() async {
  if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory(); 
      log(dir.path);
      Hive.init(dir.path);
  }

  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino run',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget<EndlessRunner>.controlled(
          loadingBuilder: (context) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          overlayBuilderMap: {
            MainMenu.id: (_, game) => MainMenu(game),
            PauseMenu.id: (_, game) => PauseMenu(game),
            Hud.id: (_, game) => Hud(game),
            GameOverMenu.id: (_, game) => GameOverMenu(game),
            SettingsMenu.id: (_, game) => SettingsMenu(game),
          },
          initialActiveOverlays: const [MainMenu.id],
          gameFactory: () => EndlessRunner(
            camera: CameraComponent.withFixedResolution(width: 360, height: 180,
            ),
          ),
        )
      ),
    );
  }
}