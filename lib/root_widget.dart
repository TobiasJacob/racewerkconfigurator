import 'dart:async';

import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/apps/app_loading.dart';
import 'package:racewerkconfigurator/data/settings_provider.dart';
import 'package:racewerkconfigurator/pages/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'apps/app_data.dart';
import 'apps/app_error.dart';

class GCRRootWidget extends ConsumerStatefulWidget {
  const GCRRootWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GCRRootWidgetState();
}

class GCRRootWidgetState extends ConsumerState<GCRRootWidget> {
  late Future loadFuture;

  @override
  void initState() {
    super.initState();
    loadFuture = ref.read(settingsProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppLoading();
          }
          if (snapshot.hasError) {
            return AppError(
              errorMsg: snapshot.error.toString(),
              onResetToFactory: () async {
                await ref.read(settingsProvider.notifier).resetToFactory();
                setState(() {
                  loadFuture = ref.read(settingsProvider.notifier).load();
                });
              },
            );
          }
          return const AppData(home: HomePage());
        });
  }
}
