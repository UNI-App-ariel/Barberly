import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/presentation/widgets/my_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isChanged = false;
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
    if (_nameController.text.trim() != user?.name) {
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
            return const Loader();
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
          context.read<AppUserBloc>().add(UpdateUserEvent(newUser));
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
          Hero(
            tag: 'profile_image',
            child: CircleAvatar(
              radius: 50,
              backgroundImage: user != null && user!.photoUrl != null
                  ? CachedNetworkImageProvider(user!.photoUrl!)
                  : null,
              child: user == null || user?.photoUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 50,
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 20),
          // edit image button
          MyButton(
            borderRadius: 30,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            onPressed: () {},
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
}
