import 'package:flutter/material.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/features/customer/presentation/pages/home/shop_details_page.dart';

class ShopCard extends StatelessWidget {
  final Barbershop shop;

  const ShopCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShopDetailsPage(shop: shop),
        ),
      ); },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                child: shop.imageUrl == null
                    ? const SizedBox(
                        width: 120,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 48,
                          ),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          shop.imageUrl!,
                          fit: BoxFit.cover, // Ensures the image fits properly
                        ),
                      ),
              ),
            ),
            // Text Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Barbershop",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop.phoneNumber,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
