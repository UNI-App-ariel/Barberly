import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/features/customer/presentation/widgets/shop_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<BarbershopBloc>().add(GetAllBarberShopsEvent(filterOutInactive: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Shops'),
        ),
        body: BlocConsumer<BarbershopBloc, BarbershopState>(
          listener: (context, state) {
            if (state is BarbershopError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is BarbershopLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is BarbershopLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RefreshIndicator.adaptive(
                  onRefresh: () async {
                    context
                        .read<BarbershopBloc>()
                        .add(GetAllBarberShopsEvent());
                  },
                  child: ListView.builder(
                    itemCount: state.barbershops.length,
                    itemBuilder: (context, index) {
                      final shop = state.barbershops[index];
                      return ShopCard(
                        shop: shop,
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }
}
