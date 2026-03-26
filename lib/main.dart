import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/services/notification_service.dart';
import 'data/repositories/quiz_repository.dart';
import 'domain/repositories/i_quiz_repository.dart';
import 'data/services/json_service.dart';
import 'data/services/shared_prefs_service.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/core/widgets/error_info_view.dart';
import 'ui/features/home/view_model/quiz_view_model.dart';
import 'ui/features/home/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.init();


  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>.value(value: notificationService),
        Provider(create: (_) => JsonService()),
        Provider(create: (_) => SharedPrefsService()),
        ProxyProvider2<JsonService, SharedPrefsService, IQuizRepository>(
          update: (_, json, prefs, __) => QuizRepository(
            jsonService: json,
            prefsService: prefs,
          ),
        ),
        ChangeNotifierProxyProvider<IQuizRepository, QuizViewModel>(
          create: (context) => QuizViewModel(
            repository: context.read<IQuizRepository>(),
          ),
          update: (_, repo, previous) => previous ?? QuizViewModel(repository: repo),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notificationService = context.read<NotificationService>();
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      notificationService.agendarVoltaApp();
    } else if (state == AppLifecycleState.resumed) {
      notificationService.cancelarTodasNotificacoes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp(
        title: 'Dev Quiz Fix',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeScreen(),
        builder: (context, child) {
          ErrorWidget.builder = (FlutterErrorDetails details) => ErrorInfoView(
            errorMessage: details.exception.toString(),
            onRetry: () {
            },
          );
          return child!;
        },
      ),
    );
  }
}
