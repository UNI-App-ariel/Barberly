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
      key: const Key('shop_card'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShopDetailsPage(shop: shop),
          ),
        );
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(4, 0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                            fit:
                                BoxFit.cover, // Ensures the image fits properly
                          ),
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
                    // Shop Name
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Shop Type
                    const Text(
                      "Barbershop",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Shop Address
                    Row(
                      children: [
                        // Icon
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        // Text
                        Text(
                          shop.address ?? 'No Address',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Shop Phone Number
                    Row(
                      children: [
                        // Icon
                        const Icon(
                          Icons.phone,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        // Text
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
