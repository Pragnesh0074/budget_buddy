import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/new_transaction.dart';
import './models/transaction.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Transactions(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Budget Buddy',
          theme: ThemeData(
            primaryColor: Colors.amber,
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amberAccent),
            fontFamily: 'Quicksand',
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                fontSize: 16,
              ),
              labelLarge: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            NewTransaction.routeName: (_) => NewTransaction(),
          },
        );
      },
    );
  }
}