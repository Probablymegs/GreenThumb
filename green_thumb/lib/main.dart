import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_thumb/pages/plant_profile.dart';
import 'package:green_thumb/pages/plant_watering_page.dart';
import 'package:green_thumb/pages/register_page.dart';
import 'package:green_thumb/pages/search_plants.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:green_thumb/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(MainApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: Root(),
      theme: PlantTheme.theme,
    );
  }
}

class Root extends StatefulWidget {
  @override
  State<Root> createState() => RootState();
}

class RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            return PopupMenuButton<int>(
              icon: const Icon(Icons.menu),
              itemBuilder: (BuildContext context) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  return [
                    const PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Text('Sign Out'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: ListTile(
                        title: Text('Search Plants'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 5,
                      child: ListTile(
                        title: Text('Virtual Garden'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 6,
                      child: ListTile(
                        title: Text('Watering Schedule'),
                      ),
                    ),
                  ];
                } else {
                  return [
                    const PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        title: Text('Sign In'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: ListTile(
                        title: Text('Register'),
                      ),
                    ),
                  ];
                }
              },
              onSelected: (value) {
                if (value == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                } else if (value == 1) {
                  _auth.signOut();
                } else if (value == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                } else if (value == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                } else if (value == 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantProfile(),
                    ),
                  );
                } else if (value == 6) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantWateringPage(),
                    ),
                  );
                }
              },
            );
          },
        ),
        title: const Text('GreenThumb'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Welcome to GreenThumb!'),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/greenthumb.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.emoji_nature_rounded,
                          color: Color.fromARGB(255, 49, 113, 82)),
                      label: const Text('Explore Your Garden Today'),
                      onPressed: () async {
                        // Check if the user is signed in
                        var user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlantProfile()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
