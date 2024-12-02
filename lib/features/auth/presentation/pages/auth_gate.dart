import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/auth/presentation/pages/login_or_signup.dart';
import 'package:uni_app/features/customer/presentation/pages/navigation_bar_page.dart';
import 'package:uni_app/features/owner/presentation/pages/owner_nav_bar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          MyUtils.showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is Authenticated) {
          if (state.user.role == 'customer') {
            return const NavigationBarPage();
          } else if (state.user.role == 'owner') {
            return const OwnerNavigationBar();
          } else {
            return const NavigationBarPage();
          }
        } else if (state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const LoginOrSignup();
        }
      },
    );
  }
}
