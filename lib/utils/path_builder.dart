import 'dart:developer';

import 'package:path/path.dart' as path;
import 'package:path_provider_windows/path_provider_windows.dart';

Future<String> getTareRangePath() async {
  final pathProvider = PathProviderWindows();
  final String sysPath = await pathProvider.getApplicationDocumentsPath() ?? '';
  try {
    final join = path.join(sysPath, 'KavisionTare', 'tare.json');
    return path.absolute(join);
  } catch (e) {
    log("Path Builder exception: ${e.toString()}");
    rethrow;
  }
}
