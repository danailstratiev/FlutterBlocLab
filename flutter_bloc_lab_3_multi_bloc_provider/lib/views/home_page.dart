import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/bloc/bottom_bloc.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/bloc/top_bloc.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/models/constants.dart';
import 'package:flutter_bloc_lab_3_multi_bloc_provider/views/app_bloc_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // images comes from constants.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (_) => TopBloc(
                waitBeforeLoading: const Duration(seconds: 3),
                urls: images,
              ),
            ),
            BlocProvider<BottomBloc>(
              create: (_) => BottomBloc(
                waitBeforeLoading: const Duration(seconds: 3),
                urls: images,
              ),
            ),
          ],
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBlocWiew<TopBloc>(),
              AppBlocWiew<BottomBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
