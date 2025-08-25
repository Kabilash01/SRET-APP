import 'package:flutter/material.dart';

class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget? leadingIcon;
  final String? semanticLabel;
  final double minHeight;

  const BouncyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.leadingIcon,
    this.semanticLabel,
    this.minHeight = 48,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _resetButton();
  }

  void _onTapCancel() {
    _resetButton();
  }

  void _resetButton() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse().then((_) {
        // Spring back effect
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final foregroundColor = widget.foregroundColor ?? theme.colorScheme.onPrimary;

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: widget.onPressed != null && !widget.isLoading,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onPressed != null && !widget.isLoading ? widget.onPressed : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: widget.minHeight,
                  minWidth: 44, // Minimum tap target size
                ),
                padding: widget.padding ?? 
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: backgroundColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.leadingIcon != null && !widget.isLoading) ...[
                      widget.leadingIcon!,
                      const SizedBox(width: 12),
                    ],
                    if (widget.isLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                        ),
                      )
                    else
                      DefaultTextStyle(
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        child: widget.child,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
