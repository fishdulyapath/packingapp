import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/screens/config/cubit/config_cubit.dart';
import 'package:mobilepacking/screens/config/view/config_form.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (context) => ConfigPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(171, 167, 242, 1),
        title: Text('Service Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
          child: BlocProvider(
            create: (context) => ConfigCubit(),
            child: const ConfigForm(),
          ),
        ),
      ),
    );
  }
}
