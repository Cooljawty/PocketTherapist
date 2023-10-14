import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
              // This is how you get colors from the theme
              color: Theme.of(context).colorScheme.background,
              width: 3.0,
            )),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/logo.png', scale: 4),
          const SizedBox(height: 20.0),
          Text(
            'Pocket Therapist is loading',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20.0),
          const CircularProgressIndicator(color: Colors.amber),
          const SizedBox(height: 50.0),
        ]),
      ),
    );
  }
}
