// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';

// class FadeAnimation extends StatelessWidget {
//   final double delay;
//   final Widget child;

//   FadeAnimation(this.delay, this.child);

//   @override
//   Widget build(BuildContext context) {
//     var tween = MovieTween()
//       ..scene(duration: const Duration(milliseconds: 700))
//           .tween('x', Tween<double>(begin: 0.0, end: 100.0))
//           .tween('y', Tween<double>(begin: 0.0, end: 200.0));

//     return PlayAnimationBuilder<Movie>(
//       tween: tween, // provide tween
//       duration: tween.duration, // total duration obtained from MovieTween
//       builder: (context, value, _) {
//         return Container(
//           width: value.get('width'), // get animated width value
//           height: value.get('height'), // get animated height value
//           color: Colors.yellow,
//         );
//       },
//     );
//   }
// }
