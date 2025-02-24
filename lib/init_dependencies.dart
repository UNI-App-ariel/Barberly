part of 'init_dependencies.g.dart';

final serviceLocator = GetIt.instance;

/// Method to initialize all the dependencies
/// This method should be called in the main method
/// before the runApp() method
/// This method initializes all the dependencies required for the app to run
Future<void> initDependencies() async {
  _initCore();
  _initAuth();
  _initShops();
  _iniOwner();

  // initialize Firebase
  await Firebase.initializeApp();

  // initilize Firebase auth
  final fireBaseAuth = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton(() => fireBaseAuth);

  // initialize Firestore
  final firestore = FirebaseFirestore.instance;
  serviceLocator.registerLazySingleton(() => firestore);

  // initialize Firebase storage
  final storage = FirebaseStorage.instance;
  serviceLocator.registerLazySingleton(() => storage);

  // initialize image picker
  final imagePicker = ImagePicker();
  serviceLocator.registerLazySingleton(() => imagePicker);
}

void _iniOwner() {
  // datasource
  serviceLocator.registerLazySingleton<OwnerShopDatasource>(
    () => OwnerShopDatasourceImpl(
      firestore: serviceLocator(),
    ),
  );

  // repository
  serviceLocator.registerLazySingleton<OwnerShopRepo>(
    () => OwnerShopRepoImpl(
      datasource: serviceLocator(),
    ),
  );

  // usecases
  serviceLocator.registerLazySingleton(
    () => GetOwnerShopUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => UpdateOwnerShopUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DeleteOwnerShopUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DeleteImageFromGalleryUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetOwnerAppointmentsStreamsUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  // bloc
  serviceLocator.registerLazySingleton(
    () => OwnerShopBloc(
      getShopUseCase: serviceLocator(),
      updateShopUseCase: serviceLocator(),
      deleteShopUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => OwnerGallaryBloc(
      gallaryPicker: serviceLocator(),
      deleteImageFromGallery: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => OwnerAppointmentsBloc(
      getOwnerAppointmentsUseCase: serviceLocator(),
    ),
  );
}

void _initShops() {
  // datasource

  serviceLocator.registerLazySingleton<BarbershopDataSource>(
    () => BarbershopDataSourceImpl(
      firestore: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<FavoritesDataSource>(
    () => FavoritesDataSourceImpl(
      firestore: serviceLocator(),
    ),
  );

  // repository

  serviceLocator.registerLazySingleton<BarbershopRepo>(
    () => BarbershopRepoImpl(
      barbershopDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<FavoritesRepo>(
    () => FavoritesRepoImpl(
      dataSource: serviceLocator(),
    ),
  );

  // usecases

  serviceLocator.registerLazySingleton(
    () => AddBarberShopUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DeleteBarberShopUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetBarberShopUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetAllBarberShopsUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => UpdateBarberShopUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => FavoriteShopUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => UnFavoriteShopUseCase(
      barbershopRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetFavoriteShopsUseCase(
      favoritesRepo: serviceLocator(),
    ),
  );

  // bloc

  serviceLocator.registerFactory(
    () => BarbershopBloc(
      addBarberShopUseCase: serviceLocator(),
      deleteBarbershopUseCase: serviceLocator(),
      updateBarberShopUseCase: serviceLocator(),
      getAllBarbershopsUseCase: serviceLocator(),
      favoriteShopUseCase: serviceLocator(),
      unFavoriteShopUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => FavoriteShopsBloc(
      getFavoriteShopsUseCase: serviceLocator(),
    ),
  );
}

void _initCore() {
  // cubit
  serviceLocator.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(),
  );

  // datasource
  serviceLocator.registerLazySingleton<AppUserDatasource>(
    () => AppUserDatasourceImpl(
      firestore: serviceLocator(),
      storage: serviceLocator(),
    ),
  );

  // repository
  serviceLocator.registerLazySingleton<AppUserRepo>(
    () => AppUserRepoImpl(
      datasource: serviceLocator(),
    ),
  );

  // usecases
  serviceLocator.registerLazySingleton<StreamAvailabilityUseCase>(
    () => StreamAvailabilityUseCase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<UpdateAvailabilityUsecase>(
    () => UpdateAvailabilityUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AppointmentsDataSource>(
    () => AppointmentsDataSourceImpl(
      firestore: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<AppointmentsRepo>(
    () => AppointmentsRepoIml(
      appointmentsDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<CancelAppointmentUseCase>(
    () => CancelAppointmentUseCase(
      appointmentsRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<BookAppointmentUseCase>(
    () => BookAppointmentUseCase(
      appointmentRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => UpdateAppointmentUseCase(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<GetAppointmentsUseCase>(
    () => GetAppointmentsUseCase(
      appointmentRepo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => StreamAppUserUseCase(
      repo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => UpdateAppUserUseCase(
      repo: serviceLocator(),
    ),
  );

  // blocs
  serviceLocator.registerLazySingleton(
    () => ShopAvailabilityBloc(
      streamAvailabilityUseCase: serviceLocator(),
      updateAvailabilityUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AppointmentBloc(
      cancelAppointmentUseCase: serviceLocator(),
      bookAppointmentUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AppUserBloc(
      streamAppUserUseCase: serviceLocator(),
      updateAppUserUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => BookedAppointmentsBloc(
      getAppointmentsUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => PfpBloc(
      imagePicker: serviceLocator(),
    ),
  );
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

  serviceLocator.registerLazySingleton(
    () => SignInWithFacebookUseCase(
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
      appUserBloc: serviceLocator(),
      signInWithFacebookUseCase: serviceLocator(),
    ),
  );
}
