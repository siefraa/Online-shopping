import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  final pages = [
    {'emoji':'🌿','title':'Farm Fresh\nEvery Day','sub':'Locally sourced fruits, vegetables\nand groceries delivered to your door.','color1':0xFF1B5E20,'color2':0xFF43A047},
    {'emoji':'🚚','title':'Fast & Free\nDelivery','sub':'Orders above TZS 20,000 get free delivery.\nFresh in 2-4 hours.','color1':0xFF0D47A1,'color2':0xFF1976D2},
    {'emoji':'💳','title':'Easy\nPayments','sub':'Pay with M-Pesa, Airtel Money,\nor cash on delivery. Simple!','color1':0xFFE65100,'color2':0xFFFF6D00},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(children: [
      PageView.builder(
        controller: _ctrl,
        onPageChanged: (i) => setState(() => _page = i),
        itemCount: pages.length,
        itemBuilder: (_, i) {
          final p = pages[i];
          return Container(
            decoration: BoxDecoration(gradient: LinearGradient(
              colors: [Color(p['color1'] as int), Color(p['color2'] as int)],
              begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: SafeArea(child: Padding(padding: const EdgeInsets.all(40),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(p['emoji'] as String, style: const TextStyle(fontSize: 100)),
                const SizedBox(height: 40),
                Text(p['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700, height: 1.2), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text(p['sub'] as String, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, height: 1.5), textAlign: TextAlign.center),
              ]))));
        }),
      Positioned(bottom: 60, left: 40, right: 40, child: Column(children: [
        SmoothPageIndicator(controller: _ctrl, count: pages.length,
          effect: const WormEffect(activeDotColor: Colors.white, dotColor: Colors.white38, dotHeight: 8, dotWidth: 8)),
        const SizedBox(height: 32),
        if (_page < pages.length - 1)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(onPressed: () => context.go('/login'), child: const Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 16))),
            ElevatedButton(
              onPressed: () => _ctrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4), child: Text('Next', style: TextStyle(fontWeight: FontWeight.w700)))),
          ])
        else
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text("Let's Shop! 🛒", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16))))),
      ])),
    ]));
}