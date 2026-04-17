import 'package:flutter/material.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var fade = Tween(begin: 0.0, end: 1.0).animate(animation);
      var slide = Tween(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}