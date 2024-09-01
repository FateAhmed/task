import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_task/provider/AuthManager.dart';
import 'package:hiring_task/provider/DashboardStateProvider.dart';
import 'package:hiring_task/router/RouteConstants.dart';
import 'package:hiring_task/views/Dashboard/Dashboard.dart';
import 'package:hiring_task/views/Events/CreateEvent.dart';
import 'package:hiring_task/views/Login/Login.dart';
import 'package:hiring_task/views/SignUp/SignUp.dart';
import 'package:hiring_task/views/splash/Splash.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

Logger logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

AuthManager refreshListenable = AuthManager();

class AppRouter {
  AppRouter();
  static GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: RouteConstants.splashPath,
        name: RouteConstants.splashPath,
        builder: (context, state) {
          return const Splash();
        },
      ),
      GoRoute(
        path: RouteConstants.loginPath,
        name: RouteConstants.loginPath,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: RouteConstants.signupPath,
        name: RouteConstants.signupPath,
        builder: (context, state) {
          return const SignUp();
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return dashboardAppState(child: child);
        },
        routes: [
          GoRoute(
            path: RouteConstants.dashboardPath,
            name: RouteConstants.dashboardPath,
            builder: (context, state) {
              return const DashboardScreen();
            },
            routes: [
              GoRoute(
                path: RouteConstants.createEvent,
                name: RouteConstants.createEvent,
                builder: (context, state) {
                  return const CreateEventScreen();
                },
              ),
              GoRoute(
                path: RouteConstants.eventDetails,
                name: RouteConstants.eventDetails,
                builder: (context, state) {
                  return Container();
                },
              ),
            ],
          ),
        ],
      ),
    ],
    refreshListenable: refreshListenable,
    redirect: (context, state) async {
      AuthManager auth = Provider.of<AuthManager>(context, listen: false);
      Status authStatus = auth.loggedInStatus;
      String requestedPath = state.matchedLocation;
      logger.i('Current path : ${auth.currentPage}\n Auth : ${auth.loggedInStatus}');

      if (authStatus == Status.notLoggedIn && (requestedPath != RouteConstants.signupPath)) {
        auth.currentPage = RouteConstants.loginPath;
        return RouteConstants.loginPath;
      }

      if (authStatus == Status.loggedIn) {
        if (requestedPath == RouteConstants.loginPath || requestedPath == RouteConstants.splashPath) {
          auth.currentPage = RouteConstants.dashboardPath;
          return RouteConstants.dashboardPath;
        }

        if (requestedPath != auth.currentPage) {
          logger.i('SHOULD GO TO : $requestedPath');
          auth.currentPage = requestedPath;
          return state.matchedLocation;
        }
        logger.i('REQUESTED PATH : ${state.matchedLocation}\n SAME PATH RETURNING NULL');
        auth.currentPage = state.matchedLocation;
      }
      return null;
    },
  );
}
