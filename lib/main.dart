import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/appointment/appointment_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/booked_appointments/booked_appointments_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/core/utils/bloc_observer.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/customer/presentation/bloc/favorite_shops/favorite_shops_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_appointments/owner_appointments_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_gallary/owner_gallary_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';
import 'package:uni_app/features/profile/presentation/bloc/pfp/pfp_bloc.dart';
import 'package:uni_app/init_dependencies.g.dart';
import 'package:uni_app/my_app.dart';

void main() async {
  // init flutter
  WidgetsFlutterBinding.ensureInitialized();

  // init dependencies
  await initDependencies();

  // init bloc observer
  Bloc.observer = AppBlocObserver();

  // set system ui mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // run app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (context) => serviceLocator<AppUserBloc>()),
        BlocProvider(create: (context) => serviceLocator<ThemeCubit>()),
        BlocProvider(create: (context) => serviceLocator<BarbershopBloc>()),
        BlocProvider(create: (context) => serviceLocator<FavoriteShopsBloc>()),
        BlocProvider(
            create: (context) => serviceLocator<ShopAvailabilityBloc>()),
        BlocProvider(create: (context) => serviceLocator<AppointmentBloc>()),
        BlocProvider(create: (context) => serviceLocator<OwnerShopBloc>()),
        BlocProvider(create: (context) => serviceLocator<OwnerGallaryBloc>()),
        BlocProvider(
            create: (context) => serviceLocator<OwnerAppointmentsBloc>()),
        BlocProvider(
            create: (context) => serviceLocator<BookedAppointmentsBloc>()),
            BlocProvider(create: (context) => serviceLocator<PfpBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
