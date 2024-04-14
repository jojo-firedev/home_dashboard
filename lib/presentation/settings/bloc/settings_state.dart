part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final String host;
  final String token;

  SettingsLoaded(this.host, this.token);
}
