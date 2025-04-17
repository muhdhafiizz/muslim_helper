import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/providers/bottom_navbar_provier.dart';
import 'package:hadith_reader/providers/masjid_details_provider.dart';
import 'package:hadith_reader/providers/qibla_finder_provider.dart';
import 'package:hadith_reader/providers/search_provider.dart';
import 'package:hadith_reader/providers/zakat/fidyah_provider.dart';
import 'package:hadith_reader/providers/zakat/zakat_kwsp_provider.dart';
import 'package:hadith_reader/providers/zakat/zakat_saham_provider.dart';
import 'package:hadith_reader/providers/zakat/zakat_simpanan_provider.dart';
import 'package:hadith_reader/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/home_provider.dart';
import 'providers/profile_provider.dart';
import 'screen/login_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ChangeNotifierProvider(create: (_) => HadithProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => MasjidProvider()),
      ChangeNotifierProvider(create: (_) => QiblaProvider()),
      ChangeNotifierProvider(create: (_) => FidyahProvider()),
      ChangeNotifierProvider(create: (_) => ZakatKwspProvider()),
      ChangeNotifierProvider(create: (_) => ZakatSimpananProvider()),
      ChangeNotifierProvider(create: (_) => ZakatSahamProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'FunnelDisplay',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return BottomNavView();
        }
        return const LoginPage();
      },
    );
  }
}
