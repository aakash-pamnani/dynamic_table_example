import 'package:dynamic_table_example/autocomplete_input_example.dart';
import 'package:dynamic_table_example/editable_table.dart';
import 'package:dynamic_table_example/sortable_table_custom_actions.dart';
import 'package:dynamic_table_example/styling.dart';
import 'package:dynamic_table_example/using_methods.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'non_editable_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentTable = 0;
  final List<Widget> _tables = [
    const NonEditableTable(),
    const EditableTable(),
    const UsingMethods(),
    const SortableTable(),
    const StylingTable(),
    const AutocompleteEample(),
  ];
  final List<String> titles = [
    "Non Editable Table",
    "Editable Table",
    "Using Methods",
    "Sortable Table",
    "Styling Table",
    "Auto Complete Input"
  ];
  final List<String> urls = [
    "https://github.com/aakash-pamnani/dynamic_table_example/tree/master/lib/non_editable_table.dart",
    "https://github.com/aakash-pamnani/dynamic_table_example/tree/master/lib/editable_table.dart",
    "https://github.com/aakash-pamnani/dynamic_table_example/tree/master/lib/using_methods.dart",
    "https://github.com/aakash-pamnani/dynamic_table_example/tree/master/lib/sortable_table_custom_actions.dart",
    "https://github.com/aakash-pamnani/dynamic_table_example/tree/master/lib/styling.dart",
    "https://github.com/aakash-pamnani/dynamic_table_example/tree/master/lib/autocomplete_input_example.dart",
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        bool isDesktop = MediaQuery.of(context).size.width > 800;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Dynamic Table Example (0.0.1-beta.1)"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  canLaunchUrl(
                          Uri.parse("https://pub.dev/packages/dynamic_table"))
                      .then(
                    (value) => launchUrl(
                      Uri.parse("https://pub.dev/packages/dynamic_table"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Image.asset(
                  "assets/pub-dev-logo.png",
                  width: 100,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  canLaunchUrl(Uri.parse(
                          "https://github.com/aakash-pamnani/dynamic_table/"))
                      .then(
                    (value) => launchUrl(
                      Uri.parse(
                          "https://github.com/aakash-pamnani/dynamic_table/"),
                    ),
                  );
                },
                icon: Image.asset("assets/github.png"),
                label: const Text("Github"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.code),
            onPressed: () async {
              await canLaunchUrl(Uri.parse(urls[_currentTable])).then((value) {
                if (value) launchUrl(Uri.parse(urls[_currentTable]));
              });
            },
          ),
          bottomNavigationBar: isDesktop
              ? null
              : BottomNavigationBar(
                  currentIndex: _currentTable,
                  onTap: (index) {
                    setState(() {
                      _currentTable = index;
                    });
                  },
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.table_rows_rounded),
                        label: "Non Editable Table"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.edit), label: "Editable Table"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.code), label: "Using Methods"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.sort), label: "Sortable Table"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.color_lens), label: "Styling Table"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.auto_mode),
                        label: "Auto Complete Input"),
                  ],
                ),
          body: Row(
            children: [
              if (isDesktop)
                NavigationRail(
                  extended: true,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.table_rows_rounded),
                      label: Text("Non Editable Table"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit),
                      label: Text("Editable Table"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.code),
                      label: Text("Using Methods"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.sort),
                      label: Text("Sortable Table"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.color_lens),
                      label: Text("Styling Table"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_mode),
                      label: Text("Auto Complete Input"),
                    ),
                  ],
                  selectedIndex: _currentTable,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentTable = index;
                    });
                  },
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: _tables[_currentTable],
                ),
              ),
            ],
          ),
        );
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}
