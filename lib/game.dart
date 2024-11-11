import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/background.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/ground.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/components/pipe_manager.dart';
import 'package:flappy_bird/components/score.dart';
import 'package:flappy_bird/constants.dart';
import 'package:flutter/material.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  /*
  Basic Game Components:

   - bird
   - background
   -ground
   - pipes
   -score

  */

  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  /*

  LOAD

  */
  @override
  FutureOr<void> onLoad() {
    // load background
    background = Background(size);
    add(background);

    // load bird
    bird = Bird();
    add(bird);

    // load ground
    ground = Ground();
    add(ground);

    // load pipes
    pipeManager = PipeManager();
    add(pipeManager);

    // load scores
    scoreText = ScoreText();
    add(scoreText);
  }

  /*

  TAP

  */

  @override
  void onTap() {
    bird.flap();
  }

  /*

  SCORE

  */

  int score = 0;

  void incrementScore() {
    score += 1;
  }

  /*

  GAME OVER 

  */

  bool isGameOver = false;
  void gameOver() {
    // prevent multiple game over triggers
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();

    // show dialog box for user
    showDialog(
      context: buildContext!,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("High Score:$score"),
        actions: [
          TextButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // reset game
              resetGame();
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }

  void resetGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    score = 0;
    isGameOver = false;
    // Remove all pipes from the game
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
  }
}
