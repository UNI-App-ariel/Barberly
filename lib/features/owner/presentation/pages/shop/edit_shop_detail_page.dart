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
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';

class EditShopDetailPage extends StatefulWidget {
  const EditShopDetailPage({super.key, required});

  @override
  State<EditShopDetailPage> createState() => _EditShopDetailPageState();
}

class _EditShopDetailPageState extends State<EditShopDetailPage> {
  bool _isChanged = false;
  late Barbershop? _shop;
  File? _pickedImage;

  // text editing controllers
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

    // add listener to shop name controller
    _shopNameController.addListener(_didChange);
    _addressController.addListener(_didChange);
    _phoneController.addListener(_didChange);
  }

  void _didChange() {
    // check if all fields changed
    if (_shopNameController.text.trim() != _shop?.name ||
        _addressController.text.trim() != _shop?.address ||
        _phoneController.text.trim() != _shop?.phoneNumber ||
        _pickedImage != null) {
      setState(() {
        _isChanged = true;
      });
    } else {
      setState(() {
        _isChanged = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _shopNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Detail'),
        actions: [
          _buildSaveButton(context),
        ],
      ),
      body: BlocConsumer<OwnerShopBloc, OwnerShopState>(
        listener: (context, state) {
          if (state is OwnerShopError) {
            MyUtils.showErrorSnackBar(context, state.message);
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
                child: Column(
                  children: [
                    _buildShopImage(),
                    const SizedBox(height: 20),
                    _buildShopNameField(),
                    const SizedBox(height: 10),
                    _buildAddressField(),
                    const SizedBox(height: 10),
                    _buildPhoneField(),
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

  Widget _buildSaveButton(BuildContext context) {
    if (!_isChanged) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        if (_shop == null) return;
        final shop = _shop!.copyWith(
          name: _shopNameController.text.trim(),
          address: _addressController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          imgaeFile: _pickedImage,
        );
        context.read<OwnerShopBloc>().add(UpdateShopEvent(shop));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
          ),
        ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // title
                Text(
                  'Choose Image Source',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SettingsListContainer(
                  tiles: [
                    // pick image from gallery
                    MySettingsTile(
                      title: 'Pick Image from Gallery',
                      leading: const Icon(
                        CupertinoIcons.photo_on_rectangle,
                        size: 20,
                      ),
                      onTap: () {
                        context.read<OwnerShopBloc>().add(PickShopImageEvent());
                        Navigator.pop(context);
                      },
                    ),

                    // remove image
                    MySettingsTile(
                      title: 'Remove Image',
                      leading: const Icon(
                        CupertinoIcons.trash,
                        size: 20,
                        color: Colors.red,
                      ),
                      leadingBackgroundColor: Colors.red.withOpacity(0.1),
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

        // context.read<OwnerShopBloc>().add(PickShopImageEvent());
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        color: Theme.of(context).colorScheme.secondary,
        child: _getImage(),
      ),
    );
  }

  Widget _getImage() {
    if (_pickedImage != null) {
      return Image.file(
        _pickedImage!,
        fit: BoxFit.cover,
      );
    } else if (_shop?.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: _shop!.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: Loader()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
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

  _buildShopNameField() {
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

  _buildAddressField() {
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

  _buildPhoneField() {
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
}
