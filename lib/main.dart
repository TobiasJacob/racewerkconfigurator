import 'dart:io';

import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/root_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Racewerk Configurator');
    setWindowMinSize(const Size(1280, 720));
  }

  runApp(const ProviderScope(child: GCRRootWidget()));
}
