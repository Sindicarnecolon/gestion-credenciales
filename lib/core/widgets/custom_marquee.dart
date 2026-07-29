import 'package:flutter/material.dart';

/// Widget de Marquesina nativo en Flutter.
///
/// Desplaza continuamente el texto de derecha a izquierda sin depender
/// de paquetes externos pesados.
class CustomMarquee extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final double height;
  final Color backgroundColor;

  const CustomMarquee({
    super.key,
    required this.text,
    this.textStyle,
    this.height = 36.0,
    this.backgroundColor = const Color(0xFF0D47A1),
  });

  @override
  State<CustomMarquee> createState() => _CustomMarqueeState();
}

class _CustomMarqueeState extends State<CustomMarquee>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    while (mounted) {
      if (!_scrollController.hasClients) return;
      final maxExtent = _scrollController.position.maxScrollExtent;
      if (maxExtent > 0) {
        await _scrollController.animateTo(
          maxExtent,
          duration: Duration(milliseconds: (maxExtent * 40).toInt()),
          curve: Curves.linear,
        );
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: widget.backgroundColor,
      alignment: Alignment.center,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                '${widget.text}       ${widget.text}       ${widget.text}',
                style: widget.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
