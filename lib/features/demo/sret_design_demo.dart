import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../shared/liquid_glass.dart';

class SretDesignDemo extends StatelessWidget {
  const SretDesignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      appBar: AppBar(
        title: const Text('SRET Design System'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background with subtle blobs
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    Color(0x1A7A0E2A), // Burgundy 10%
                    Color(0x0A7A0E2A), // Burgundy 4%
                  ],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomRight,
                    radius: 1.2,
                    colors: [
                      Color(0x1ADFA06E), // Copper 10%
                      Color(0x0ADFA06E), // Copper 4%
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Color Palette Card
                LiquidGlass(
                  radius: const BorderRadius.all(Radius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SRET Color Palette',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.sretPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _ColorSwatch('Primary', AppTheme.sretPrimary, '#7A0E2A'),
                            _ColorSwatch('Accent', AppTheme.sretAccent, '#DFA06E'),
                            _ColorSwatch('Background', AppTheme.sretBg, '#FAF6F1'),
                            _ColorSwatch('Surface', AppTheme.sretSurface, '#F7EFE6'),
                            _ColorSwatch('Text', AppTheme.sretText, '#1F1B16'),
                            _ColorSwatch('Divider', AppTheme.sretDivider, '#E7DED3'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 0.2).fadeIn(duration: 400.ms),
                
                const SizedBox(height: 24),
                
                // Typography Card
                LiquidGlass(
                  radius: const BorderRadius.all(Radius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Typography',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.sretPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Headline Large',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          'Headline Medium',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'Headline Small',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Body Large - The quick brown fox jumps over the lazy dog.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Body Medium - The quick brown fox jumps over the lazy dog.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Body Small - The quick brown fox jumps over the lazy dog.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Label Large - BUTTON TEXT',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 0.2).fadeIn(duration: 400.ms, delay: 100.ms),
                
                const SizedBox(height: 24),
                
                // Components Card
                LiquidGlass(
                  radius: const BorderRadius.all(Radius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Components',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.sretPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Primary Button'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text('Outlined Button'),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Text Field
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Text Field',
                            hintText: 'Enter some text',
                            prefixIcon: Icon(Icons.edit),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Switch and Checkbox
                        Row(
                          children: [
                            Switch(value: true, onChanged: (value) {}),
                            const SizedBox(width: 16),
                            Checkbox(value: true, onChanged: (value) {}),
                            const SizedBox(width: 16),
                            Radio<int>(
                              value: 1,
                              groupValue: 1,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 0.2).fadeIn(duration: 400.ms, delay: 200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;
  final String hex;
  
  const _ColorSwatch(this.name, this.color, this.hex);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.sretDivider,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          hex,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.sretTextSecondary,
          ),
        ),
      ],
    );
  }
}
