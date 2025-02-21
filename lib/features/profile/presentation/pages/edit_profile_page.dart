import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/presentation/widgets/my_text_field.dart';
import 'package:uni_app/features/profile/presentation/bloc/pfp/pfp_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isChanged = false;
  File? _pfp;

  // controllers
  final TextEditingController _nameController = TextEditingController();

  MyUser? user;

  @override
  void initState() {
    super.initState();
    user = context.read<AppUserBloc>().currentUser;

    _nameController.text = user?.name ?? '';

    // add listener to name controller
    _nameController.addListener(_didChange);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  void _didChange() {
    if (_nameController.text.trim() != user?.name || _pfp != null) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: BlocConsumer<AppUserBloc, AppUserState>(
        listener: (context, state) {
          if (state is AppUserError) {
            MyUtils.showErrorSnackBar(context, state.message);
          } else if (state is AppUserUpdated) {
            MyUtils.showSnackBar(context, 'Profile updated successfully');
            Navigator.pop(context);
            setState(() {
              user = context.read<AppUserBloc>().currentUser;
              _isChanged = false;
            });
          }
        },
        builder: (context, state) {
          if (state is AppUserLoaded) {
            return _buildContent();
          } else if (state is AppUserLoading) {
            return const Center(child: Loader());
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  _buildSaveButton() {
    if (_isChanged) {
      return GestureDetector(
        onTap: () {
          if (user == null) return;
          final newUser = user!.copyWith(name: _nameController.text);

          context
              .read<AppUserBloc>()
              .add(UpdateUserEvent(user: newUser, pfp: _pfp));
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // profile image
          BlocListener<PfpBloc, PfpState>(
            listener: (context, state) {
              if (state is PfpLoaded) {
                setState(() {
                  _pfp = state.image;
                });

                _didChange();
              }
            },
            child: _buildPfp(_pfp),
          ),

          const SizedBox(height: 20),

          // edit image button
          Visibility(
            visible: user != null && user?.accountType == 'email',
            child: MyButton(
              borderRadius: 30,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              onPressed: () {
                MyUtils.showImagePicker(
                  context: context,
                  onPickImageFromGallery: () {
                    context.read<PfpBloc>().add(PickImageFromGallery());
                  },
                  onPickImageFromCamera: () {
                    context.read<PfpBloc>().add(PickImageFromCamera());
                  },
                  showRemoveButton: _pfp != null,
                  onRemoveImage: () {
                    setState(() {
                      _pfp = null;
                    });
                    _didChange();
                  },
                );
              },
              child: Text(
                'Edit Image',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // name
          Row(
            children: [
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          MyTextField(
            controller: _nameController,
            hintText: 'Name',
          ),
        ],
      ),
    );
  }

  Hero _buildPfp(File? pfp) {
    // image
    dynamic image;
    if (pfp != null) {
      image = FileImage(pfp);
    } else {
      image = user != null && user!.photoUrl != null
          ? CachedNetworkImageProvider(user!.photoUrl!)
          : null;
    }

    // child
    Widget? child;
    if (user == null || user?.photoUrl == null && pfp == null) {
      child = const Icon(
        Icons.person,
        size: 50,
      );
    } else {
      child = null;
    }

    return Hero(
      tag: 'profile_image',
      transitionOnUserGestures: true,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: image,
        child: child,
      ),
    );
  }
}
