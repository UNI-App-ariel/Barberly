import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/domian/usecases/add_barber_shop.dart';
import 'package:uni_app/core/common/domian/usecases/delete_barber_shop.dart';
import 'package:uni_app/core/common/domian/usecases/favorite_shop.dart';
import 'package:uni_app/core/common/domian/usecases/get_all_barber_shops.dart';
import 'package:uni_app/core/common/domian/usecases/update_barber_shop.dart';

part 'barbershop_event.dart';
part 'barbershop_state.dart';

class BarbershopBloc extends Bloc<BarbershopEvent, BarbershopState> {
  List<Barbershop> _barbershops = [];

  // get barbershop by id
  Barbershop? getBarbershopById(String id) {
    try {
      return _barbershops.firstWhere((shop) => shop.id == id);
    } catch (e) {
      return null; // Redundant, but ensures safety if _barbershops is empty or null
    }
  }

  // final GetBarberShopUseCase _getBarberShopUseCase;
  final AddBarberShopUseCase _addBarberShopUseCase;
  final DeleteBarberShopUseCase _deleteBarbershopUseCase;
  final UpdateBarberShopUseCase _updateBarberShopUseCase;
  final GetAllBarberShopsUseCase _getAllBarbershopsUseCase;
  final FavoriteShopUseCase _favoriteShopUseCase;
  final UnFavoriteShopUseCase _unFavoriteShopUseCase;

  BarbershopBloc({
    // required GetBarberShopUseCase getBarberShopUseCase,
    required AddBarberShopUseCase addBarberShopUseCase,
    required DeleteBarberShopUseCase deleteBarbershopUseCase,
    required UpdateBarberShopUseCase updateBarberShopUseCase,
    required GetAllBarberShopsUseCase getAllBarbershopsUseCase,
    required FavoriteShopUseCase favoriteShopUseCase,
    required UnFavoriteShopUseCase unFavoriteShopUseCase,
  })  :
        // _getBarberShopUseCase = getBarberShopUseCase,
        _addBarberShopUseCase = addBarberShopUseCase,
        _deleteBarbershopUseCase = deleteBarbershopUseCase,
        _updateBarberShopUseCase = updateBarberShopUseCase,
        _getAllBarbershopsUseCase = getAllBarbershopsUseCase,
        _favoriteShopUseCase = favoriteShopUseCase,
        _unFavoriteShopUseCase = unFavoriteShopUseCase,
        super(BarbershopInitial()) {
    // on<GetBarbershopEvent>(_getBarberShop);

    // add new barbershop
    on<AddBarbershopEvent>(_addBarberShop);

    // delete barbershop
    on<DeleteBarbershopEvent>(_deleteBarbershop);

    // update barbershop
    on<UpdateBarbershopEvent>(_updateBarberShop);

    // get all barbershops
    on<GetAllBarberShopsEvent>(_getAllBarbershops);

    // favorite barbershop
    on<FavoriteShopEvent>(_favoriteShop);

    // unfavorite barbershop
    on<UnFavoriteShopEvent>(_unFavoriteShop);
  }

  // void _getBarberShop(GetBarbershopEvent event, Emitter<BarbershopState> emit) async {
  //   emit(BarbershopLoading());
  //   final result = await _getBarberShopUseCase(event.id);
  //   result.fold(
  //     (failure) => emit(BarbershopError(failure.message)),
  //     (barbershop) => emit(BarbershopLoaded(barbershop)),
  //   );
  // }

  void _addBarberShop(
      AddBarbershopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _addBarberShopUseCase(event.barbershop);
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {
        add(GetAllBarberShopsEvent());
      },
    );
  }

  void _deleteBarbershop(
      DeleteBarbershopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _deleteBarbershopUseCase(event.id);
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {
        add(GetAllBarberShopsEvent());
      },
    );
  }

  void _updateBarberShop(
      UpdateBarbershopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _updateBarberShopUseCase(event.barbershop);
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {
        add(GetAllBarberShopsEvent());
      },
    );
  }

  void _getAllBarbershops(
      GetAllBarberShopsEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _getAllBarbershopsUseCase(null);
    result.fold((failure) => emit(BarbershopError(failure.message)),
        (barbershops) {
      _barbershops = barbershops;

      emit(BarbershopLoaded(barbershops));
    });
  }

  void _favoriteShop(
      FavoriteShopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _favoriteShopUseCase(FavoriteShopParams(
        userId: event.userId, barbershopId: event.barbershopId));
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {
        add(GetAllBarberShopsEvent());
      },
    );
  }

  void _unFavoriteShop(
      UnFavoriteShopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _unFavoriteShopUseCase(FavoriteShopParams(
        userId: event.userId, barbershopId: event.barbershopId));
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {
        add(GetAllBarberShopsEvent());
      },
    );
  }
}
