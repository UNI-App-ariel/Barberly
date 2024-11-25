import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the list
    final List<Map<String, String>> shops = [
      {
        "image": "assets/images/barber0.png",
        "title": "Quan's Barber Shop",
        "type": "Barber",
        "description":
            "Step into Glamour Grove for expert styling, color, and care."
      },
      {
        "image": "assets/images/barber1.png",
        "title": "Lance Stewart",
        "type": "Barber",
        "description":
            "Get sharp, modern cuts and traditional styles at their finest."
      },
      {
        "title": "Alex Scott",
        "type": "Barber",
        "description": "Quick, professional haircuts that fit your schedule."
      },
      {
        "title": "John Doe",
        "type": "Barber",
        "description": "Premium grooming with top trends and classic cuts."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Shops'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return ShopCard(
            image: shop["image"],
            title: shop["title"]!,
            type: shop["type"]!,
            description: shop["description"]!,
          );
        },
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  final String? image;
  final String title;
  final String type;
  final String description;

  const ShopCard({
    super.key,
    this.image,
    required this.title,
    required this.type,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: image == null
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
                      child: Image.asset(
                        image!,
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
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
    );
  }
}
