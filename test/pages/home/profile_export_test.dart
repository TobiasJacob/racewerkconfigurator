// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:racewerkconfigurator/apps/app_data.dart';
// import 'package:racewerkconfigurator/i18n/app_localization_delegate.dart';
// import 'package:racewerkconfigurator/i18n/langs/language_de.dart';
// import 'package:racewerkconfigurator/i18n/langs/language_en.dart';
// import 'package:racewerkconfigurator/i18n/languages.dart';
// import 'package:racewerkconfigurator/main_data_provider_widget.dart';
// import 'package:racewerkconfigurator/main_data_provider.dart';
// import 'package:racewerkconfigurator/pages/home/profile_tile.dart';
// import 'package:racewerkconfigurator/pages/profile_page.dart';
// import 'package:racewerkconfigurator/pages/settings_page.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';

// void main() {
//   testWidgets('App saving', (WidgetTester tester) async {
//     final mainDataProvier = MainDataProvider();

//     final widget = MainDataProviderWidget(
//         mainDataProvier: mainDataProvier,
//         child: MyApp(
//             home: Scaffold(
//           body: ProfileTile(
//             profile: mainDataProvier.database.profiles.entries.first.value,
//             profileKey: mainDataProvier.database.profiles.entries.first.key,
//           ),
//         )));

//     await tester.pumpWidget(widget);
//     await tester.pumpAndSettle();
//     print("ProfileTile size: ${tester.getSize(find.byType(ProfileTile))}");

//     await tester.tap(find.byType(PopupMenuButton<String>));
//     await tester.pumpAndSettle();
//     await tester.tap(find.text('Export'));

//     const MethodChannel channel =
//     MethodChannel('package:file_picker/file_picker.dart');
    

//     final tempDir = await getTemporaryDirectory();
//     final tempPath = "${tempDir.path}/testprofile.json";
//     final file = File(tempPath);
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return file.path;
//     });
//     await tester.pumpAndSettle();
//     // assert(file.existsSync());

//     // expect(find.byType(ProfilePage), findsNothing);
//     // debugDumpApp();
//     // await tester.tap(find.byIcon(Icons.add));
//     // await tester.pumpAndSettle();
//     // expect(find.byType(ProfilePage), findsOneWidget);
//   });
// }
