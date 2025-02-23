import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/data/models/availability_model.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/appointment/appointment_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/booked_appointments/booked_appointments_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/core/utils/bloc_observer.dart';
import 'package:uni_app/core/utils/notifications.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/customer/presentation/bloc/favorite_shops/favorite_shops_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_appointments/owner_appointments_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_gallary/owner_gallary_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';
import 'package:uni_app/features/profile/presentation/bloc/pfp/pfp_bloc.dart';
import 'package:uni_app/init_dependencies.g.dart';
import 'package:uni_app/my_app.dart';

Future<void> main() async {
  // init flutter
  WidgetsFlutterBinding.ensureInitialized();

  // init dependencies
  await initDependencies();

  // init bloc observer
  Bloc.observer = AppBlocObserver();

  // set system ui mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // init onesignal
  OneSignalService().init();

  // add data to firebase
  // await addDateToFirebase();

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

addDateToFirebase() {
  // for every shop add availability

  final firestore = FirebaseFirestore.instance;

  final now = DateTime.now();

  firestore.collection('barbershops').get().then((value) {
    for (var element in value.docs) {
      firestore.collection('availability').doc(element.id).set(
            AvailabilityModel(
              id: element.id,
              availabilityWindow: 7,
              defaultTimeSlots: {
                1: [
                  for (var i = 0; i < 10; i++) ...[
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 0),
                      endTime: DateTime(now.year, 0, 0, 10 + i, 30),
                    ),
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 30),
                      endTime: DateTime(now.year, 0, 0, 10 + i + 1, 0),
                    ),
                  ],
                ],
                2: [
                  for (var i = 0; i < 10; i++) ...[
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 0),
                      endTime: DateTime(now.year, 0, 0, 10 + i, 30),
                    ),
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 30),
                      endTime: DateTime(now.year, 0, 0, 10 + i + 1, 0),
                    ),
                  ],
                ],
                3: [
                  for (var i = 0; i < 10; i++) ...[
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 0),
                      endTime: DateTime(now.year, 0, 0, 10 + i, 30),
                    ),
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 30),
                      endTime: DateTime(now.year, 0, 0, 10 + i + 1, 0),
                    ),
                  ],
                ],
                4: [
                  for (var i = 0; i < 10; i++) ...[
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 0),
                      endTime: DateTime(now.year, 0, 0, 10 + i, 30),
                    ),
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 30),
                      endTime: DateTime(now.year, 0, 0, 10 + i + 1, 0),
                    ),
                  ],
                ],
                5: [
                  for (var i = 0; i < 10; i++) ...[
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 0),
                      endTime: DateTime(now.year, 0, 0, 10 + i, 30),
                    ),
                    TimeSlotModel(
                      startTime: DateTime(now.year, 0, 0, 10 + i, 30),
                      endTime: DateTime(now.year, 0, 0, 10 + i + 1, 0),
                    ),
                  ],
                ],
                6: [],
                7: [],
              },
              customTimeSlots: {},
              timeSlots: {},
            ).toMap(),
          );
    }
  });
}
