import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_app/features/owner/domain/usecases/update_shop.dart';
part 'owner_gallary_event.dart';
part 'owner_gallary_state.dart';

class OwnerGallaryBloc extends Bloc<OwnerGallaryEvent, OwnerGallaryState> {
  final ImagePicker _gallaryPicker;
  final DeleteImageFromGalleryUseCase _deleteImageFromGallery;

  OwnerGallaryBloc(
      {required ImagePicker gallaryPicker,
      required DeleteImageFromGalleryUseCase deleteImageFromGallery})
      : _gallaryPicker = gallaryPicker,
        _deleteImageFromGallery = deleteImageFromGallery,
        super(OwnerGallaryInitial()) {
    on<OwnerGallaryEvent>((event, emit) {});
    on<PickGallaryEvent>(_onPickGallary);
    on<ResetGalleryEvent>((event, emit) {
      emit(OwnerGallaryInitial());
    });

    on<DeleteImageFromGalleryEvent>(_onDeleteImageFromGallery);
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

  FutureOr<void> _onPickGallary(
      PickGallaryEvent event, Emitter<OwnerGallaryState> emit) async {
    List<XFile?> pickedImages = [];
    try {
      if (event.isCamera) {
        pickedImages
            .add(await _gallaryPicker.pickImage(source: ImageSource.camera));

        if (pickedImages.first != null) {
          File compressed =
              await _compressImage(File(pickedImages.first!.path));
          emit(OwnerGallaryImagesPicked([compressed]));
        } else {
          emit(OwnerGallaryError("No image selected"));
        }
      } else {
        // Allow user to pick multiple images
        pickedImages = await _gallaryPicker.pickMultiImage();

        if (pickedImages.isNotEmpty) {
          List<File> compressedImages = [];
          for (XFile? image in pickedImages) {
            if (image == null) continue;
            File compressed = await _compressImage(File(image.path));
            compressedImages.add(compressed);
          }

          emit(OwnerGallaryImagesPicked(compressedImages));
        } else {
          emit(OwnerGallaryError("No images selected"));
        }
      }
    } catch (e) {
      emit(OwnerGallaryError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteImageFromGallery(DeleteImageFromGalleryEvent event,
      Emitter<OwnerGallaryState> emit) async {
    try {
      final result = await _deleteImageFromGallery(
          DeleteImageFromGalleryParams(event.shopId, event.imageUrl));

      result.fold((l) => emit(OwnerGallaryError(l.message)), (r) {});
    } catch (e) {
      emit(OwnerGallaryError(e.toString()));
    }
  }
}
