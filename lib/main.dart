import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';
import 'models/student.dart';
import 'screens/portal_selector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: LCColors.bg,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const LifeCycleApp());
}

class LifeCycleApp extends StatelessWidget {
  const LifeCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Life Cycle',
        theme: LCTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const PortalSelector(),
      ),
    );
  }
}
