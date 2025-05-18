import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'dart:math';

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key, required String imagePath});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  int currentPuzzleIndex = 0;
  final List<String> puzzleNames = ['estrella', 'coche', 'dragón'];
  final List<List<String>> puzzlePieces = [
    [
      'assets/images/puzzle_piece_1.png',
      'assets/images/puzzle_piece_2.png',
      'assets/images/puzzle_piece_3.png',
      'assets/images/puzzle_piece_4.png',
    ],
    [
      'assets/images/puzzle_coche_piece_1.png',
      'assets/images/puzzle_coche_piece_2.png',
      'assets/images/puzzle_coche_piece_3.png',
      'assets/images/puzzle_coche_piece_4.png',
    ],
    [
      'assets/images/a_1.jpg',
      'assets/images/a_2.jpg',
      'assets/images/a_3.jpg',
      'assets/images/a_4.jpg',
    ],
  ];

  late List<String> currentOrder;
  int? selectedIndex;
  final TextEditingController _controller = TextEditingController();
  String feedbackText = '';

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
  }

  void _loadPuzzle() {
    currentOrder = List.from(puzzlePieces[currentPuzzleIndex]);
    currentOrder.shuffle(Random());
    selectedIndex = null;
    feedbackText = '';
    _controller.clear();
  }

 void swapPieces(int i, int j) {
  setState(() {
    final temp = currentOrder[i];
    currentOrder[i] = currentOrder[j];
    currentOrder[j] = temp;
    selectedIndex = null;

    if (listEquals(currentOrder, puzzlePieces[currentPuzzleIndex])) {
      feedbackText = '🎉 ¡Correcto!';
    }
  });
}

  void checkAnswer() {
    if (_controller.text.trim().toLowerCase() == puzzleNames[currentPuzzleIndex]) {
      setState(() {
        feedbackText = '🎉 ¡Correcto!';
      });
    } else {
      setState(() {
        feedbackText = '❌ Inténtalo de nuevo';
      });
    }
  }

  void nextPuzzle() {
    setState(() {
      currentPuzzleIndex = (currentPuzzleIndex + 1) % puzzlePieces.length;
      _loadPuzzle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        title: const Text("🧩 ¡Resuelve este puzzle!", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF14749A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedIndex == null) {
                        selectedIndex = index;
                      } else {
                        swapPieces(selectedIndex!, index);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ? Colors.yellow : Colors.transparent, width: 4),
                    ),
                    child: Image.asset(currentOrder[index]),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("¿Qué representa el puzzle?", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Escribe aquí tu respuesta',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: checkAnswer,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
              child: const Text("Comprobar", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            Text(feedbackText, style: const TextStyle(fontSize: 18, color: Colors.white)),
            const Spacer(),
            ElevatedButton(
              onPressed: nextPuzzle,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              child: const Text("Siguiente puzzle", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
