import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_dashboard/presentation/settings/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: BlocProvider(
        create: (context) => SettingsBloc(context)..add(LoadSettings()),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsInitial || state is SettingsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SettingsLoaded) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          const Text('Home Assistant URL'),
                          const SizedBox(width: 42),
                          Expanded(
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: state.host),
                              onChanged: (value) => context
                                  .read<SettingsBloc>()
                                  .add(UpdateHomeAssistantHost(value)),
                              onFieldSubmitted: (value) => context
                                  .read<SettingsBloc>()
                                  .add(UpdateHomeAssistantHost(value)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Home Assistant API Key'),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: state.token),
                              onChanged: (value) => context
                                  .read<SettingsBloc>()
                                  .add(UpdateHomeAssistantToken(value)),
                              onFieldSubmitted: (value) => context
                                  .read<SettingsBloc>()
                                  .add(UpdateHomeAssistantToken(value)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: FilledButton(
                          onPressed: () => context
                              .read<SettingsBloc>()
                              .add(TestConnection()),
                          child: const Text('Verbindung testen'),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/home'),
                          child: const Text('Zurück zum Home Screen'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
