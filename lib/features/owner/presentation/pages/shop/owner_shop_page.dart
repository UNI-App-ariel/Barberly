import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';

class OwnerShopPage extends StatelessWidget {
  const OwnerShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OwnerShopBloc, OwnerShopState>(
        listener: (context, state) {
          if (state is OwnerShopError) {
            MyUtils.showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is OwnerShopLoading) {
            return const Center(
              child: Loader(),
            );
          } else if (state is OwnerShopLoaded) {
            return _buildShop(state.shop);
          } else {
            return const Center(
              child: Text('No shop found'),
            );
          }
        },
      ),
    );
  }

  Widget _buildShop(Barbershop shop) {
    return Column(
      children: [
        shop.imageUrl != null
            ? CachedNetworkImage(imageUrl: shop.imageUrl!)
            : const SizedBox.shrink(),
      ],
    );
  }
}
