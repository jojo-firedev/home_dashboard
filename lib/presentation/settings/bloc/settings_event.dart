part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateHomeAssistantHost extends SettingsEvent {
  final String host;

  UpdateHomeAssistantHost(this.host);
}

class UpdateHomeAssistantToken extends SettingsEvent {
  final String token;

  UpdateHomeAssistantToken(this.token);
}

class TestConnection extends SettingsEvent {}
