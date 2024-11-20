part of 'init_dependencies.g.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  // initialize Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
  }

  // initilize Firebase auth
  final fireBaseAuth = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton(() => fireBaseAuth);

  // initialize Firestore
  final firestore = FirebaseFirestore.instance;
  serviceLocator.registerLazySingleton(() => firestore);

  // initialize Firebase storage
  final storage = FirebaseStorage.instance;
  serviceLocator.registerLazySingleton(() => storage);
}

void _initAuth() {
  // datasource

  serviceLocator.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(
      firestore: serviceLocator(),
      auth: serviceLocator(),
    ),
  );

  // repository

  serviceLocator.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      serviceLocator(),
    ),
  );

  // usecases

  serviceLocator.registerLazySingleton(
    () => GetCurrentUserUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SignInWithEmailUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SignUpWithEmailUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => LogOutUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SigninWithGoogleUseCase(
      serviceLocator(),
    ),
  );

  // bloc

  serviceLocator.registerFactory(
    () => AuthBloc(
      getCurrentUserUsecase: serviceLocator(),
      singinWithEmailUsecase: serviceLocator(),
      signupWithEmailUsecase: serviceLocator(),
      logOutUseCase: serviceLocator(),
      signinWithGoogleUseCase: serviceLocator(),
    ),
  );
}
