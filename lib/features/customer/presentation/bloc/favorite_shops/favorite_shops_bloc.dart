import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/features/customer/domain/usecases/get_favorite_shops.dart';

part 'favorite_shops_event.dart';
part 'favorite_shops_state.dart';

class FavoriteShopsBloc extends Bloc<FavoriteShopsEvent, FavoriteShopsState> {
  // usecase
  final GetFavoriteShopsUseCase _getFavoriteShopsUseCase;

  FavoriteShopsBloc({
    required GetFavoriteShopsUseCase getFavoriteShopsUseCase,
  })  : _getFavoriteShopsUseCase = getFavoriteShopsUseCase,
        super(FavoriteShopsInitial()) {
    on<FavoriteShopsEvent>((event, emit) {});

    // get favorite shops
    on<GetFavoriteShopsEvent>(_onGetFavoriteShops);
  }

  void _onGetFavoriteShops(
    GetFavoriteShopsEvent event,
    Emitter<FavoriteShopsState> emit,
  ) async {
    emit(FavoriteShopsLoading());
    final result = await _getFavoriteShopsUseCase(event.userId);
    result.fold(
      (failure) => emit(FavoriteShopsError(failure.message)),
      (favoriteShops) => emit(FavoriteShopsLoaded(favoriteShops)),
    );
  }
}
