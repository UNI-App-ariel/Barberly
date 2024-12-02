import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/features/owner/domain/usecases/delete_shop.dart';
import 'package:uni_app/features/owner/domain/usecases/get_shop.dart';
import 'package:uni_app/features/owner/domain/usecases/update_shop.dart';

part 'owner_shop_event.dart';
part 'owner_shop_state.dart';

class OwnerShopBloc extends Bloc<OwnerShopEvent, OwnerShopState> {
  // usecase
  final GetOwnerShopUseCase _getShopUseCase;
  final UpdateOwnerShopUseCase _updateShopUseCase;
  final DeleteOwnerShopUseCase _deleteShopUseCase;

  OwnerShopBloc({
    required GetOwnerShopUseCase getShopUseCase,
    required UpdateOwnerShopUseCase updateShopUseCase,
    required DeleteOwnerShopUseCase deleteShopUseCase,
  })  : _getShopUseCase = getShopUseCase,
        _updateShopUseCase = updateShopUseCase,
        _deleteShopUseCase = deleteShopUseCase,
        super(OwnerShopInitial()) {
    on<OwnerShopEvent>((event, emit) {});

    // get shop
    on<GetShopEvent>(_onGetShop);

    // update shop
    on<UpdateShopEvent>(_onUpdateShop);

    // delete shop
    on<DeleteShopEvent>(_onDeleteShop);
  }

  void _onGetShop(GetShopEvent event, Emitter<OwnerShopState> emit) async {
    emit(OwnerShopLoading());
    final result = await _getShopUseCase(event.ownerId);
    result.fold(
      (failure) => emit(OwnerShopError(failure.message)),
      (shop) => emit(OwnerShopLoaded(shop)),
    );
  }

  void _onUpdateShop(
      UpdateShopEvent event, Emitter<OwnerShopState> emit) async {
    emit(OwnerShopLoading());
    final result = await _updateShopUseCase(event.shop);
    result.fold(
      (failure) => emit(OwnerShopError(failure.message)),
      (_) => emit(OwnerShopInitial()),
    );
  }

  void _onDeleteShop(
      DeleteShopEvent event, Emitter<OwnerShopState> emit) async {
    emit(OwnerShopLoading());
    final result = await _deleteShopUseCase(event.shopId);
    result.fold(
      (failure) => emit(OwnerShopError(failure.message)),
      (_) => emit(OwnerShopInitial()),
    );
  }
}
