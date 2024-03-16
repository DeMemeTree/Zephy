import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'src/splash/splash.dart';
import 'src/wallet/wallet.dart';
import 'src/wallet/unlock.dart';
import 'src/wallet/create.dart';
import 'src/wallet/home/home.dart';
import 'src/wallet/home/receive/receive.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        }),
    GoRoute(
        path: '/wallet',
        builder: (BuildContext context, GoRouterState state) {
          return const WalletScreen();
        },
        routes: <RouteBase>[
          GoRoute(
              path: 'unlock',
              builder: (BuildContext context, GoRouterState state) {
                return const UnlockScreen();
              }),
          GoRoute(
              path: 'create',
              builder: (BuildContext context, GoRouterState state) {
                return const CreateScreen();
              }),
          GoRoute(
              path: 'restore',
              builder: (BuildContext context, GoRouterState state) {
                return const Text("restore wallet");
              })
        ]),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'settings',
            builder: (BuildContext context, GoRouterState state) {
              return const DetailsScreen();
            }),
        GoRoute(
            path: 'send',
            builder: (BuildContext context, GoRouterState state) {
              return const DetailsScreen();
            }),
        GoRoute(
            path: 'receive',
            builder: (BuildContext context, GoRouterState state) {
              return const ReceiveView();
            }),
      ],
    ),
  ],
);

class Zephii extends StatelessWidget {
  const Zephii({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}

void main() => runApp(const Zephii());
