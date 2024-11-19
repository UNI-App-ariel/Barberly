import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:uni_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:uni_app/features/auth/domain/usecases/singin_with_email.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/my_app.dart';

void main() async {
  // init flutter
  WidgetsFlutterBinding.ensureInitialized();

  // init firebase
  await Firebase.initializeApp();

  // run app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            singinWithEmailUsecase: SinginWithEmailUsecase(
              AuthRepoImpl(
                AuthDatasourceImpl(FirebaseAuth.instance),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
