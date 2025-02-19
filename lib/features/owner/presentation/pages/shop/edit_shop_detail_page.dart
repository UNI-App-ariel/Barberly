import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/core/common/widgets/settings_list_container.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/presentation/widgets/my_text_field.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_gallary/owner_gallary_bloc.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';

class EditShopDetailPage extends StatefulWidget {
  const EditShopDetailPage({super.key, required});

  @override
  State<EditShopDetailPage> createState() => _EditShopDetailPageState();
}

class _EditShopDetailPageState extends State<EditShopDetailPage> {
  bool _isChanged = false;
  bool _isSaving = false; // New flag to disable save button after press
  late Barbershop? _shop;
  File? _pickedImage;
  List<File>? _pickedImages;

  // Text editing controllers
  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _shop = context.read<OwnerShopBloc>().shop;
    _shopNameController.text = _shop?.name ?? '';
    _addressController.text = _shop?.address ?? '';
    _phoneController.text = _shop?.phoneNumber ?? '';

    _pickedImages = [];
    context.read<OwnerGallaryBloc>().add(ResetGalleryEvent());

    _shopNameController.addListener(_didChange);
    _addressController.addListener(_didChange);
    _phoneController.addListener(_didChange);
  }

  void _didChange() {
    final gallaryState = context.read<OwnerGallaryBloc>().state;
    bool hasSelectedImages = (gallaryState is OwnerGallaryImagesPicked &&
        gallaryState.images.isNotEmpty);

    setState(() {
      _isChanged = _shopNameController.text.trim() != _shop?.name ||
          _addressController.text.trim() != _shop?.address ||
          _phoneController.text.trim() != _shop?.phoneNumber ||
          _pickedImage != null ||
          (_pickedImages != null && _pickedImages!.isNotEmpty) ||
          hasSelectedImages;
    });
  }

  @override
  void dispose() {
    _pickedImages?.clear();
    _shopNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_shop == null) return;
    // Disable the save button immediately.
    setState(() {
      _isSaving = true;
      _isChanged = false;
    });
    final shop = _shop!.copyWith(
      name: _shopNameController.text.trim(),
      address: _addressController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );
    context.read<OwnerShopBloc>().add(UpdateShopEvent(shop,
        pickedImage: _pickedImage, galleryImages: _pickedImages));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Detail'),
      ),
      // Only show the save button if there are changes and we're not saving.
      floatingActionButton: (!_isSaving && _isChanged)
          ? FloatingActionButton.extended(
              onPressed: _saveChanges,
              label: const Text("Save"),
              icon: const Icon(Icons.save),
            )
          : null,
      body: BlocConsumer<OwnerShopBloc, OwnerShopState>(
        listener: (context, state) {
          if (state is OwnerShopError) {
            MyUtils.showErrorSnackBar(context, state.message);
            setState(() {
              _isSaving = false;
            });
          } else if (state is OwnerShopLoaded) {
            setState(() {
              _shop = state.shop;
            });
            _didChange();
          } else if (state is OwnerShopImagePicked) {
            setState(() {
              _pickedImage = state.image;
            });
            _didChange();
          } else if (state is OwnerShopUpdated) {
            MyUtils.showSnackBar(context, 'Shop updated successfully');
            setState(() {
              _isChanged = false;
              _isSaving = false;
              _pickedImage = null;
            });
          }
        },
        builder: (context, state) {
          if (state is OwnerShopLoading) {
            return const Center(child: Loader());
          } else if (state is OwnerShopLoaded) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildShopImage(),
                    const SizedBox(height: 20),
                    _buildShopNameField(),
                    const SizedBox(height: 10),
                    _buildAddressField(),
                    const SizedBox(height: 10),
                    _buildPhoneField(),
                    const SizedBox(height: 20),
                    _buildAddPhotos(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShopNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shop Name',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          MyTextField(
            controller: _shopNameController,
            hintText: 'Enter shop name',
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          MyTextField(
            controller: _addressController,
            hintText: 'Enter shop address',
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone Number',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          MyTextField(
            controller: _phoneController,
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildShopImage() {
    return GestureDetector(
      onTap: () {
        if (_shop?.imageUrl == null) {
          context.read<OwnerShopBloc>().add(PickShopImageEvent());
          return;
        }
        showCustomModalBottomSheet(
          context: context,
          expand: false,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Choose Image Source',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SettingsListContainer(
                  tiles: [
                    MySettingsTile(
                      title: 'Pick Image from Gallery',
                      leading: const Icon(CupertinoIcons.photo_on_rectangle,
                          size: 20),
                      onTap: () {
                        context
                            .read<OwnerShopBloc>()
                            .add(PickShopImageEvent(isCamera: false));
                        Navigator.pop(context);
                      },
                    ),
                    MySettingsTile(
                      title: 'Take Photo from Camera',
                      leading: const Icon(CupertinoIcons.camera,
                          size: 20, color: Colors.blue),
                      leadingBackgroundColor: Colors.blue.withValues(alpha:  0.1),
                      onTap: () {
                        context
                            .read<OwnerShopBloc>()
                            .add(PickShopImageEvent(isCamera: true));
                        Navigator.pop(context);
                      },
                    ),
                    MySettingsTile(
                      title: 'Remove Image',
                      leading: const Icon(
                        CupertinoIcons.trash,
                        size: 20,
                        color: Colors.red,
                      ),
                      leadingBackgroundColor: Colors.red.withValues(alpha:  0.1),
                      onTap: () {
                        if (_pickedImage != null) {
                          setState(() {
                            _pickedImage = null;
                            _isChanged = false;
                          });
                        } else {
                          _shop = _shop!.copyWith(resetImageUrl: true);
                          context
                              .read<OwnerShopBloc>()
                              .add(UpdateShopEvent(_shop!));
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
          containerWidget: (context, animation, child) => Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  color: Theme.of(context).colorScheme.surface,
                  child: SafeArea(
                    top: false,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: _getImage(),
      ),
    );
  }

  Widget _getImage() {
    if (_pickedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(
          _pickedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      );
    } else if (_shop?.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: _shop!.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(child: Loader()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.photo_on_rectangle,
              size: 40,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 10),
            Text(
              'Add Shop Image',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAddPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Updated "Add Photos" look using an OutlinedButton with an icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OutlinedButton.icon(
            onPressed: () {
              showCustomModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Choose Image Source',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      SettingsListContainer(
                        tiles: [
                          MySettingsTile(
                            title: 'Pick Image from Gallery',
                            leading: const Icon(
                                CupertinoIcons.photo_on_rectangle,
                                size: 20),
                            onTap: () {
                              context
                                  .read<OwnerGallaryBloc>()
                                  .add(PickGallaryEvent(isCamera: false));
                              Navigator.pop(context);
                            },
                          ),
                          MySettingsTile(
                            title: 'Take Photo from Camera',
                            leading: const Icon(CupertinoIcons.camera,
                                size: 20, color: Colors.blue),
                            leadingBackgroundColor:
                                Colors.blue.withValues(alpha:  0.1),
                            onTap: () {
                              context
                                  .read<OwnerGallaryBloc>()
                                  .add(PickGallaryEvent(isCamera: true));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
                containerWidget: (context, animation, child) => Material(
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        color: Theme.of(context).colorScheme.surface,
                        child: SafeArea(
                          top: false,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text("Add Photos"),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<OwnerGallaryBloc, OwnerGallaryState>(
          builder: (context, state) {
            if (state is OwnerGallaryImagesPicked) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _didChange();
              });
              _pickedImages = state.images;
              if (_pickedImages!.isNotEmpty) {
                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pickedImages?.length,
                    itemBuilder: (context, index) {
                      final image = _pickedImages![index];
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pickedImages!.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            }
            return Container();
          },
        ),
      ],
    );
  }
}
