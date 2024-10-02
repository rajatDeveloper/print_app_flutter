import 'package:flutter/material.dart';
import 'package:print_app/common/widgets/counter.dart';
import 'package:print_app/feature/print_cart/models/print_cart_model.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';
import 'package:provider/provider.dart';

class PrintCartCard extends StatefulWidget {
  final PrintCartModel printCartModel;
  const PrintCartCard({super.key, required this.printCartModel});

  @override
  State<PrintCartCard> createState() => _PrintCartCardState();
}

class _PrintCartCardState extends State<PrintCartCard> {
  int counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter = widget.printCartModel.quantity!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, provider, _) {
      return Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.only(bottom: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      // margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: getDeviceWidth(context) * 0.6,
                                child: Text(
                                    widget.printCartModel.product!.name!,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: getFontSize(
                                            16, getDeviceWidth(context)))),
                              ),
                              IconButton(
                                  onPressed: () {
                                    provider.removeTheProduct(
                                        context: context,
                                        id: widget.printCartModel.id!,
                                        isRemove: false);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.primary,
                                  ))
                            ],
                          ),
                          SizedBox(height: getDeviceHeight(context) * 0.005),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: getDeviceHeight(context) * 0.005),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //want to see only last two decimal degit with integrger part
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: Text(
                      "₹${widget.printCartModel.product!.price.toString()}",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: getFontSize(16, getDeviceWidth(context)),
                      ),
                    ),
                  ),

                  CounterBtn(
                      onTapData: (val) {
                        counter = val;
                        setState(() {});
                        provider.updateTheQuanity(
                            context: context,
                            id: widget.printCartModel.id!,
                            quantity: counter);
                      },
                      initialValue: counter),
                ],
              )
            ],
          ));
    });
  }
}
