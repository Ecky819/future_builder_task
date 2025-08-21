import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _zipController = TextEditingController();

  Future<String>? _cityFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 60, 8, 8),
        child: Center(
          child: Column(
            spacing: 60,
            children: [
              TextFormField(
                controller: _zipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Postleitzahl",
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Suche starten
                  final zip = _zipController.text.trim();
                  if (zip.isNotEmpty) {
                    setState(() {
                      _cityFuture = getCityFromZip(zip);
                    });
                  }
                },
                child: const Text("Suche"),
              ),

              FutureBuilder<String>(
                future: _cityFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text(
                          'Suche Stadt...',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      'Fehler: ${snapshot.error}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.red,
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    return Text(
                      'Ergebnis: ${snapshot.data}',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  }

                  return Text(
                    "Ergebnis: Noch keine PLZ gesucht",
                    style: Theme.of(context).textTheme.labelLarge,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _zipController.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "23611":
        return 'Bad Schwartau';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }
}
