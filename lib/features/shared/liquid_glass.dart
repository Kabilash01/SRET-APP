import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlass extends StatefulWidget {
  final Widget child;
  final BorderRadius radius;
  final double blur;
  final Duration period;

  const LiquidGlass({
    super.key,
    required this.child,
    this.radius = const BorderRadius.all(Radius.circular(20)),
    this.blur = 18,
    this.period = const Duration(seconds: 7),
  });

  @override
  State<LiquidGlass> createState() => _LiquidGlassState();
}

class _LiquidGlassState extends State<LiquidGlass>
    with TickerProviderStateMixin {
  late AnimationController _sheenController;
  late AnimationController _driftController;
  late Animation<double> _sheenAnimation;
  late Animation<Offset> _driftAnimation;

  @override
  void initState() {
    super.initState();
    
    // Sheen animation (rotating gradient)
    _sheenController = AnimationController(
      duration: widget.period,
      vsync: this,
    );
    _sheenAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _sheenController,
      curve: Curves.linear,
    ));

    // Drift animation (moving highlight)
    _driftController = AnimationController(
      duration: Duration(seconds: widget.period.inSeconds * 2),
      vsync: this,
    );
    _driftAnimation = Tween<Offset>(
      begin: const Offset(-0.5, -0.5),
      end: const Offset(1.5, 1.5),
    ).animate(CurvedAnimation(
      parent: _driftController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final tickerEnabled = TickerMode.of(context);
    
    if (!disableAnimations && tickerEnabled) {
      _sheenController.repeat();
      _driftController.repeat(reverse: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startAnimations();
  }

  @override
  void dispose() {
    _sheenController.dispose();
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: widget.radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: AnimatedBuilder(
            animation: Listenable.merge([_sheenController, _driftController]),
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: widget.radius,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.22),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7A0E2A).withOpacity(0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Base frosted layer
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: widget.radius,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0x33FFFFFF), // White 20%
                            Color(0x0FFFFFFF), // White 6%
                          ],
                        ),
                        color: Colors.white.withOpacity(0.16),
                      ),
                    ),
                    
                    // Animated sheen layer
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: widget.radius,
                          gradient: LinearGradient(
                            begin: Alignment(
                              cos(_sheenAnimation.value - pi / 4),
                              sin(_sheenAnimation.value - pi / 4),
                            ),
                            end: Alignment(
                              cos(_sheenAnimation.value + 3 * pi / 4),
                              sin(_sheenAnimation.value + 3 * pi / 4),
                            ),
                            colors: [
                              Colors.white.withOpacity(0.10),
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.10),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    
                    // Drifting highlight
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: widget.radius,
                          gradient: RadialGradient(
                            center: Alignment(
                              _driftAnimation.value.dx,
                              _driftAnimation.value.dy,
                            ),
                            radius: 0.6,
                            colors: [
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Content
                    widget.child,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
