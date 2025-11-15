import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'constants/app_theme.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/premium_service.dart';
import 'services/reminder_service.dart';
import 'services/profile_prefs_service.dart';
import 'services/notification_service.dart';
import 'routes.dart';
import 'utils/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with options from firebase_options.dart
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully!');
  } catch (e) {
    // Firebase initialization failed
    debugPrint('❌ Firebase initialization failed: $e');
    debugPrint('');
    debugPrint('Please check your Firebase configuration.');
    debugPrint('');
    // Continue anyway - app will show login screen but auth won't work
  }

  final themeProvider = ThemeProvider();
  final premiumService = PremiumService();
  final profilePrefsService = ProfilePrefsService();

  await themeProvider.load();
  // Wait for profile prefs to initialize
  await profilePrefsService.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: premiumService),
        ChangeNotifierProvider.value(value: profilePrefsService),
        ChangeNotifierProvider(create: (_) => ReminderService()),
        Provider(create: (_) => NotificationService()),
      ],
      child: const HabitualApp(),
    ),
  );
}

class HabitualApp extends StatelessWidget {
  const HabitualApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Habitual',
          theme: AppTheme.lightTheme.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: AppTheme.darkTheme.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode: themeProv.isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: Routes.splash,
          routes: Routes.map,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
