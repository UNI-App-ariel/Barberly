import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/customer/presentation/widgets/booking_sheet.dart';
import 'package:uni_app/features/customer/presentation/widgets/shop_details_chip.dart';

class ShopDetailsPage extends StatefulWidget {
  final Barbershop shop;

  const ShopDetailsPage({super.key, required this.shop});

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  int selectedChipIndex = 0;
  MyUser ? user;
  DateTime ? _selectedDate;
  String ? _selectedTimeSlot;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImage(),
              // title: Text(widget.shop.name),
            ),
            leading: IconButton(
              icon: _buildBackButton(context),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(110),
            //   // child: _buildInfoContainer(widget.shop),
            // ),
            actions: [
              _buildFavoriteButton(true),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildChips(),
                const SizedBox(height: 20),
                _buildSheet(selectedChipIndex),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (widget.shop.imageUrl == null) {
      return Center(
        child: Icon(
          Icons.store,
          size: 50,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: widget.shop.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Icon(
          Icons.image,
          size: 50,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          size: 50,
        ),
      );
    }
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const FaIcon(
        FontAwesomeIcons.arrowLeft,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildFavoriteButton(bool isFavorite) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: FaIcon(
          isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: isFavorite ? Colors.red : Colors.white,
          size: 20,
        ),
      ),
      onPressed: () {
        setState(() {
          // isFavorite
          //     ? context
          //         .read<FavoritesBloc>()
          //         .add(RemoveFavoritesEvent(user!.uid, widget.shop.id))
          //     : context
          //         .read<FavoritesBloc>()
          //         .add(AddFavoritesEvent(user!.uid, widget.shop.id));
        });
      },
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyChip(
            label: 'Booking',
            isSelected: selectedChipIndex == 0,
            onTap: () => setState(() => selectedChipIndex = 0),
          ),
          const SizedBox(width: 10),
          MyChip(
            label: 'Gallery',
            isSelected: selectedChipIndex == 1,
            onTap: () => setState(() => selectedChipIndex = 1),
          ),
          // TODO: Implement RateSheet
          // const SizedBox(width: 10),
          // MyChip(
          //   label: 'Rate',
          //   isSelected: selectedChipIndex == 2,
          //   onTap: () => setState(() => selectedChipIndex = 2),
          // ),
        ],
      ),
    );
  }

  Widget _buildSheet(int selectedChipIndex) {
    switch (selectedChipIndex) {
      case 0:
        return BookingSheet(
          user: user,
          shop: widget.shop,
          onSelectionChange: ({
            required buttonState,
            required selectedDate,
            required selectedTimeSlot,
          }) {
            setState(() {
             
            });
          },
        );
      case 1:
      // return GallerySheet(
      //   images: widget.shop.galleryImages,
      //   shopId: widget.shop.id,
      // );
      case 2:
      // return const RateSheet();
      default:
        return const SizedBox();
    }
  }
}
