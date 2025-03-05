// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:racewerkconfigurator/apps/app_data.dart';
// import 'package:racewerkconfigurator/main_data_provider_widget.dart';
// // import 'package:racewerkconfigurator/apps/app_loading.dart';
// import 'package:racewerkconfigurator/main_data_provider.dart';
// import 'package:racewerkconfigurator/pages/home_page.dart';
// import 'package:racewerkconfigurator/pages/profile_page.dart';
// import 'package:racewerkconfigurator/pages/settings_page.dart';

// // import 'package:racewerkconfigurator/root_widget.dart';

// void main() {
//   // testWidgets('Initial screen is loading screen', (WidgetTester tester) async {
//   //   // Build our app and trigger a frame.
//   //   const app = GCRRootWidget();
//   //   await tester.pumpWidget(app);
//   //   expect(find.byType(AppLoading), findsOneWidget);
//   // });
//   testWidgets('Loaded Screen is App Screen', (WidgetTester tester) async {
//     final mainDataProvier = MainDataProvider();

//     final app = MainDataProviderWidget(mainDataProvier: mainDataProvier, child: MyApp(home: const HomePage()),);

//     await tester.pumpWidget(app);
//     expect(find.byType(MyApp), findsOneWidget);
//     expect(find.byType(SettingsPage), findsNothing);

//     // expect(find.byType(ProfilePage), findsNothing);
//     // debugDumpApp();
//     // await tester.tap(find.byIcon(Icons.add));
//     // await tester.pumpAndSettle();
//     // expect(find.byType(ProfilePage), findsOneWidget);
//   });
// }
