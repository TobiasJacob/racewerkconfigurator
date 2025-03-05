import 'dart:math';

import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/i18n/languages.dart';
import 'package:racewerkconfigurator/pages/home/channel_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home/update_device_button.dart';
import 'settings_page.dart';

enum ProfileAction { addEmptyProfile, importProfile }

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(lang.appName),
          // titleTextStyle:
          // const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          actions: <Widget>[
            const UpdateDeviceWidget(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(24, 24, 24, 1),
              image: DecorationImage(
                  image: AssetImage('images/background.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft),
            ),
            padding: EdgeInsets.fromLTRB(
                max(0.12 * MediaQuery.of(context).size.width,
                    0.2 * MediaQuery.of(context).size.height),
                10,
                10,
                10),
            child: const ChannelList()));
  }
}
