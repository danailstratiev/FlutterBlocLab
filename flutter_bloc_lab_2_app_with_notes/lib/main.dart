import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/apis/login_api.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/apis/notes_api.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/bloc/actions.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/bloc/app_bloc.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/bloc/app_state.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/dialogs/generic_dialog.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/dialogs/loading_screen.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/model.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/strings.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/views/iterable_list_view.dart';
import 'package:flutter_bloc_lab_2_app_with_notes/views/login_view.dart';

void main() {
  runApp(MaterialApp(
    title: 'Bloc Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const MaterialApp(
      home: HomePage(),
    ),
  ));
}

const names = ['Foo', 'Bar', 'Baz', 'Penio', 'Vulio', 'Mihko', 'Mon'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  // We dont have initial state
  NamesCubit() : super(null);

  // We produce new values with emit
  void pickRandomName() => emit(names.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // display possible errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {ok: true},
              );
            }

            // if we are logged in, but we have no fetched notes, fetch them now.
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;

            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
