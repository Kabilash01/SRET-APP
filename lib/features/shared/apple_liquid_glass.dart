import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AppleLiquidGlass extends StatefulWidget {
  final Widget child;
  final BorderRadius radius;
  final double blur;
  final Duration period;
  final double sheen;
  final double grain;

  const AppleLiquidGlass({
    super.key,
    required this.child,
    this.radius = const BorderRadius.all(Radius.circular(20)),
    this.blur = 24.0,
    this.period = const Duration(seconds: 7),
    this.sheen = 0.08,
    this.grain = 0.04,
  });

  @override
  State<AppleLiquidGlass> createState() => _AppleLiquidGlassState();
}

class _AppleLiquidGlassState extends State<AppleLiquidGlass>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _controller = AnimationController(
      duration: widget.period,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    if (_shouldDisableAnimations()) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _controller.stop();
        break;
      case AppLifecycleState.resumed:
        if (!_shouldDisableAnimations()) {
          _controller.repeat();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        _controller.stop();
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Start animation if not disabled (safe to access MediaQuery here)
    if (!_shouldDisableAnimations()) {
      _controller.repeat();
    }
  }

  bool _shouldDisableAnimations() {
    return MediaQuery.disableAnimationsOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: widget.radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blur,
            sigmaY: widget.blur,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.radius,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x3DFFFFFF), // white 24%
                  Color(0x14FFFFFF), // white 8%
                ],
              ),
              border: Border.all(
                color: const Color(0x47FFFFFF), // white 28%
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.sretPrimary.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Base overlay for vibrancy
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: widget.radius,
                      color: const Color(0x29FFFFFF), // white 16%
                    ),
                  ),
                ),
                
                // Noise texture overlay
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: widget.radius,
                    child: Image.asset(
                      'assets/images/noise.png',
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover,
                      color: Colors.white.withOpacity(widget.grain),
                      colorBlendMode: BlendMode.overlay,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback: programmatic noise
                        return CustomPaint(
                          painter: _NoisePainter(
                            opacity: widget.grain,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Animated liquid sheen
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: ClipRRect(
                        borderRadius: widget.radius,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: widget.radius,
                            gradient: LinearGradient(
                              begin: Alignment(-1.0 + (_animation.value * 3.0), -1.0),
                              end: Alignment(-0.5 + (_animation.value * 3.0), 0.5),
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(widget.sheen),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Vibrancy boost
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: widget.radius,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0x1AFFFFFF), // white 10%
                        BlendMode.screen,
                      ),
                      child: Container(),
                    ),
                  ),
                ),
                
                // Content
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Fallback noise painter when asset is missing
class _NoisePainter extends CustomPainter {
  final double opacity;

  _NoisePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..blendMode = BlendMode.overlay;

    // Generate simple noise pattern
    const tileSize = 4.0;
    for (double x = 0; x < size.width; x += tileSize) {
      for (double y = 0; y < size.height; y += tileSize) {
        final noise = ((x * 7 + y * 13) % 17) / 17.0;
        if (noise > 0.5) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, tileSize, tileSize),
            paint..color = Colors.white.withOpacity(opacity * noise),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
