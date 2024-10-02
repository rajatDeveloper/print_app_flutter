import 'package:flutter/material.dart';
import 'package:print_app/common/widgets/custom_appbar.dart';
import 'package:print_app/feature/print_cart/widgets/product_card.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  static const routeName = '/product-view';
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      var provider = Provider.of<MainProvider>(context, listen: false);
      provider.getAllProduct(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Food Items'),
            Consumer<MainProvider>(builder: (context, provider, _) {
              if (provider.userProduct == null) {
                return SizedBox(
                  height: getDeviceHeight(context) * 0.4,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: const Icon(Icons.search),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.white),
                          ),
                        ),
                        onChanged: (val) {
                          provider.filterProducts(
                              val); // Let provider handle search
                        },
                      ),
                    ),
                    // Product List
                    provider.mainSearchedProduct != null &&
                            provider.mainSearchedProduct!.isNotEmpty
                        ? SizedBox(
                            height: getDeviceHeight(context) * 0.6,
                            child: ListView.builder(
                              itemCount:
                                  provider.mainSearchedProduct?.length ?? 0,
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  model: provider.mainSearchedProduct![index],
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Text('No products found'),
                          ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
