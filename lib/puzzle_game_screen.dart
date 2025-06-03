import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key, required String imagePath});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen>
    with SingleTickerProviderStateMixin {
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
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _controller.dispose();
    super.dispose();
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _waveController,
            builder: (_, __) => CustomPaint(
              painter: WavePainter(_waveController.value),
              child: Container(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: const Text(
                    "🧩 ¡Resuelve este puzzle!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  centerTitle: false,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
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
                            border: Border.all(
                              color: isSelected ? Colors.yellowAccent : Colors.transparent,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(currentOrder[index], fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "¿Qué representa el puzzle?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Escribe aquí tu respuesta",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white24,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 4,
                  ),
                  child: const Text("Comprobar"),
                ),
                const SizedBox(height: 10),
                Text(
                  feedbackText,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: nextPuzzle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Siguiente puzzle"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B486B), Color(0xFF3B8686)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    const double waveHeight = 30;
    final double waveSpeed = animationValue * 2 * pi;

    path.moveTo(0, size.height);
    for (double i = 0; i <= size.width; i++) {
      final y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight + size.height * 0.9;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
