import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lingodash/providers/auth_service.dart';
import 'package:lingodash/screens/language_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('language') ?? 'en';

  runApp(MyApp(languageCode: languageCode));
}

class MyApp extends StatelessWidget {
  final String languageCode;

  const MyApp({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'LingoDash',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('es'),
          Locale('ms'),
          Locale('de'),
          Locale('zh'),
          Locale('ja'),
          Locale('hi'),
          Locale('id'),
          Locale('bn'),
          Locale('fr'),
          Locale('pt'),
          Locale('ru'),
          Locale('ko'),
          Locale('tr'),
        ],
        locale: Locale(languageCode),
        initialRoute: '/register',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/language-selection': (context) => const LanguageSelectionScreen(),
        },
      ),
    );
  }
}
