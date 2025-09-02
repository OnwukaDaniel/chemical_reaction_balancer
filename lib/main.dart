import 'package:chemical_reaction_balancer/imports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with Strings, AppColors {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      home: SplashScreen(),
    );
  }
}
