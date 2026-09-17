import 'dart:math';
import 'package:flutter/material.dart';

import '../widgets/stat_card.dart';
import '../widgets/drag_bat_button.dart';

class MiniCricketPage extends StatefulWidget {
  const MiniCricketPage({super.key});

  @override
  State<MiniCricketPage> createState() => _MiniCricketPageState();
}

class _MiniCricketPageState extends State<MiniCricketPage> {
  int runs = 0;
  int balls = 6;
  int lastRun = 0;

  final Random random = Random();

  void playShot() {
    if (balls <= 0) {
      return;
    }

    final int run = random.nextInt(7);

    setState(() {
      runs += run;
      balls--;
      lastRun = run;
    });
  }

  void restartGame() {
    setState(() {
      runs = 0;
      balls = 6;
      lastRun = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool gameFinished = balls == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Cricket'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B4FBF),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF2F6FE0),
      body: Column(
        children: [
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatCard(
                imagePath: 'assets/images/bat.png',
                label: 'Runs',
                value: '$runs',
              ),

              const SizedBox(width: 25),

              StatCard(
                imagePath: 'assets/images/ball.png',
                label: 'Balls',
                value: '$balls',
              ),
            ],
          ),

          const SizedBox(height: 30),

          Text(
            lastRun == 0 && runs == 0
                ? ''
                : lastRun == 0
                ? 'No Runs'
                : '$lastRun Runs',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          if (gameFinished)
            ElevatedButton(
              onPressed: restartGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Restart',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          else
            DragBatButton(
              label: 'Bat',
              color: Colors.white,
              textColor: const Color(0xFF1B4FBF),
              onSwing: playShot,
            ),

          const SizedBox(height: 12),

          if (!gameFinished)
            const Text(
              'Drag the Bat to play a shot',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}