import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_app/core/common/data/datasources/app_user_datasource.dart';
import 'package:uni_app/core/common/data/datasources/appointments_data_source.dart';
import 'package:uni_app/core/common/data/datasources/barbershop_data_source.dart';
import 'package:uni_app/core/common/data/repositories/app_user_repo_impl.dart';
import 'package:uni_app/core/common/data/repositories/appointment_repo_iml.dart';
import 'package:uni_app/core/common/data/repositories/barbershop_repo_impl.dart';
import 'package:uni_app/core/common/domian/repositories/app_user_repo.dart';
import 'package:uni_app/core/common/domian/repositories/appointmet_repo.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/common/domian/usecases/add_barber_shop.dart';
import 'package:uni_app/core/common/domian/usecases/app_user/stream_app_user.dart';
import 'package:uni_app/core/common/domian/usecases/app_user/update_app_user.dart';
import 'package:uni_app/core/common/domian/usecases/appointment/book_appointment.dart';
import 'package:uni_app/core/common/domian/usecases/appointment/cancel_appointment.dart';
import 'package:uni_app/core/common/domian/usecases/appointment/update_appointment.dart';
import 'package:uni_app/core/common/domian/usecases/availability/update_availability.dart';
import 'package:uni_app/core/common/domian/usecases/delete_barber_shop.dart';
import 'package:uni_app/core/common/domian/usecases/favorite_shop.dart';
import 'package:uni_app/core/common/domian/usecases/get_all_barber_shops.dart';
import 'package:uni_app/core/common/domian/usecases/appointment/get_appointments.dart';
import 'package:uni_app/core/common/domian/usecases/get_barber_shop.dart';
import 'package:uni_app/core/common/domian/usecases/get_owner_appointments_streams.dart';
import 'package:uni_app/core/common/domian/usecases/availability/stream_availability.dart';
import 'package:uni_app/core/common/domian/usecases/update_barber_shop.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/appointment/appointment_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/booked_appointments/booked_appointments_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/common/statemangment/cubit/theme_cubit.dart';
import 'package:uni_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:uni_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:uni_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:uni_app/features/auth/domain/usecases/logout.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_email.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_facbook.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_google.dart';
import 'package:uni_app/features/auth/domain/usecases/signup_with_email.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/customer/data/datasources/favorites_datasource.dart';
import 'package:uni_app/features/customer/data/repositories/favorites_repo_impl.dart';
import 'package:uni_app/features/customer/domain/repsitories/favorites_repo.dart';
import 'package:uni_app/features/customer/domain/usecases/get_favorite_shops.dart';
import 'package:uni_app/features/customer/presentation/bloc/favorite_shops/favorite_shops_bloc.dart';
import 'package:uni_app/features/owner/data/datasources/owner_shop_datasource.dart';
import 'package:uni_app/features/owner/data/repositories/owner_shop_repo_impl.dart';
import 'package:uni_app/features/owner/domain/repositories/owner_shop_repo.dart';
import 'package:uni_app/features/owner/domain/usecases/delete_shop.dart';
import 'package:uni_app/features/owner/domain/usecases/get_shop.dart';
import 'package:uni_app/features/owner/domain/usecases/update_shop.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_appointments/owner_appointments_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_gallary/owner_gallary_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';
import 'package:uni_app/features/profile/presentation/bloc/pfp/pfp_bloc.dart';

part 'init_dependencies.dart';