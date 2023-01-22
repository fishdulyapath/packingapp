import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/screens/config/cubit/config_cubit.dart';
import 'package:mobilepacking/screens/login_page.dart';

class ConfigForm extends StatefulWidget {
  const ConfigForm({Key? key}) : super(key: key);

  @override
  _ConfigFormState createState() => _ConfigFormState();
}

class _ConfigFormState extends State<ConfigForm> {
  @override
  void initState() {
    context.read<ConfigCubit>().loadConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _headerLabel("Server Config"),
        HoServiceUrlInput(),
        HoProviderNameInput(),
        HoDatabaseNameInput(),
        SizedBox(
          height: 15.0,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ConfigCubit>().saveConfig();
            _showSncakBar(context, 'saved');

            Navigator.of(context).push(LoginPage.route());
          },
          child: Text('Save'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     final box = GetStorage('AppConfig');
        //     box.erase();
        //     // print(box.read('hoServiceUrl').toString());
        //   },
        //   child: Text("Clear"),
        // )
      ],
    );
  }

  Widget _headerLabel(String textLabel) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        child: Text(
          textLabel,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  void _showSncakBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class HoServiceUrlInput extends StatelessWidget {
  const HoServiceUrlInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      buildWhen: (previous, current) =>
          previous.hoServiceUrl != current.hoServiceUrl,
      builder: (context, state) {
        return TextFormField(
          key: const Key('configForm_hoServiceUrl_textField'),
          initialValue: state.hoServiceUrl.value,
          onChanged: (serviceUrl) =>
              context.read<ConfigCubit>().hoServiceUrlChanged(serviceUrl),
          decoration: InputDecoration(
            labelText: 'Service Url',
            helperText: '',
            errorText:
                state.hoServiceUrl.invalid ? 'invalid Service Url' : null,
          ),
        );
      },
    );
  }
}

class HoProviderNameInput extends StatelessWidget {
  const HoProviderNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      buildWhen: (previous, current) =>
          previous.hoProviderName != current.hoProviderName,
      builder: (context, state) {
        return TextFormField(
          key: const Key('configForm_hoProviderName_textField'),
          initialValue: state.hoProviderName.value,
          onChanged: (providerName) =>
              context.read<ConfigCubit>().hoProviderNameChanged(providerName),
          decoration: InputDecoration(
            labelText: 'Provider Name',
            helperText: '',
            errorText: state.hoProviderName.value == ''
                ? 'invalid Provider Name'
                : null,
          ),
        );
      },
    );
  }
}

class HoDatabaseNameInput extends StatelessWidget {
  const HoDatabaseNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      buildWhen: (previous, current) =>
          previous.hoProviderName != current.hoProviderName,
      builder: (context, state) {
        return TextFormField(
          key: const Key('configForm_hoDatabaseName_textField'),
          initialValue: state.hoDatabaseName.value,
          onChanged: (databaseName) =>
              context.read<ConfigCubit>().hoDatabaseNameChanged(databaseName),
          decoration: InputDecoration(
            labelText: 'Database Name',
            helperText: '',
            errorText: state.hoDatabaseName.value == ''
                ? 'invalid Database Name'
                : null,
          ),
        );
      },
    );
  }
}
