// import 'dart:collection';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
// import 'package:sixam_mart/features/order/controllers/order_controller.dart';
// import 'package:sixam_mart/features/order/domain/models/order_model.dart';
// import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
// import 'package:sixam_mart/helper/address_helper.dart';
// import 'package:sixam_mart/util/app_constants.dart';
// import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
// import 'package:sixam_mart/features/checkout/widgets/payment_failed_dialog.dart';
// import 'package:sixam_mart/features/wallet/widgets/fund_payment_dialog_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PaymentWebViewScreen extends StatefulWidget {
//   final OrderModel orderModel;
//   final bool isCashOnDelivery;
//   final String? addFundUrl;
//   final String paymentMethod;
//   final String guestId;
//   final String contactNumber;
//   final String? subscriptionUrl;
//   final int? storeId;
//   final bool? createAccount;
//   const PaymentWebViewScreen({super.key, required this.orderModel, required this.isCashOnDelivery, this.addFundUrl, required this.paymentMethod,
//     required this.guestId, required this.contactNumber, this.subscriptionUrl, this.storeId, this.createAccount = false});

//   @override
//   PaymentScreenState createState() => PaymentScreenState();
// }

// class PaymentScreenState extends State<PaymentWebViewScreen> {
//   late String selectedUrl;
//   bool _isLoading = true;
//   final bool _canRedirect = true;
//   double? _maximumCodOrderAmount;
//   PullToRefreshController? pullToRefreshController;
//   InAppWebViewController? webViewController;
//   final GlobalKey webViewKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();

//     if(widget.addFundUrl == '' && widget.addFundUrl!.isEmpty && widget.subscriptionUrl == '' && widget.subscriptionUrl!.isEmpty){
//       selectedUrl = '${AppConstants.baseUrl}/payment-mobile?customer_id=${widget.orderModel.userId == 0 ? widget.guestId : widget.orderModel.userId}&order_id=${widget.orderModel.id}&payment_method=${widget.paymentMethod}';
//     } else if(widget.subscriptionUrl != '' && widget.subscriptionUrl!.isNotEmpty){
//       selectedUrl = widget.subscriptionUrl!;
//     } else{
//       selectedUrl = widget.addFundUrl!;
//     }

//     _initData();
//   }

//   void _initData() async {
//     if(widget.addFundUrl == null  || (widget.addFundUrl != null && widget.addFundUrl!.isEmpty)){
//       for(ZoneData zData in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
//         for(Modules m in zData.modules!) {
//           if(m.id == Get.find<SplashController>().module!.id) {
//             _maximumCodOrderAmount = m.pivot!.maximumCodOrderAmount;
//             break;
//           }
//         }
//       }
//     }

//     pullToRefreshController = GetPlatform.isWeb || ![TargetPlatform.iOS, TargetPlatform.android].contains(defaultTargetPlatform) ? null : PullToRefreshController(
//       onRefresh: () async {
//         if (defaultTargetPlatform == TargetPlatform.android) {
//           webViewController?.reload();
//         } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
//           webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         _exitApp();
//       },
//       child: Scaffold(
//         backgroundColor: Theme.of(context).cardColor,
//         appBar: CustomAppBar(title: '', onBackPressed: () => _exitApp(), backButton: true),
//         body: Stack(
//           children: [
//             InAppWebView(
//               key: webViewKey,
//               initialUrlRequest: URLRequest(url: WebUri(selectedUrl)),
//               initialUserScripts: UnmodifiableListView<UserScript>([]),
//               pullToRefreshController: pullToRefreshController,
//               initialSettings: InAppWebViewSettings(
//                 isInspectable: kDebugMode,
//                 mediaPlaybackRequiresUserGesture: false,
//                 allowsInlineMediaPlayback: true,
//                 iframeAllow: "camera; microphone",
//                 iframeAllowFullscreen: true,
//               ),
//               onWebViewCreated: (controller) async {
//                 webViewController = controller;
//               },
//               onLoadStart: (controller, url) async {
//                 Get.find<OrderController>().paymentRedirect(
//                   url: url.toString(), canRedirect: _canRedirect, onClose: (){} ,
//                   addFundUrl: widget.addFundUrl, orderID: widget.orderModel.id.toString(), contactNumber: widget.contactNumber,
//                   subscriptionUrl: widget.subscriptionUrl, storeId: widget.storeId, createAccount: widget.createAccount!,
//                   guestId: widget.guestId,
//                 );
//                 setState(() {
//                   _isLoading = true;
//                 });
//               },
//               shouldOverrideUrlLoading: (controller, navigationAction) async {
//                 Uri uri = navigationAction.request.url!;
//                 if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
//                   if (await canLaunchUrl(uri)) {
//                     await launchUrl(uri, mode: LaunchMode.externalApplication);
//                     return NavigationActionPolicy.CANCEL;
//                   }
//                 }
//                 return NavigationActionPolicy.ALLOW;
//               },
//               onLoadStop: (controller, url) async {
//                 pullToRefreshController?.endRefreshing();
//                 setState(() {
//                   _isLoading = false;
//                 });
//                 Get.find<OrderController>().paymentRedirect(
//                   url: url.toString(), canRedirect: _canRedirect, onClose: (){} ,
//                   addFundUrl: widget.addFundUrl, orderID: widget.orderModel.id.toString(), contactNumber: widget.contactNumber,
//                   subscriptionUrl: widget.subscriptionUrl, storeId: widget.storeId, createAccount: widget.createAccount!,
//                   guestId: widget.guestId,
//                 );
//                 // _redirect(url.toString());
//               },
//               onProgressChanged: (controller, progress) {
//                 if (progress == 100) {
//                   pullToRefreshController?.endRefreshing();
//                 }
//                 // setState(() {
//                 //   _value = progress / 100;
//                 // });
//               },
//               onConsoleMessage: (controller, consoleMessage) {
//                 debugPrint(consoleMessage.message);
//               },
//             ),
//             _isLoading ? Center(
//               child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
//             ) : const SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool?> _exitApp() async {
//     if((widget.addFundUrl == null  || (widget.addFundUrl != null && widget.addFundUrl!.isEmpty)) || !Get.find<SplashController>().configModel!.digitalPaymentInfo!.pluginPaymentGateways!){
//       return Get.dialog(PaymentFailedDialog(
//         orderID: widget.orderModel.id.toString(),
//         orderAmount: widget.orderModel.orderAmount,
//         maxCodOrderAmount: _maximumCodOrderAmount,
//         orderType: widget.orderModel.orderType,
//         isCashOnDelivery: widget.isCashOnDelivery,
//         guestId: widget.guestId,
//       ));
//     }else{
//       return Get.dialog(FundPaymentDialogWidget(isSubscription: widget.subscriptionUrl != null && widget.subscriptionUrl!.isNotEmpty));
//     }

//   }

// }

// import 'dart:collection';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
// import 'package:sixam_mart/features/order/controllers/order_controller.dart';
// import 'package:sixam_mart/features/order/domain/models/order_model.dart';
// import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
// import 'package:sixam_mart/helper/address_helper.dart';
// import 'package:sixam_mart/util/app_constants.dart';
// import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
// import 'package:sixam_mart/features/checkout/widgets/payment_failed_dialog.dart';
// import 'package:sixam_mart/features/wallet/widgets/fund_payment_dialog_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PaymentWebViewScreen extends StatefulWidget {
//   final OrderModel orderModel;
//   final bool isCashOnDelivery;
//   final String? addFundUrl;
//   final String paymentMethod;
//   final String guestId;
//   final String contactNumber;
//   final String? subscriptionUrl;
//   final int? storeId;
//   final bool? createAccount;
//   const PaymentWebViewScreen({
//     super.key,
//     required this.orderModel,
//     required this.isCashOnDelivery,
//     this.addFundUrl,
//     required this.paymentMethod,
//     required this.guestId,
//     required this.contactNumber,
//     this.subscriptionUrl,
//     this.storeId,
//     this.createAccount = false,
//   });

//   @override
//   PaymentScreenState createState() => PaymentScreenState();
// }

// class PaymentScreenState extends State<PaymentWebViewScreen> {
//   late String selectedUrl;
//   bool _isLoading = true;
//   final bool _canRedirect = true;
//   double? _maximumCodOrderAmount;
//   PullToRefreshController? pullToRefreshController;
//   InAppWebViewController? webViewController;
//   final GlobalKey webViewKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();

//     // Improved logic for URL selection
//     if ((widget.addFundUrl == null || widget.addFundUrl!.isEmpty) &&
//         (widget.subscriptionUrl == null || widget.subscriptionUrl!.isEmpty)) {
//       selectedUrl =
//           '${AppConstants.baseUrl}/payment-mobile?customer_id=${widget.orderModel.userId == 0 ? widget.guestId : widget.orderModel.userId}&order_id=${widget.orderModel.id}&payment_method=${widget.paymentMethod}';
//     } else if (widget.subscriptionUrl != null &&
//         widget.subscriptionUrl!.isNotEmpty) {
//       selectedUrl = widget.subscriptionUrl!;
//     } else if (widget.addFundUrl != null && widget.addFundUrl!.isNotEmpty) {
//       selectedUrl = widget.addFundUrl!;
//     }

//     _initData();
//   }

//   void _initData() async {
//     if (widget.addFundUrl == null ||
//         (widget.addFundUrl != null && widget.addFundUrl!.isEmpty)) {
//       for (ZoneData zData
//           in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
//         for (Modules m in zData.modules!) {
//           if (m.id == Get.find<SplashController>().module!.id) {
//             _maximumCodOrderAmount = m.pivot!.maximumCodOrderAmount;
//             break;
//           }
//         }
//       }
//     }

//     pullToRefreshController = GetPlatform.isWeb ||
//             ![TargetPlatform.iOS, TargetPlatform.android]
//                 .contains(defaultTargetPlatform)
//         ? null
//         : PullToRefreshController(
//             onRefresh: () async {
//               if (defaultTargetPlatform == TargetPlatform.android) {
//                 webViewController?.reload();
//               } else if (defaultTargetPlatform == TargetPlatform.iOS ||
//                   defaultTargetPlatform == TargetPlatform.macOS) {
//                 webViewController?.loadUrl(
//                     urlRequest:
//                         URLRequest(url: await webViewController?.getUrl()));
//               }
//             },
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         _exitApp();
//       },
//       child: Scaffold(
//         backgroundColor: Theme.of(context).cardColor,
//         appBar: CustomAppBar(
//             title: '', onBackPressed: () => _exitApp(), backButton: true),
//         body: Stack(
//           children: [
//             // Modern styled WebView container
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: InAppWebView(
//                     key: webViewKey,
//                     initialUrlRequest: URLRequest(url: WebUri(selectedUrl)),
//                     // initialUserScripts: const [],
//                     initialUserScripts: UnmodifiableListView<UserScript>([]),

//                     pullToRefreshController: pullToRefreshController,
//                     initialSettings: InAppWebViewSettings(
//                       isInspectable: kDebugMode,
//                       mediaPlaybackRequiresUserGesture: false,
//                       allowsInlineMediaPlayback: true,
//                       iframeAllow: "camera; microphone",
//                       iframeAllowFullscreen: true,
//                     ),
//                     onWebViewCreated: (controller) async {
//                       webViewController = controller;
//                     },
//                     onLoadStart: (controller, url) async {
//                       Get.find<OrderController>().paymentRedirect(
//                         url: url.toString(),
//                         canRedirect: _canRedirect,
//                         onClose: () {},
//                         addFundUrl: widget.addFundUrl,
//                         orderID: widget.orderModel.id.toString(),
//                         contactNumber: widget.contactNumber,
//                         subscriptionUrl: widget.subscriptionUrl,
//                         storeId: widget.storeId,
//                         createAccount: widget.createAccount!,
//                         guestId: widget.guestId,
//                       );
//                       setState(() {
//                         _isLoading = true;
//                       });
//                     },
//                     shouldOverrideUrlLoading:
//                         (controller, navigationAction) async {
//                       Uri uri = navigationAction.request.url!;
//                       if (![
//                         "http",
//                         "https",
//                         "file",
//                         "chrome",
//                         "data",
//                         "javascript",
//                         "about"
//                       ].contains(uri.scheme)) {
//                         if (await canLaunchUrl(uri)) {
//                           await launchUrl(uri,
//                               mode: LaunchMode.externalApplication);
//                           return NavigationActionPolicy.CANCEL;
//                         }
//                       }
//                       return NavigationActionPolicy.ALLOW;
//                     },
//                     onLoadStop: (controller, url) async {
//                       pullToRefreshController?.endRefreshing();
//                       setState(() {
//                         _isLoading = false;
//                       });
//                       Get.find<OrderController>().paymentRedirect(
//                         url: url.toString(),
//                         canRedirect: _canRedirect,
//                         onClose: () {},
//                         addFundUrl: widget.addFundUrl,
//                         orderID: widget.orderModel.id.toString(),
//                         contactNumber: widget.contactNumber,
//                         subscriptionUrl: widget.subscriptionUrl,
//                         storeId: widget.storeId,
//                         createAccount: widget.createAccount!,
//                         guestId: widget.guestId,
//                       );
//                     },
//                     onProgressChanged: (controller, progress) {
//                       if (progress == 100) {
//                         pullToRefreshController?.endRefreshing();
//                       }
//                     },
//                     onConsoleMessage: (controller, consoleMessage) {
//                       debugPrint(consoleMessage.message);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             // Custom styled loading indicator
//             _isLoading
//                 ? Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                               Theme.of(context).primaryColor),
//                           strokeWidth: 5,
//                         ),
//                         SizedBox(height: 12),
//                         Text(
//                           "Processing your payment...",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool?> _exitApp() async {
//     if ((widget.addFundUrl == null ||
//             (widget.addFundUrl != null && widget.addFundUrl!.isEmpty)) ||
//         !Get.find<SplashController>()
//             .configModel!
//             .digitalPaymentInfo!
//             .pluginPaymentGateways!) {
//       return Get.dialog(PaymentFailedDialog(
//         orderID: widget.orderModel.id.toString(),
//         orderAmount: widget.orderModel.orderAmount,
//         maxCodOrderAmount: _maximumCodOrderAmount,
//         orderType: widget.orderModel.orderType,
//         isCashOnDelivery: widget.isCashOnDelivery,
//         guestId: widget.guestId,
//       ));
//     } else {
//       return Get.dialog(FundPaymentDialogWidget(
//           isSubscription: widget.subscriptionUrl != null &&
//               widget.subscriptionUrl!.isNotEmpty));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sixam_mart/features/order/domain/models/order_model.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool isCashOnDelivery;
  final String? addFundUrl;
  final String paymentMethod;
  final String guestId;
  final String contactNumber;
  final String? subscriptionUrl;
  final int? storeId;
  final bool? createAccount;

  const PaymentWebViewScreen({
    super.key,
    required this.orderModel,
    required this.isCashOnDelivery,
    this.addFundUrl,
    required this.paymentMethod,
    required this.guestId,
    required this.contactNumber,
    this.subscriptionUrl,
    this.storeId,
    this.createAccount = false,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late Razorpay _razorpay;
  bool _isPaymentSheetOpened = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openRazorpay();
    });
  }

  void _openRazorpay() {
    if (_isPaymentSheetOpened) return;
    _isPaymentSheetOpened = true;

    var options = {
      'key': 'rzp_live_5evlaBJT8aZamK', // TODO: Replace with your Razorpay key
      'amount': (widget.orderModel.orderAmount), // in paise
      'name': 'Pesito',
      'description': 'Order #${widget.orderModel.id}',
      'prefill': {
        'contact': widget.contactNumber,
        // 'email': widget.orderModel.user?.email ?? '',
      },
      // You can add 'order_id' from your backend for best security.
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay open error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to open payment: $e")),
      );
      Navigator.of(context).pop();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // TODO: Call your backend to verify payment & update order status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment successful! ID: ${response.paymentId}")),
    );
    Navigator.of(context).pop(); // Or navigate as needed
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed! Reason: ${response.message}")),
    );
    Navigator.of(context).pop();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External wallet selected: ${response.walletName}")),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Razorpay Payment"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 18),
            Text("Connecting to Razorpay...", style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
