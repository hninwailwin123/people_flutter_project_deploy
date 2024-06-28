import 'package:flutter/material.dart';
import 'package:people_frontend/screens/login_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:people_frontend/screens/register.dart';
import 'package:url_strategy/url_strategy.dart';
void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
      // title: 'Flutter Demo', home: LoginPage());
  }
}
final GoRouter _router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: '/emailSend',
    builder: (context, state) {
       final email = state.queryParams['email'];
       final name = state.queryParams['name'];
      return RegistrationPage(
        email: email,
        name: name,
      );
    },
  ),
]);