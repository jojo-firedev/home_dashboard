import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:home_dashboard/globals.dart';
import 'package:home_dashboard/service/home_assistant_socket.dart';
import 'package:home_dashboard/service/secure_storage.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  String homeAssistantToken = '';
  String homeAssistantHost = '';

  SettingsBloc(BuildContext context) : super(SettingsInitial()) {
    on<LoadSettings>((event, emit) async {
      emit(SettingsLoading());
      homeAssistantToken =
          await Globals.secureStorage.getToken('ha_access_token') ?? '';
      homeAssistantHost = await Globals.secureStorage.getToken('ha_host') ?? '';

      emit(SettingsLoaded(homeAssistantHost, homeAssistantToken));
    });

    on<UpdateHomeAssistantHost>((event, emit) async {
      homeAssistantHost = event.host;

      await Globals.secureStorage.storeToken('ha_host', homeAssistantHost);
    });

    on<UpdateHomeAssistantToken>((event, emit) async {
      homeAssistantToken = event.token;

      await Globals.secureStorage
          .storeToken('ha_access_token', homeAssistantToken);
    });

    on<TestConnection>((event, emit) async {
      HomeAssistantAPI api = HomeAssistantAPI();
      bool isConnected = await api.connect();

      if (isConnected) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Verbindung erfolgreich.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Verbindung fehlgeschlagen.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
