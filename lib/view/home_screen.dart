import 'package:bloc_by_wckd/bloc/buttom_bloc.dart';
import 'package:bloc_by_wckd/bloc/top_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modal/constant.dart';
import 'app_bloc_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (_) => TopBloc(
                waitBeforeLoading: const Duration(seconds: 1),
                urls: images,
              ),
            ),
            BlocProvider<ButtomBLoc>(
              create: (_) => ButtomBLoc(
                waitBeforeLoading: const Duration(seconds: 1),
                urls: images,
              ),
            ),
          ],
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBlocView<TopBloc>(),
              AppBlocView<ButtomBLoc>(),
            ],
          ),
        ),
      ),
    );
  }
}
