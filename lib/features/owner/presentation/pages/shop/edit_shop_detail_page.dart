import 'package:flutter/material.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';

class EditShopDetailPage extends StatefulWidget {
  final Barbershop shop;
  const EditShopDetailPage({super.key, required this.shop});

  @override
  State<EditShopDetailPage> createState() => _EditShopDetailPageState();
}

class _EditShopDetailPageState extends State<EditShopDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildShopImage(),
        ],
      ),
    );
  }

  Widget _buildShopImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: widget.shop.imageUrl != null
          ? Image.network(
              widget.shop.imageUrl!,
              fit: BoxFit.cover,
            )
          : const SizedBox.shrink(),
    );
  }
}
