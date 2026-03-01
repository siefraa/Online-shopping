import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6)));
    _scale = Tween<double>(begin: 0.7, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () { if (mounted) context.go('/onboarding'); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
        begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Center(child: FadeTransition(opacity: _fade, child: ScaleTransition(scale: _scale, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(28)),
          child: const Center(child: Text('🛒', style: TextStyle(fontSize: 52)))),
        const SizedBox(height: 20),
        const Text('Twende Markiti', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        const SizedBox(height: 8),
        Text('Fresh from farm to your door', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)),
        const SizedBox(height: 60),
        SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white.withOpacity(0.7), strokeWidth: 2)),
      ]))))));
}