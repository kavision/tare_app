import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tare_app/providers/tare_range.dart';
import 'package:tare_app/screens/tare_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    fullScreen: false,
    skipTaskbar: false,
    size: Size(1024, 768),
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Tare App';

    return ListenableProvider(
      create: (_) => TareRangeProvider(),
      child: MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: const TarePage(),
        ),
      ),
    );
  }
}
