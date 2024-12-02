import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/auth/presentation/widgets/my_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // controllers
  final TextEditingController _nameController = TextEditingController();

  MyUser? user;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthBloc>().currentUser;

    _nameController.text = user?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // profile image
            const Hero(
              tag: 'profile_image',
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
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
            MyTextField(
              controller: _nameController,
              hintText: 'Name',
            ),
          ],
        ),
      ),
    );
  }
}
