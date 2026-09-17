import 'package:flutter/material.dart';

class DragBatButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onSwing;

  const DragBatButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onSwing,
  });

  @override
  State<DragBatButton> createState() => _DragBatButtonState();
}

class _DragBatButtonState extends State<DragBatButton>
    with SingleTickerProviderStateMixin {
  double handlePosition = 0;

  final double trackHeight = 70;
  final double handleSize = 28;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void dragStart(DragStartDetails details) {
    animationController.stop();
  }

  void dragUpdate(DragUpdateDetails details) {
    setState(() {
      handlePosition += details.delta.dy;

      if (handlePosition < 0) {
        handlePosition = 0;
      }

      if (handlePosition > trackHeight) {
        handlePosition = trackHeight;
      }
    });
  }

  void dragEnd(DragEndDetails details) {
    final bool played = handlePosition >= trackHeight * 0.8;

    final Animation<double> animation = Tween<double>(
      begin: handlePosition,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    animation.addListener(() {
      setState(() {
        handlePosition = animation.value;
      });
    });

    animationController.forward(from: 0);

    if (played) {
      widget.onSwing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onVerticalDragStart: dragStart,
          onVerticalDragUpdate: dragUpdate,
          onVerticalDragEnd: dragEnd,
          child: SizedBox(
            width: 50,
            height: trackHeight + handleSize,
            child: Stack(
              children: [
                Positioned(
                  left: 24,
                  top: handleSize / 2,
                  child: Container(
                    width: 2,
                    height: trackHeight,
                    color: Colors.white38,
                  ),
                ),

                Positioned(
                  left: 11,
                  top: handlePosition,
                  child: Container(
                    width: handleSize,
                    height: handleSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1B4FBF),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 4),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}