import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'dart:async';

import 'package:mobilepacking/screens/main_menu.dart';

class SplashPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    AuthenticationState authenticationStatus =
        context.read<AuthenticationBloc>().state;
    if (authenticationStatus.status == AuthenticationStatus.authenticated) {
      Timer(
          Duration(seconds: 1),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Mainmenu())));
    } else if (authenticationStatus.status ==
        AuthenticationStatus.refreshauthenticated) {
      Timer(
          Duration(seconds: 3),
          () => context.read<AuthenticationBloc>().add(
              AuthenticationStatusChanged(
                  status: AuthenticationStatus.authenticated,
                  token: authenticationStatus.token,
                  user: null)));
    } else {
      Timer(
          Duration(seconds: 3),
          () => context.read<AuthenticationBloc>().add(
              AuthenticationStatusChanged(
                  status: AuthenticationStatus.unknown)));
    }
    // else {
    //   Timer(
    //       Duration(seconds: 1),
    //       () => Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (context) => LoginPage())));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
