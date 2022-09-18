// // ignore_for_file: avoid_function_literals_in_foreach_calls

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
// import '/controllers/subscription_controller.dart';
// import '/views/dialogs/no_restore_products.dart';
// import 'package:get/get.dart';
// import '/controllers/setting_controller.dart';
// import '/utils/helpers.dart';

// class InAppPurchaseService {
//   InAppPurchaseService._();

//   static int _numLoadAttempts = 3;
//   static SettingController settingController = Get.find();
//   static SubscriptionController subscriptionController = Get.find();
//   static late StreamSubscription purchaseUpdatedSubscription;
//   static late StreamSubscription purchaseErrorSubscription;
//   static late StreamSubscription conectionSubscription;

//   static Future<void> init() async {
//     if (!Platform.isIOS) return;
//     var result = await FlutterInappPurchase.instance.initialize();
//     dd('result: $result');
//     try {
//       String msg = await FlutterInappPurchase.instance.consumeAll();
//       dd('consumeAllItems: $msg');
//     } catch (err) {
//       dd('consumeAllItems error: $err');
//     }

//     conectionSubscription =
//         FlutterInappPurchase.connectionUpdated.listen((connected) {
//       dd('connected: $connected');
//     });

//     purchaseUpdatedSubscription =
//         FlutterInappPurchase.purchaseUpdated.listen((purchasedItem) {
//       _handlePurchaseUpdate(purchasedItem!);
//     });

//     purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//       dd('purchase-error: $purchaseError');

//       showToast(purchaseError?.message ?? '');

//       subscriptionController.isLoading.value = false;
//     });
//   }

//   static Future getProducts(List<String> productIds) async {
//     List<IAPItem> items =
//         await FlutterInappPurchase.instance.getSubscriptions(productIds);
//     for (var item in items) {
//       subscriptionController.products.add(item);
//     }

//     if (items.isEmpty && _numLoadAttempts > 0) {
//       getProducts(productIds);
//       _numLoadAttempts--;
//     }
//   }

//   static requestPurchase(IAPItem item) {
//     FlutterInappPurchase.instance.requestPurchase(item.productId!);
//   }

//   static requestRestore() async {
//     try {
//       List<PurchasedItem> purchasedItems =
//           await FlutterInappPurchase.instance.getAvailablePurchases() ?? [];

//       for (var purchasedItem in purchasedItems) {
//         bool isValid = false;

//         if (Platform.isAndroid) {
//           Map map = json.decode(purchasedItem.transactionReceipt!);
//           if (!map['acknowledged']) {
//             isValid = await _verifyPurchase(purchasedItem);
//             if (isValid) {
//               FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//               settingController.isSubscribed.value = true;
//             }
//           } else {
//             settingController.isSubscribed.value = true;
//           }
//         }
//       }

//       if (purchasedItems.isEmpty) {
//         noRestoreProductsDialog();
//       } else {
//         subscriptionController
//             .subscriptionRestore(purchasedItems[0].productId!);
//       }
//     } catch (e) {
//       subscriptionController.isLoading2.value = false;
//     }
//   }

//   static void _handlePurchaseUpdate(PurchasedItem productItem) async {
//     dd('purchase-updated: $productItem');
//     if (Platform.isAndroid) {
//       await _handlePurchaseUpdateAndroid(productItem);
//     } else {
//       await _handlePurchaseUpdateIOS(productItem);
//     }
//   }

//   static Future<void> _handlePurchaseUpdateIOS(
//       PurchasedItem purchasedItem) async {
//     switch (purchasedItem.transactionStateIOS) {
//       case TransactionState.deferred:
//         break;
//       case TransactionState.failed:
//         showToast("Transaction Failed");
//         FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//         break;
//       case TransactionState.purchased:
//         await _verifyAndFinishTransaction(purchasedItem);
//         break;
//       case TransactionState.purchasing:
//         break;
//       case TransactionState.restored:
//         FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//         break;
//       default:
//     }
//   }

//   static Future<void> _handlePurchaseUpdateAndroid(
//       PurchasedItem purchasedItem) async {
//     switch (purchasedItem.purchaseStateAndroid) {
//       case PurchaseState.purchased:
//         if (!purchasedItem.isAcknowledgedAndroid!) {
//           await _verifyAndFinishTransaction(purchasedItem);
//         }
//         break;
//       case PurchaseState.pending:
//         if (!purchasedItem.isAcknowledgedAndroid!) {
//           await _verifyAndFinishTransaction(purchasedItem);
//         }
//         break;
//       default:
//         showToast("Transaction Failed");
//     }
//   }

//   static _verifyAndFinishTransaction(PurchasedItem purchasedItem) async {
//     bool isValid = false;
//     try {
//       isValid = await _verifyPurchase(purchasedItem);
//     } on Exception {
//       showToast("Something went wrong");
//       return;
//     }

//     if (isValid) {
//       FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//       subscriptionController.subscriptionUpdate(purchasedItem);
//     } else {
//       showToast("Varification failed");
//     }
//   }

//   static checkSubscribed(bool status) async {
//     if (Platform.isIOS) {
//       settingController.isSubscribed.value = status;
//     } else {
//       List<PurchasedItem>? purchasedItems =
//           await FlutterInappPurchase.instance.getAvailablePurchases() ?? [];

//       for (var purchasedItem in purchasedItems) {
//         bool isValid = false;

//         if (Platform.isAndroid) {
//           Map map = json.decode(purchasedItem.transactionReceipt!);
//           if (!map['acknowledged']) {
//             isValid = await _verifyPurchase(purchasedItem);
//             if (isValid) {
//               FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//               settingController.isSubscribed.value = true;
//             }
//           } else {
//             settingController.isSubscribed.value = true;
//           }
//           if (!settingController.isSubscribed.value) {
//             subscriptionController.subscriptionExpired();
//           }
//         }
//       }
//     }
//   }

//   static Future<bool> _verifyPurchase(purchasedItem) {
//     return Future.value(true);
//   }
// }
