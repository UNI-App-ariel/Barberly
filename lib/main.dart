import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/core/utils/bloc_observer.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/customer/presentation/bloc/favorite_shops/favorite_shops_bloc.dart';
import 'package:uni_app/init_dependencies.g.dart';
import 'package:uni_app/my_app.dart';

void main() async {
  // init flutter
  WidgetsFlutterBinding.ensureInitialized();

  // init dependencies
  await initDependencies();

  // init bloc observer
  Bloc.observer = AppBlocObserver();

  // // create initial barbershops
  // final dataSource =
  //     BarbershopDataSourceImpl(firestore: FirebaseFirestore.instance);

  // final shop1 = BarbershopModel(
  //   id: '1',
  //   name: 'Barbershop 1',
  //   address: 'Address 1',
  //   phoneNumber: '123456789',
  //   imageUrl: '',
  //   rating: 2,
  //   reviewCount: 200,
  //   services: [],
  //   barbers: [],
  // );

  // final shop2 = BarbershopModel(
  //   id: '2',
  //   name: 'Barbershop 2',
  //   address: 'Address 2',
  //   phoneNumber: '123456789',
  //   imageUrl: '',
  //   rating: 3,
  //   reviewCount: 300,
  //   services: [],
  //   barbers: [],
  // );

  // await dataSource.addBarbershop(shop1);
  // await dataSource.addBarbershop(shop2);

  // run app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => serviceLocator<AuthBloc>()..add(CheckAuth())),
        BlocProvider(create: (context) => serviceLocator<ThemeCubit>()),
        BlocProvider(create: (context) => serviceLocator<BarbershopBloc>()),
        BlocProvider(create: (context) => serviceLocator<FavoriteShopsBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
