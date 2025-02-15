import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_app/core/utils/image_compress.dart';

part 'pfp_event.dart';
part 'pfp_state.dart';

class PfpBloc extends Bloc<PfpEvent, PfpState> {
  final ImagePicker _imagePicker;
  PfpBloc({
    required ImagePicker imagePicker,
  })  : _imagePicker = imagePicker,
        super(PfpInitial()) {
    on<PfpEvent>((event, emit) {});

    // pick image from gallery
    on<PickImageFromGallery>(_onPickImageFromGallery);

    // pick image from camera
    on<PickImageFromCamera>(_onPickImageFromCamera);
  }

  void _onPickImageFromGallery(
      PickImageFromGallery event, Emitter<PfpState> emit) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        requestFullMetadata: false,
      );

      if (pickedFile != null) {
        final compressedFile = await ImageCompression.compressImage(
          File(pickedFile.path),
          width: 512,
          maintainAspectRatio: true,
        );

        emit(PfpLoaded(image: compressedFile));
      } else {
        emit(PfpError(message: 'No image selected'));
      }
    } catch (e) {
      emit(PfpError(message: e.toString()));
    }
  }

  void _onPickImageFromCamera(
      PickImageFromCamera event, Emitter<PfpState> emit) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        requestFullMetadata: false,
      );

      if (pickedFile != null) {
        try {
          final compressedFile = await ImageCompression.compressImage(
            File(pickedFile.path),
            width: 512,
            maintainAspectRatio: true,
          );
          emit(PfpLoaded(image: compressedFile));
        } catch (compressionError) {
          emit(PfpError(
              message:
                  'Image compression failed: ${compressionError.toString()}'));
        }
      } else {
        emit(PfpError(message: 'No image selected'));
      }
    } catch (e) {
      emit(PfpError(message: e.toString()));
    }
  }
}
