import 'package:chemical_reaction_balancer/imports.dart';

class OverlayTooltipManager {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void showTooltip({
    required BuildContext context,
    required GlobalKey buttonKey,
    required String message,
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    bool showArrow = true,
    bool autoDismiss = true,
    TooltipPosition position = TooltipPosition.top,
  }) {
    // Hide existing tooltip if showing
    hideTooltip();

    final RenderBox? renderBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonSize = renderBox.size;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => OverlayTooltip(
            buttonPosition: buttonPosition,
            buttonSize: buttonSize,
            message: message,
            backgroundColor: backgroundColor ?? Colors.black87,
            textColor: textColor ?? Colors.white,
            fontSize: fontSize ?? 14,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            showArrow: showArrow,
            position: position,
            onDismiss: hideTooltip,
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;

    // Auto-hide after duration
    if (duration != null && autoDismiss) {
      Future.delayed(duration, () {
        hideTooltip();
      });
    }
  }

  static void hideTooltip() {
    if (_isShowing && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }

  static bool get isShowing => _isShowing;
}

enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class OverlayTooltip extends StatefulWidget {
  final Offset buttonPosition;
  final Size buttonSize;
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final bool showArrow;
  final TooltipPosition position;
  final VoidCallback onDismiss;

  const OverlayTooltip({
    super.key,
    required this.buttonPosition,
    required this.buttonSize,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.padding,
    required this.borderRadius,
    required this.showArrow,
    required this.position,
    required this.onDismiss,
  });

  @override
  State<OverlayTooltip> createState() => _OverlayTooltipState();
}

class _OverlayTooltipState extends State<OverlayTooltip> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(30),
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.translucent,
        child: SizedBox.expand(child: Stack(children: [_buildTooltip()])),
      ),
    );
  }

  Widget _buildTooltip() {
    final tooltipOffset = _calculateTooltipPosition();

    return Positioned(
      left: tooltipOffset.dx,
      top: tooltipOffset.dy,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showArrow && _shouldShowArrowAbove()) _buildArrow(true),
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(70),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: widget.padding,
            child: Text(
              widget.message,
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          if (widget.showArrow && !_shouldShowArrowAbove())
            _buildArrow(false),
        ],
      ),
    );
  }

  Widget _buildArrow(bool pointingDown) {
    return CustomPaint(
      size: const Size(16, 8),
      painter: ArrowPainter(
        color: widget.backgroundColor,
        pointingDown: pointingDown,
      ),
    );
  }

  bool _shouldShowArrowAbove() {
    return widget.position == TooltipPosition.bottom ||
        widget.position == TooltipPosition.bottomLeft ||
        widget.position == TooltipPosition.bottomRight;
  }

  Offset _calculateTooltipPosition() {
    const tooltipSpacing = 8.0;
    const arrowHeight = 8.0;

    final screenSize = MediaQuery.of(context).size;
    final buttonCenter = Offset(
      widget.buttonPosition.dx + widget.buttonSize.width / 2,
      widget.buttonPosition.dy + widget.buttonSize.height / 2,
    );

    double x = 0;
    double y = 0;

    switch (widget.position) {
      case TooltipPosition.top:
        x = buttonCenter.dx - 125; // Assuming max width 250, center it
        y = widget.buttonPosition.dy - tooltipSpacing - arrowHeight;
        break;
      case TooltipPosition.bottom:
        x = buttonCenter.dx - 125;
        y =
            widget.buttonPosition.dy +
            widget.buttonSize.height +
            tooltipSpacing +
            arrowHeight;
        break;
      case TooltipPosition.left:
        x = widget.buttonPosition.dx - 250 - tooltipSpacing;
        y = buttonCenter.dy - 25; // Approximate tooltip height / 2
        break;
      case TooltipPosition.right:
        x = widget.buttonPosition.dx + widget.buttonSize.width + tooltipSpacing;
        y = buttonCenter.dy - 25;
        break;
      case TooltipPosition.topLeft:
        x = widget.buttonPosition.dx;
        y = widget.buttonPosition.dy - tooltipSpacing - arrowHeight;
        break;
      case TooltipPosition.topRight:
        x = widget.buttonPosition.dx + widget.buttonSize.width - 250;
        y = widget.buttonPosition.dy - tooltipSpacing - arrowHeight;
        break;
      case TooltipPosition.bottomLeft:
        x = widget.buttonPosition.dx;
        y =
            widget.buttonPosition.dy +
            widget.buttonSize.height +
            tooltipSpacing +
            arrowHeight;
        break;
      case TooltipPosition.bottomRight:
        x = widget.buttonPosition.dx + widget.buttonSize.width - 250;
        y =
            widget.buttonPosition.dy +
            widget.buttonSize.height +
            tooltipSpacing +
            arrowHeight;
        break;
    }

    // Ensure tooltip stays within screen bounds
    x = x.clamp(8.0, screenSize.width - 258); // 250 + 8 padding
    y = y.clamp(
      8.0,
      screenSize.height - 100,
    ); // Approximate tooltip height + padding

    return Offset(x, y);
  }
}

class ArrowPainter extends CustomPainter {
  final Color color;
  final bool pointingDown;

  ArrowPainter({required this.color, required this.pointingDown});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    if (pointingDown) {
      // Arrow pointing down
      path.moveTo(size.width / 2, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else {
      // Arrow pointing up
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
