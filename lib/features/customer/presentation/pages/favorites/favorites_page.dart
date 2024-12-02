import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:uni_app/features/customer/presentation/bloc/favorite_shops/favorite_shops_bloc.dart';
import 'package:uni_app/features/customer/presentation/widgets/shop_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();

    // get user id
    final user = context.read<AuthBloc>().currentUser;

    // get favorite shops
    if (user != null) {
      context.read<FavoriteShopsBloc>().add(GetFavoriteShopsEvent(user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: _buildLoggedInView(context),
    );
  }

  Widget _buildLoggedInView(BuildContext context) {
    return BlocConsumer<FavoriteShopsBloc, FavoriteShopsState>(
      listener: (context, state) {
        if (state is FavoriteShopsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is FavoriteShopsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FavoriteShopsLoaded) {
          if (state.barbershops.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 40,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "There are no favorite shops.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              final user = context.read<AuthBloc>().currentUser;
              if (user != null) {
                context
                    .read<FavoriteShopsBloc>()
                    .add(GetFavoriteShopsEvent(user.id));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
        return const SizedBox.shrink();
      },
    );
  }
}
