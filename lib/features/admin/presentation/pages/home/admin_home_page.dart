import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/admin/presentation/widgets/admin_drawer.dart';
import 'package:uni_app/features/admin/presentation/widgets/admin_shop_tile.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<BarbershopBloc>().add(GetAllBarberShopsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home Page'),
      ),
      endDrawer: const AdminDrawer(),
      body: BlocConsumer<BarbershopBloc, BarbershopState>(
        listener: (context, state) {
          if (state is BarbershopError) {
            MyUtils.showSnackBar(context, state.message);
          } else if (state is BarbershopDeleted) {
            MyUtils.showSnackBar(context, 'Barbershop deleted');
          }
        },
        builder: (context, state) {
          if (state is BarbershopLoading) {
            return const Center(
              child: Loader(),
            );
          } else if (state is BarbershopLoaded) {
            return _shopsList(state.barbershops);
          } else if (state is BarbershopError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  Widget _shopsList(List<Barbershop> barbershops) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: barbershops.length,
      itemBuilder: (context, index) {
        final barbershop = barbershops[index];
        return AdminShopTile(
          barbershop: barbershop,
        );
      },
    );
  }
}
