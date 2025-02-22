import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/presentation/widgets/my_text_field.dart';
import 'package:uuid/uuid.dart';

class AddShopPage extends StatefulWidget {
  const AddShopPage({super.key});

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ownerIdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _ownerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shop'),
      ),
      body: BlocListener<BarbershopBloc, BarbershopState>(
        listener: (context, state) {
          if (state is BarbershopAdded) {
            Navigator.pop(context);

            // show snackbar
            MyUtils.showSnackBar(context, 'Shop added successfully');
          } else if (state is BarbershopError) {
            // show snackbar
            MyUtils.showSnackBar(context, state.message);
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 8,
                  children: [
                    // shop name
                    MyTextField(
                      controller: _nameController,
                      hintText: 'Shop Name',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter shop name';
                        }
                        return null;
                      },
                    ),

                    // shop address
                    MyTextField(
                      controller: _addressController,
                      hintText: 'Shop Address',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter shop address';
                        }
                        return null;
                      },
                    ),

                    // shop phone
                    MyTextField(
                      controller: _phoneController,
                      hintText: 'Shop Phone',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter shop phone';
                        }
                        return null;
                      },
                    ),

                    // owner ID
                    MyTextField(
                      controller: _ownerIdController,
                      hintText: 'Owner ID',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter owner ID';
                        }
                        return null;
                      },
                    ),

                    const Spacer(),

                    // submit button
                    MyButton(
                      child: Text(
                        'Add Shop',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // submit form
                          context.read<BarbershopBloc>().add(
                                AddBarbershopEvent(Barbershop(
                                  id: const Uuid().v4(),
                                  name: _nameController.text.trim(),
                                  address: _addressController.text.trim(),
                                  phoneNumber: _phoneController.text.trim(),
                                  ownerId: _ownerIdController.text.trim(),
                                  rating: 0,
                                  reviewCount: 0,
                                  services: [],
                                  barbers: [],
                                )),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
