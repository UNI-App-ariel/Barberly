import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:uni_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:uni_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:uni_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:uni_app/features/auth/domain/usecases/logout.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_email.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_google.dart';
import 'package:uni_app/features/auth/domain/usecases/signup_with_email.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

part 'init_dependencies.dart';