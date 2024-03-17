import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zephii/src/wallet/home/settings/settings.dart';
import 'package:zephii/src/wallet/restore/restore.dart';
import 'src/splash/splash.dart';
import 'src/wallet/wallet.dart';
import 'src/wallet/unlock.dart';
import 'src/wallet/create.dart';
import 'src/wallet/home/home.dart';
import 'src/wallet/home/receive/receive.dart';
import 'src/wallet/home/send/send.dart';

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
                return const RestoreScreen();
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
              return const SettingsView();
            }),
        GoRoute(
            path: 'send',
            builder: (BuildContext context, GoRouterState state) {
              return const SendView();
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

void main() => runApp(const Zephii());
