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
        "image": "assets/images/login.png",
        "title": "Alex Scott",
        "type": "Barber",
        "description": "Quick, professional haircuts that fit your schedule."
      },
      {
        "image": "assets/images/login.png",
        "title": "John Doe",
        "type": "Barber",
        "description": "Premium grooming with top trends and classic cuts."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Shops'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return _buildShopCard(
            image: shop["image"]!,
            title: shop["title"]!,
            type: shop["type"]!,
            description: shop["description"]!,
          );
        },
      ),
    );
  }

  // Widget for building each shop card
  Widget _buildShopCard({
    required String image,
    required String title,
    required String type,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            blurRadius: 6, // How blurry the shadow is
            offset: const Offset(0, 4), // Offset of the shadow
          ),
        ],
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
            child: Image.asset(
              image,
              width: 120,
              height: 120,
              fit: BoxFit.cover, // Ensures the image fits properly
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
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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
