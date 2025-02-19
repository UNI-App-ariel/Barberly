import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/features/owner/domain/usecases/delete_shop.dart';
import 'package:uni_app/features/owner/domain/usecases/get_shop.dart';
import 'package:uni_app/features/owner/domain/usecases/update_shop.dart';
import 'package:image/image.dart' as img;

part 'owner_shop_event.dart';
part 'owner_shop_state.dart';

class OwnerShopBloc extends Bloc<OwnerShopEvent, OwnerShopState> {
  // get shop
  Barbershop? _currentShop;

  Barbershop? get shop => _currentShop;

  // usecase
  final GetOwnerShopUseCase _getShopUseCase;
  final UpdateOwnerShopUseCase _updateShopUseCase;
  final DeleteOwnerShopUseCase _deleteShopUseCase;

  StreamSubscription? _shopSubscription;

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

    // pick shop image
    on<PickShopImageEvent>(_onPickShopImage);
  }

  void _onGetShop(GetShopEvent event, Emitter<OwnerShopState> emit) async {
    emit(OwnerShopLoading());
    _shopSubscription?.cancel();

    _shopSubscription = _getShopUseCase(event.ownerId).listen((result) {
      result.fold(
        (failure) => emit(OwnerShopError(failure.message)),
        (shop) {
          _currentShop = shop;
          emit(OwnerShopLoaded(shop));
        },
      );
    }, onError: (e) {
      emit(OwnerShopError(e.toString()));
    });

    await _shopSubscription?.asFuture();
  }

  void _onUpdateShop(
      UpdateShopEvent event, Emitter<OwnerShopState> emit) async {
    emit(OwnerShopLoading());

    final result = await _updateShopUseCase(
      UpdateOwnerShopParams(event.shop, event.pickedImage, event.galleryImages),
    );

    result.fold(
      (failure) => emit(OwnerShopError(failure.message)),
      (_) {
        emit(OwnerShopUpdated());
        add(GetShopEvent(event.shop.id));
      },
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

  FutureOr<void> _onPickShopImage(
      PickShopImageEvent event, Emitter<OwnerShopState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: event.isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70, // Initial quality setting
      );

      if (pickedFile != null) {
        final File originalFile = File(pickedFile.path);

        // Compress the image
        final File compressedImage = await _compressImage(originalFile);

        // Emit the compressed image
        emit(OwnerShopImagePicked(compressedImage));

        if (_currentShop != null) {
          emit(OwnerShopLoaded(_currentShop!));
        }
      }
    } catch (e) {
      emit(OwnerShopError(e.toString()));
    }
  }

  Future<File> _compressImage(File file) async {
    // Read file as bytes
    Uint8List bytes = await file.readAsBytes();

    // Decode image
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return file; // If decoding fails, return original file

    // Resize image (reduce resolution)
    img.Image resized = img.copyResize(image, width: 800); // Adjust width

    // Convert back to Uint8List with compression
    Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(resized, quality: 85)); // Adjust quality

    // Save compressed image
    final tempDir = await getTemporaryDirectory();
    final compressedFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }
}
