/// The in-app purchase provider that processed a purchase.
enum IAPProvider {
  /// Google Play Billing.
  googlePlayBilling('google'),

  /// Apple App Store In-App Purchase.
  appleAppStore('apple'),

  /// Amazon Appstore In-App Purchasing.
  amazonAppstore('amazon'),

  /// Xsolla payment provider.
  xsolla('xsolla');

  /// Value for native SDK.
  final String value;

  /// Constructor
  const IAPProvider(this.value);
}

/// Information about an in-app purchase.
///
/// Along with the ad revenue tracking of the SDK, reporting purchases gives
/// a complete picture of a user total value in one place.
/// The total reported revenue is calculated as:
/// `quantity * price * currency_rate`
///
/// The product price, currency and quantity come from your product catalog,
/// the validation data comes from the completed transaction.
/// Report the purchase with `CASMobileAds.reportPurchase` as soon as the
/// transaction is confirmed.
///
/// Example with the [in_app_purchase](https://pub.dev/packages/in_app_purchase)
/// plugin, where `details` is a completed `PurchaseDetails` and `product`
/// is the `ProductDetails` it was bought from:
/// ```dart
/// final purchase = CASPurchaseInfo(
///   productId: details.productID,
///   price: product.rawPrice,
///   currency: product.currencyCode,
/// );
///
/// if (details is GooglePlayPurchaseDetails) {
///   final googlePurchase = details.billingClientPurchase;
///   purchase.setGoogleValidation(
///     originalJson: googlePurchase.originalJson,
///     signature: googlePurchase.signature,
///   );
///   if (isSubscription) {
///     purchase.setGoogleSubscription(
///       purchaseToken: googlePurchase.purchaseToken,
///       purchaseTime: googlePurchase.purchaseTime,
///     );
///   }
/// } else if (details is SK2PurchaseDetails) {
///   purchase.setAppleValidation(
///     transactionId: details.purchaseID,
///     jwsRepresentation: details.verificationData.serverVerificationData,
///   );
///   if (isSubscription) {
///     purchase.setAppleSubscription(
///       jsonRepresentation: details.verificationData.localVerificationData,
///     );
///   }
/// } else if (details is AppStorePurchaseDetails) {
///   // The quantity of a StoreKit 1 transaction is known:
///   // details.skPaymentTransaction.payment.quantity
///   purchase.setAppleValidation(
///     transactionId: details.skPaymentTransaction.transactionIdentifier,
///     receiptBase64: details.verificationData.localVerificationData,
///   );
///   if (isSubscription) {
///     purchase.setAppleSubscription();
///   }
/// }
///
/// await CASMobileAds.reportPurchase(purchase);
/// ```
///
/// StoreKit and Google Play Billing do not report whether a product is
/// a subscription on the transaction itself, so `isSubscription` above comes
/// from your own product catalog, for example
/// `product.productType == ProductType.subs` on Android or
/// `sk2Product.type == SK2ProductType.autoRenewable` on iOS.
class CASPurchaseInfo {
  /// Information about an in-app purchase.
  ///
  /// - [productId] - Product identifier from the IAP provider.
  /// - [price] - Price of one purchased item in the selected currency,
  /// for example `ProductDetails.rawPrice`.
  /// - [currency] - ISO 4217 currency code, for example USD or EUR,
  /// for example `ProductDetails.currencyCode`.
  /// - [quantity] - Number of items being purchased. Google Play Billing does
  /// not expose the purchased quantity through the `in_app_purchase` plugin,
  /// on StoreKit 1 it is `skPaymentTransaction.payment.quantity`.
  CASPurchaseInfo({
    required this.productId,
    required this.price,
    required this.currency,
    this.quantity = 1,
  })  : assert(productId.isNotEmpty, 'Product ID cannot be empty'),
        assert(price >= 0, 'Product price cannot be less than zero'),
        assert(quantity >= 1, 'Purchase quantity cannot be less than 1'),
        assert(currency.length == 3,
            'Invalid currency code. Supported ISO 4217 currency code only.');

  /// Product identifier from the IAP provider.
  final String productId;

  /// Price of one purchased item in the selected currency.
  final double price;

  /// ISO 4217 currency code, for example USD or EUR.
  final String currency;

  /// Number of items being purchased.
  final int quantity;

  IAPProvider? _provider;
  bool _isSubscription = false;
  String? _originalJson;
  String? _signature;
  String? _purchaseToken;
  int _purchaseTime = 0;
  String? _transactionId;
  String? _originalTransactionId;
  int _originalPurchaseDate = 0;
  String? _jwsRepresentation;
  String? _jsonRepresentation;
  String? _receiptBase64;
  String? _receiptId;
  String? _orderId;
  String? _userId;

  /// The provider that processed the purchase, defined by the applied
  /// validation data.
  ///
  /// `null` until one of the validation methods is called, in which case
  /// the store of the current platform is used.
  IAPProvider? get provider => _provider;

  /// Indicates that the purchased product is a subscription.
  bool get isSubscription => _isSubscription;

  /// Original purchase JSON returned by Google Play, or the Amazon IAP receipt.
  String? get originalJson => _originalJson;

  /// Google Play signature of the purchase data.
  String? get signature => _signature;

  /// Google Play subscription purchase token.
  String? get purchaseToken => _purchaseToken;

  /// Subscription purchase time in milliseconds since Unix epoch.
  int get purchaseTime => _purchaseTime;

  /// Transaction identifier from StoreKit.
  String? get transactionId => _transactionId;

  /// Original transaction identifier from StoreKit for subscription validation.
  String? get originalTransactionId => _originalTransactionId;

  /// Original purchase date in milliseconds since Unix epoch
  /// for subscription analytics.
  int get originalPurchaseDate => _originalPurchaseDate;

  /// Cryptographically signed by Apple JWS representation of the transaction.
  String? get jwsRepresentation => _jwsRepresentation;

  /// JSON representation of the StoreKit transaction.
  String? get jsonRepresentation => _jsonRepresentation;

  /// Base64 encoded binary StoreKit legacy app receipt.
  String? get receiptBase64 => _receiptBase64;

  /// Amazon receipt identifier.
  String? get receiptId => _receiptId;

  /// Xsolla order identifier.
  String? get orderId => _orderId;

  /// Original IAP user identifier.
  String? get userId => _userId;

  /// Adds Google Play purchase data required to validate the purchase,
  /// and marks this [CASPurchaseInfo] as coming from Google Play Billing.
  ///
  /// Validation data is optional, but it is recommended when available.
  ///
  /// - [originalJson] - Original purchase JSON returned by Google Play,
  /// `PurchaseWrapper.originalJson`.
  /// - [signature] - Signature returned by Google Play,
  /// `PurchaseWrapper.signature`.
  CASPurchaseInfo setGoogleValidation({
    String? originalJson,
    String? signature,
  }) {
    _provider = IAPProvider.googlePlayBilling;
    _originalJson = originalJson;
    _signature = signature;
    return this;
  }

  /// Marks the purchased product as a Google Play subscription and adds
  /// the data required to validate it.
  ///
  /// Call it in addition to [setGoogleValidation].
  ///
  /// - [purchaseToken] - Google Play purchase token,
  /// `PurchaseWrapper.purchaseToken`. Leave `null` to read the token from
  /// the original JSON.
  /// - [purchaseTime] - Subscription purchase time in milliseconds since
  /// Unix epoch, `PurchaseWrapper.purchaseTime`. Leave `0` to read the time
  /// from the original JSON.
  CASPurchaseInfo setGoogleSubscription({
    String? purchaseToken,
    int purchaseTime = 0,
  }) {
    _provider = IAPProvider.googlePlayBilling;
    _isSubscription = true;
    _purchaseToken = purchaseToken;
    _purchaseTime = purchaseTime;
    return this;
  }

  /// Adds App Store purchase data required to validate the purchase,
  /// and marks this [CASPurchaseInfo] as coming from the Apple App Store.
  ///
  /// Validation data is optional, but it is recommended when available.
  ///
  /// Pass [jwsRepresentation] for StoreKit 2 transactions and
  /// [receiptBase64] for StoreKit 1 transactions.
  ///
  /// - [transactionId] - Transaction identifier from StoreKit,
  /// `Transaction.id` or `SKPaymentTransaction.transactionIdentifier`.
  /// - [jwsRepresentation] - JWS representation of the transaction signed
  /// by Apple, `VerificationResult.jwsRepresentation`.
  /// - [receiptBase64] - Base64 encoded binary app receipt from
  /// `Bundle.main.appStoreReceiptURL`.
  CASPurchaseInfo setAppleValidation({
    String? transactionId,
    String? jwsRepresentation,
    String? receiptBase64,
  }) {
    _provider = IAPProvider.appleAppStore;
    _transactionId = transactionId;
    _jwsRepresentation = jwsRepresentation;
    _receiptBase64 = receiptBase64;
    return this;
  }

  /// Marks the purchased product as an App Store subscription and adds
  /// the data required to validate it.
  ///
  /// Call it in addition to [setAppleValidation]. When the arguments are not
  /// available, call it without them and the SDK reads the subscription data
  /// from the current StoreKit entitlement of the product, which requires
  /// iOS 16.0 or higher.
  ///
  /// - [originalTransactionId] - Original transaction identifier,
  /// `Transaction.originalID`.
  /// - [originalPurchaseDate] - Original purchase date in milliseconds since
  /// Unix epoch, `Transaction.originalPurchaseDate`.
  /// - [jsonRepresentation] - JSON representation of the transaction,
  /// `Transaction.jsonRepresentation`.
  CASPurchaseInfo setAppleSubscription({
    String? originalTransactionId,
    int originalPurchaseDate = 0,
    String? jsonRepresentation,
  }) {
    _provider = IAPProvider.appleAppStore;
    _isSubscription = true;
    _originalTransactionId = originalTransactionId;
    _originalPurchaseDate = originalPurchaseDate;
    _jsonRepresentation = jsonRepresentation;
    return this;
  }

  /// Adds the required receipt ID and user ID data to validate an Amazon
  /// Appstore purchase, and marks this [CASPurchaseInfo] as coming from
  /// the Amazon Appstore.
  ///
  /// The publisher is responsible for supplying the purchase price, currency
  /// and quantity values, for example from their own product catalog, to
  /// ensure revenue is reported accurately.
  ///
  /// - [receiptId] - Amazon receipt identifier from the Amazon IAP receipt.
  /// - [userId] - Amazon user identifier.
  CASPurchaseInfo setAmazonValidation({
    required String receiptId,
    String? userId,
  }) {
    _provider = IAPProvider.amazonAppstore;
    _receiptId = receiptId;
    _userId = userId;
    return this;
  }

  /// Adds the Amazon IAP receipt required to validate the purchase, and marks
  /// this [CASPurchaseInfo] as coming from the Amazon Appstore.
  ///
  /// The receipt ID and the user ID are read from the receipt.
  ///
  /// - [receipt] - JSON string of the Amazon IAP receipt.
  CASPurchaseInfo setAmazonValidationFromReceipt(String receipt) {
    _provider = IAPProvider.amazonAppstore;
    _originalJson = receipt;
    return this;
  }

  /// Adds the required order ID data to validate an Xsolla purchase,
  /// and marks this [CASPurchaseInfo] as coming from Xsolla.
  ///
  /// - [orderId] - Xsolla order identifier.
  /// - [userId] - Xsolla user identifier.
  CASPurchaseInfo setXsollaValidation({
    required String orderId,
    String? userId,
  }) {
    _provider = IAPProvider.xsolla;
    _orderId = orderId;
    _userId = userId;
    return this;
  }

  @override
  String toString() => 'Purchased $productId for $price $currency';
}
