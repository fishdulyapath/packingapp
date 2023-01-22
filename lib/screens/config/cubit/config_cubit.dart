import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobilepacking/app_const.dart';
import 'package:mobilepacking/screens/config/form_inputs/database_name.dart';
import 'package:mobilepacking/screens/config/form_inputs/provider_name.dart';
import 'package:mobilepacking/screens/config/form_inputs/service_url.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  ConfigCubit() : super(const ConfigState());

  void hoServiceUrlChanged(String value) {
    final serviceUrl = ServiceUrl.dirty(value);
    emit(state.copyWith(hoServiceUrl: serviceUrl));
  }

  void hoProviderNameChanged(String value) {
    final providerName = ProviderName.dirty(value);
    emit(state.copyWith(hoProviderName: providerName));
  }

  void hoDatabaseNameChanged(String value) {
    final databaseName = DatabaseName.dirty(value);
    emit(state.copyWith(hoDatabaseName: databaseName));
  }

  void saveConfig() {
    final appConfig = GetStorage("AppConfig");
    appConfig.write("hoServiceUrl", state.hoServiceUrl.value);
    appConfig.write("hoProviderName", state.hoProviderName.value);
    appConfig.write("hoDatabaseName", state.hoDatabaseName.value);
  }

  void loadConfig() {
    final appConfig = GetStorage("AppConfig");
    String _hoServiceUrl =
        appConfig.read("hoServiceUrl") ?? AppConfig.serviceApi;
    String _hoProviderName =
        appConfig.read("hoProviderName") ?? AppConfig.provider;
    String _hoDatabaseName =
        appConfig.read("hoDatabaseName") ?? AppConfig.databaseName;

    emit(
      ConfigState(
        hoServiceUrl: ServiceUrl.dirty(_hoServiceUrl),
        hoProviderName: ProviderName.dirty(_hoProviderName),
        hoDatabaseName: DatabaseName.dirty(_hoDatabaseName),
        status: FormzStatus.pure,
      ),
    );
  }
}
