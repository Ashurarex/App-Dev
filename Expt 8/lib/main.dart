import 'package:flutter/material.dart';

// The main function is the entry point for all Flutter apps.
void main() {
  runApp(const MyApp());
}

// MyApp is the root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The title of the application.
      title: 'Simple App Demo',
      // The theme of the application.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // The home screen of the application.
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// HomePage is the main screen which contains both the drawer and tab navigation.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController is used to coordinate the TabBar and TabBarView.
    return DefaultTabController(
      length: 3, // The number of tabs.
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Simple App'),
          // The bottom property of the AppBar is used to place the TabBar.
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.explore), text: 'Explore'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        // The drawer is the slide-out navigation panel.
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              // The DrawerHeader provides a nice header for the drawer.
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'App Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              // ListTile widgets are used for the navigation items in the drawer.
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Close the drawer when an item is tapped.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help'),
                onTap: () {
                  // Close the drawer when an item is tapped.
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        // The body of the Scaffold contains the content for the tabs.
        body: const TabBarView(
          children: [
            // Each child in the TabBarView corresponds to a Tab in the TabBar.
            Center(
              child: Text(
                'Content for Home Tab',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Center(
              child: Text(
                'Content for Explore Tab',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Center(
              child: Text(
                'Content for Profile Tab',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

