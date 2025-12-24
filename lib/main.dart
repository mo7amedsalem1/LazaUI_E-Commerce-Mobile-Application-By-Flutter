import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/main_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
  } catch (e) {
    print("Firebase init failed: $e. Switching to Mock Mode.");
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (ctx) =>
              CartProvider(Provider.of<AuthProvider>(ctx, listen: false)),
          update: (ctx, auth, previous) => CartProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, WishlistProvider>(
          create: (ctx) =>
              WishlistProvider(Provider.of<AuthProvider>(ctx, listen: false)),
          update: (ctx, auth, previous) => WishlistProvider(auth),
        ),
      ],
      child: MaterialApp(
        title: 'Laza',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Colors
          scaffoldBackgroundColor: const Color(0xFFFEFEFE),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF9775FA),
            primary: const Color(0xFF9775FA),
            secondary: const Color(0xFF1D1E20),
            surface: const Color(0xFFF5F6FA),
          ),

          // Typography - Poppins (Laza UI Kit Standard)
          textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(
              displayLarge: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1E20),
              ),
              titleLarge: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1E20),
              ),
              bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1D1E20)),
              bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF8F959E)),
            ),
          ),

          // Component Themes
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFF1D1E20)),
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D1E20),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9775FA),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF8F959E),
              fontSize: 14,
            ),
          ),

          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // If authenticated, go to MainScreen
    if (authProvider.isAuthenticated) {
      return const MainScreen();
    }

    // If not authenticated, check if onboarding was shown
    return FutureBuilder<bool>(
      future: _hasSeenOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hasSeenOnboarding = snapshot.data ?? false;
        if (hasSeenOnboarding) {
          return const LoginScreen();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }

  Future<bool> _hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }
}
