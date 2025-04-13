import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/activity_provider.dart';
import 'package:rm_veriphy/providers/auth_provider.dart';
import 'package:rm_veriphy/providers/chat_provider.dart';
import 'package:rm_veriphy/providers/customer_provider.dart';
import 'package:rm_veriphy/providers/dashboard_provider.dart';
import 'package:rm_veriphy/providers/document_provider.dart';
import 'package:rm_veriphy/providers/notifications_provider.dart';
import 'package:rm_veriphy/providers/product_provider.dart';
import 'package:rm_veriphy/providers/profile_provider.dart';
import 'package:rm_veriphy/providers/stage_provider.dart';
import 'package:rm_veriphy/providers/task_provider.dart';
import 'package:rm_veriphy/providers/theme_provider.dart';
// import 'package:rm_veriphy/screens/login_screen.dart';
import 'package:rm_veriphy/screens/network_screen.dart';
import 'package:rm_veriphy/screens/splash_screen.dart';
import 'package:rm_veriphy/services/activity_service.dart';
import 'package:rm_veriphy/services/api_service.dart';
import 'package:rm_veriphy/services/chat_service.dart';
import 'package:rm_veriphy/services/customer_process_service.dart';
import 'package:rm_veriphy/services/document_service.dart';
import 'package:rm_veriphy/services/notification_service.dart';
import 'package:rm_veriphy/services/product_service.dart';
import 'package:rm_veriphy/services/stage_service.dart';
import 'package:rm_veriphy/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();

  runApp(
    MyApp(
      apiService: apiService,
      prefs: prefs,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final SharedPreferences prefs;

  const MyApp({
    super.key,
    required this.apiService,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: apiService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
        Provider(
          create: (_) => CustomerProcessService(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerProvider(
            apiService,
            context.read<CustomerProcessService>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => DocumentProvider(apiService)),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(apiService),
        ),
        Provider(
          create: (_) => TaskService(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(context.read<TaskService>()),
        ),
        Provider(
          create: (_) => StageService(),
        ),
        ChangeNotifierProvider(
          create: (context) => StageProvider(context.read<StageService>()),
        ),
        Provider(
          create: (_) => NotificationService(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NotificationsProvider(context.read<NotificationService>()),
        ),
        Provider(
          create: (_) => DocumentService(),
        ),
        Provider(
          create: (_) => ChatService(),
        ),
        ChangeNotifierProxyProvider<ChatService, ChatProvider>(
          create: (context) => ChatProvider(context.read<ChatService>()),
          update: (context, chatService, previous) =>
              previous ?? ChatProvider(chatService),
        ),
        Provider(
          create: (_) => ProductService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            context.read<ProductService>(),
          ),
        ),
        Provider(
          create: (_) => ActivityService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ActivityProvider(
            context.read<ActivityService>(),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Veriphy',
            theme: themeProvider.theme,
            locale: themeProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('hi', ''), // Hindi
            ],
            // home: Consumer<AuthProvider>(
            //   builder: (context, authProvider, _) {
            //     return const LoginScreen();
            //   },
            home: const NetworkScreen(
              child: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
