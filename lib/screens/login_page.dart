import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/blocs/login/bloc/login_bloc.dart';
import 'package:mobilepacking/blocs/login/form_submission_status.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/screens/config/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  _LoginPagexState createState() => _LoginPagexState();
}

class _LoginPagexState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool sec = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSncakBar(context, formStatus.exception.toString());
        } else if (state.formStatus is SubmissionSuccess) {
          // Navigator.of(context)          //     .pushReplacement(MaterialPageRoute(builder: (_) => Mainmenu()));

          var successLogin = state.formStatus as SubmissionSuccess;
          context.read<AuthenticationBloc>().add(AuthenticationStatusChanged(
              status: AuthenticationStatus.authenticated,
              token: successLogin.token,
              user: successLogin.user));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromRGBO(93, 224, 240, 1),
              Color.fromRGBO(119, 214, 241, 1),
              Color.fromRGBO(144, 205, 242, 1),
              Color.fromRGBO(170, 195, 243, 1),
              Color.fromRGBO(196, 185, 243, 1),
              Color.fromRGBO(221, 176, 244, 1),
              Color.fromRGBO(247, 166, 245, 1),
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _loginForm(context),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 6,
            vertical: MediaQuery.of(context).size.height / 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _configButton(context),
            Text(
              'Mobile Packing',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors.white),
            ),
            SizedBox(
              height: 65,
            ),
            _usernameField(),
            SizedBox(
              height: 10,
            ),
            _passwordField(),
            SizedBox(
              height: 30,
            ),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Color(0xffebefff),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                )
              ]),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.person,
                  color: Color(0xff4c5166),
                ),
                hintText: 'Username',
                hintStyle: TextStyle(color: Colors.black38)),
            validator: (value) =>
                state.isValidUsername ? null : 'Username is too short',
            onChanged: (value) => context.read<LoginBloc>().add(
                  LoginUsernameChanged(username: value),
                ),
          ),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Color(0xffebefff),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                )
              ]),
          child: TextFormField(
            obscureText: sec,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.security,
                  color: Color(0xff4c5166),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black38)),
            validator: (value) =>
                state.isValidPassword ? null : 'Password is too short',
            onChanged: (value) => context.read<LoginBloc>().add(
                  LoginPasswordChanged(password: value),
                ),
          ),
        );
      },
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(LoginSubmitted());
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _configButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(ConfigPage.route());
        },
      ),
    );
  }

  void _showSncakBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
