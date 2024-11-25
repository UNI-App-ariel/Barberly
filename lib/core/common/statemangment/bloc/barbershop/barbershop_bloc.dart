import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/domian/usecases/add_barber_shop.dart';
import 'package:uni_app/core/common/domian/usecases/delete_barber_shop.dart';
import 'package:uni_app/core/common/domian/usecases/get_all_barber_shops.dart';
import 'package:uni_app/core/common/domian/usecases/update_barber_shop.dart';

part 'barbershop_event.dart';
part 'barbershop_state.dart';

class BarbershopBloc extends Bloc<BarbershopEvent, BarbershopState> {
  // final GetBarberShopUseCase _getBarberShopUseCase;
  final AddBarberShopUseCase _addBarberShopUseCase;
  final DeleteBarberShopUseCase _deleteBarbershopUseCase;
  final UpdateBarberShopUseCase _updateBarberShopUseCase;
  final GetAllBarberShopsUseCase _getAllBarbershopsUseCase;

  BarbershopBloc({
    // required GetBarberShopUseCase getBarberShopUseCase,
    required AddBarberShopUseCase addBarberShopUseCase,
    required DeleteBarberShopUseCase deleteBarbershopUseCase,
    required UpdateBarberShopUseCase updateBarberShopUseCase,
    required GetAllBarberShopsUseCase getAllBarbershopsUseCase,
  })  : 
  // _getBarberShopUseCase = getBarberShopUseCase,
        _addBarberShopUseCase = addBarberShopUseCase,
        _deleteBarbershopUseCase = deleteBarbershopUseCase,
        _updateBarberShopUseCase = updateBarberShopUseCase,
        _getAllBarbershopsUseCase = getAllBarbershopsUseCase,
        super(BarbershopInitial()) {
          // on<GetBarbershopEvent>(_getBarberShop);
          on<AddBarbershopEvent>(_addBarberShop);
          on<DeleteBarbershopEvent>(_deleteBarbershop);
          on<UpdateBarbershopEvent>(_updateBarberShop);
          on<GetAllBarberShopsEvent>(_getAllBarbershops);
        }

  // void _getBarberShop(GetBarbershopEvent event, Emitter<BarbershopState> emit) async {
  //   emit(BarbershopLoading());
  //   final result = await _getBarberShopUseCase(event.id);
  //   result.fold(
  //     (failure) => emit(BarbershopError(failure.message)),
  //     (barbershop) => emit(BarbershopLoaded(barbershop)),
  //   );
  // }

  void _addBarberShop(AddBarbershopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _addBarberShopUseCase(event.barbershop);
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {add(GetAllBarberShopsEvent());},
    );
  }

  void _deleteBarbershop(DeleteBarbershopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _deleteBarbershopUseCase(event.id);
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {add(GetAllBarberShopsEvent());},
    );
  }

  void _updateBarberShop(UpdateBarbershopEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _updateBarberShopUseCase(event.barbershop);
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (_) {add(GetAllBarberShopsEvent());},
    );
  }

  void _getAllBarbershops(GetAllBarberShopsEvent event, Emitter<BarbershopState> emit) async {
    emit(BarbershopLoading());
    final result = await _getAllBarbershopsUseCase(null);
    result.fold(
      (failure) => emit(BarbershopError(failure.message)),
      (barbershops) => emit(BarbershopLoaded(barbershops)),
    );
  }
}





