import 'package:app/pages/entries.dart';
import 'package:app/pages/loading.dart';
import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => DashboardPage());
  }

  const DashboardPage({super.key });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const Text('Dashboard'),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pushReplacement(EntriesPage.route());
                  }, child: const Text('nextPageEntries') )
                ],
              ),
            )
        );
  }
}
