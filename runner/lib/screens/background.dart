import 'dart:math';
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:runner/constants/image_constant.dart';

class BackGroundScreen  extends ParallaxComponent {
  BackGroundScreen({required this.speed}); 
  final double speed; 
  @override
  Future<void> onLoad() async {
    final layers = [
      ParallaxImageData(ImageConstants.layer0),
      ParallaxImageData(ImageConstants.layer1),
      ParallaxImageData(ImageConstants.layer2),
      ParallaxImageData(ImageConstants.layer3),
      ParallaxImageData(ImageConstants.layer4),
      ParallaxImageData(ImageConstants.layer5),
      ParallaxImageData(ImageConstants.layer6),
      ParallaxImageData(ImageConstants.layer7),
      ParallaxImageData(ImageConstants.layer8),
      ParallaxImageData(ImageConstants.layer9),
    ];
    final baseVelocity = Vector2(speed, pow(2, layers.length), 0);
    final velocityMultiplierDelta = Vector2(2.0, 0.0);
    parallax = await game.loadParallax(
      layers,
      baseVelocity: baseVelocity,
      velocityMultiplierDelta: velocityMultiplierDelta,
      filterQuality: FilterQuality.none,
    );
    return super.onLoad();
  }
}