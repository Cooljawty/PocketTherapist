import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';

class PlansPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => PlansPage());
  }
  const PlansPage({super.key });

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Text('Plans'),
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushReplacement(SettingsPage.route());
              }, child: const Text('nextPageSettings') )
            ],
          ),
        )
    );
  }
}
