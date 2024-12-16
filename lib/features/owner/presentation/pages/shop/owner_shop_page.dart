import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';
import 'package:uni_app/features/owner/presentation/pages/shop/edit_shop_detail_page.dart';

class OwnerShopPage extends StatefulWidget {
  const OwnerShopPage({super.key});

  @override
  State<OwnerShopPage> createState() => _OwnerShopPageState();
}

class _OwnerShopPageState extends State<OwnerShopPage> {
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
            return _buildShopWithSlivers(state.shop);
          } else {
            return const Center(
              child: Text('No shop found'),
            );
          }
        },
      ),
    );
  }

  Widget _buildShopWithSlivers(Barbershop shop) {
    return CustomScrollView(
      slivers: [
        // Sliver AppBar with shop image
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.3,
          flexibleSpace: FlexibleSpaceBar(
            background: shop.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: shop.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
          ),
          pinned: true, // Keeps the app bar visible at the top
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MyButton(
                borderRadius: 30,
                backgroundColor: Colors.grey.withOpacity(0.5),
                onPressed: () {
                  // Navigate to edit profile page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditShopDetailPage(
                        shop: shop,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Edit Shop',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        // SliverList for shop content
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _buildShopDetails(shop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShopDetails(Barbershop shop) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                shop.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              // Rating Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Rating Text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${shop.rating}', // Rating
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Add color explicitly
                          ),
                        ),
                        TextSpan(
                          text: ' (${shop.reviewCount})', // Review count
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Star Icon
                  const Align(
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
