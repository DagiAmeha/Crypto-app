import 'package:crypto_app/Controller/provider/crypto_provider.dart';
import 'package:crypto_app/Controller/provider/graph_provider.dart';
import 'package:crypto_app/Model/crypto_data_model.dart';
import 'package:crypto_app/Model/crypto_graph_data_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpecificCryptoScreen extends StatefulWidget {
  const SpecificCryptoScreen({super.key, required this.cryptoId});
  final String cryptoId;

  @override
  State<SpecificCryptoScreen> createState() => _SpecificCryptoScreenState();
}

class _SpecificCryptoScreenState extends State<SpecificCryptoScreen> {
  List<String> timePeriod = ['1D', '5D', '1M', '1Y'];
  String selectedTimePeriod = '1D';
  TrackballBehavior trackBallBehaviour = TrackballBehavior(enable: true);
  CrosshairBehavior crosshairBehaviour = CrosshairBehavior(enable: true);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoProvider>().fetchCryptoById(widget.cryptoId);
      context.read<GraphProvider>().fetchCryptoGraph(widget.cryptoId, 1);
    });
    super.initState();
  }

  getCryptoDataTitle(int index) {
    switch (index) {
      case 0:
        return '% change 24HR';
      case 1:
        return '\$ change 24HR';
      case 2:
        return 'Price';
      case 3:
        return 'Market Cap';
      case 4:
        return '24HR Low';
      case 5:
        return '24HR High';
      case 6:
        return 'ATL';
      case 7:
        return 'ATH';
    }
  }

  getCryptoDateValue(CryptoDataModel crypto, int index) {
    switch (index) {
      case 0:
        return crypto.priceChangePercentage24!.toStringAsFixed(2);
      case 1:
        return crypto.priceChange24!.toStringAsFixed(2);
      case 2:
        return crypto.currentPrice!.toStringAsFixed(2);
      case 3:
        return crypto.marketCap!.toString();
      case 4:
        return crypto.low24!.toStringAsFixed(2);
      case 5:
        return crypto.high24!.toStringAsFixed(2);
      case 6:
        return crypto.atl!.toStringAsFixed(2);
      case 7:
        return crypto.ath!.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoProvider>(
      builder: (context, cryptoData, child) {
        if (cryptoData.fetchingCurrentCrypto == true) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ],

              title: Row(
                children: [
                  CircleAvatar(
                    child: Image.network(cryptoData.currentCrypto.image!),
                  ),
                  SizedBox(width: 2.w),

                  Text(
                    cryptoData.currentCrypto.name!,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            body: ListView(
              children: [
                CryptoChart(context),
                SizedBox(height: 2.h),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 2.h,
                  ),
                  itemCount: 8,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: index % 2 == 0
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Text(
                          getCryptoDataTitle(index),
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Column CryptoChart(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 25.h,
          child: Consumer<GraphProvider>(
            builder: (context, graphProvider, child) {
              return SfCartesianChart(
                trackballBehavior: trackBallBehaviour,
                crosshairBehavior: crosshairBehaviour,
                primaryXAxis: DateTimeAxis(
                  isVisible: false,
                  borderColor: Colors.transparent,
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compact(),
                  isVisible: false,
                ),
                plotAreaBorderWidth: 0,
                series: <AreaSeries>[
                  AreaSeries<CryptoGraphDataModel, dynamic>(
                    enableTooltip: true,
                    color: Colors.transparent,
                    borderColor: const Color(0xff1ab7c3),
                    borderWidth: 2,
                    dataSource: graphProvider.graphPoints,
                    xValueMapper: (CryptoGraphDataModel graphPoint, index) =>
                        graphPoint.date,
                    yValueMapper: (CryptoGraphDataModel graphPoint, index) =>
                        graphPoint.price,
                  ),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: timePeriod
              .map(
                (commonWidget) => InkWell(
                  onTap: () {
                    String time = commonWidget;
                    switch (time) {
                      case "1D":
                        context.read<GraphProvider>().fetchCryptoGraph(
                          widget.cryptoId,
                          1,
                        );
                        setState(() {
                          selectedTimePeriod = '1D';
                        });
                        break;
                      case "5D":
                        context.read<GraphProvider>().fetchCryptoGraph(
                          widget.cryptoId,
                          5,
                        );
                        setState(() {
                          selectedTimePeriod = '5D';
                        });
                        break;
                      case "1M":
                        context.read<GraphProvider>().fetchCryptoGraph(
                          widget.cryptoId,
                          30,
                        );
                        setState(() {
                          selectedTimePeriod = '1D';
                        });
                        break;
                      case "1Y":
                        context.read<GraphProvider>().fetchCryptoGraph(
                          widget.cryptoId,
                          365,
                        );
                        setState(() {
                          selectedTimePeriod = '1Y';
                        });
                        break;
                      default:
                        context.read<GraphProvider>().fetchCryptoGraph(
                          widget.cryptoId,
                          1,
                        );
                        setState(() {
                          selectedTimePeriod = '1D';
                        });
                        break;
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: selectedTimePeriod == commonWidget
                          ? Colors.white12
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.sp),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Text(
                      commonWidget,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
