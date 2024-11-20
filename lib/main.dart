import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/bloc/cubit/theme_cubit.dart';
import 'package:uni_app/core/utils/bloc_observer.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/init_dependencies.g.dart';
import 'package:uni_app/my_app.dart';

void main() async {
  // init flutter
  WidgetsFlutterBinding.ensureInitialized();

  // init dependencies
  await initDependencies();

  // init bloc observer
  Bloc.observer = AppBlocObserver();

  // run app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => serviceLocator<AuthBloc>()..add(CheckAuth())),
            BlocProvider(create: (context) => serviceLocator<ThemeCubit>()),
          
      ],
      child: const MyApp(),
    ),
  );
}
