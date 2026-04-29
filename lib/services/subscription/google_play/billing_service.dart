import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../subscription_api.dart';
import 'billing_errors.dart';
import 'subscription_product.dart';

class GooglePlayBillingService {
  GooglePlayBillingService({InAppPurchase? inAppPurchase})
    : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  final InAppPurchase _inAppPurchase;

  bool get isSupported => Platform.isAndroid;
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _inAppPurchase.purchaseStream;

  Future<List<GooglePlaySubscriptionProduct>> loadSubscriptionProducts({
    bool monthlyIntroOfferEligible = false,
  }) async {
    if (!isSupported) {
      return const [];
    }

    final available = await _isGooglePlayBillingAvailable();
    if (!available) {
      throw const GooglePlayBillingException(
        'Google Play Billing não está disponível neste dispositivo.',
      );
    }

    final response = await _inAppPurchase.queryProductDetails(
      googlePlaySubscriptionProductIds,
    );
    if (response.error != null) {
      throw GooglePlayBillingException(
        response.error!.message.isEmpty
            ? 'Não foi possível carregar os planos do Google Play.'
            : response.error!.message,
      );
    }

    return _selectSubscriptionProducts(
      response,
      monthlyIntroOfferEligible: monthlyIntroOfferEligible,
    );
  }

  Future<bool> buySubscription(
    GooglePlaySubscriptionProduct product, {
    String? applicationUserName,
  }) {
    return _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(
        productDetails: product.details,
        applicationUserName: applicationUserName,
      ),
    );
  }

  Future<void> restorePurchases({String? applicationUserName}) {
    return _inAppPurchase.restorePurchases(
      applicationUserName: applicationUserName,
    );
  }

  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  Future<void> openSubscriptionManagement({String? productId}) async {
    if (!isSupported) {
      return;
    }

    final normalizedProductId = _normalizeManagementProductId(productId);
    final query = <String, String>{
      if (normalizedProductId != null && normalizedProductId.isNotEmpty)
        'sku': normalizedProductId,
      'package': googlePlayPackageName,
    };
    final uri = Uri.https(
      'play.google.com',
      '/store/account/subscriptions',
      query,
    );

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      throw const GooglePlayBillingException(
        'Não foi possível abrir o Google Play.',
      );
    }
  }

  Future<bool> _isGooglePlayBillingAvailable() async {
    try {
      return await _inAppPurchase.isAvailable();
    } on PlatformException catch (error) {
      if (error.code == 'channel-error') {
        throw const GooglePlayBillingException(
          'Reinstale o app com a build mais recente para carregar o Google Play Billing.',
        );
      }
      throw GooglePlayBillingException(
        error.message ?? 'Não foi possível iniciar o Google Play Billing.',
      );
    }
  }

  List<GooglePlaySubscriptionProduct> _selectSubscriptionProducts(
    ProductDetailsResponse response, {
    required bool monthlyIntroOfferEligible,
  }) {
    final mappedProducts = response.productDetails
        .where(
          (details) => googlePlaySubscriptionProductIds.contains(details.id),
        )
        .map(GooglePlaySubscriptionProduct.new)
        .toList();

    final productsById = <String, GooglePlaySubscriptionProduct>{};
    for (final product in mappedProducts) {
      final isMonthlyProduct =
          product.productId == googlePlaySubscriptionMonthlyProductId;
      if (isMonthlyProduct &&
          product.hasIntroductoryPrice &&
          !monthlyIntroOfferEligible) {
        continue;
      }

      final existing = productsById[product.productId];
      final preferIntroductoryPrice = isMonthlyProduct
          ? monthlyIntroOfferEligible
          : true;
      if (existing == null ||
          product.isPreferredOver(
            existing,
            preferIntroductoryPrice: preferIntroductoryPrice,
          )) {
        productsById[product.productId] = product;
      }
    }

    final products = productsById.values.toList()
      ..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));

    if (products.isEmpty) {
      final notFound = response.notFoundIDs.join(', ');
      throw GooglePlayBillingException(
        notFound.isEmpty
            ? 'Nenhum plano foi retornado pelo Google Play.'
            : 'Planos ainda não encontrados no Google Play: $notFound.',
      );
    }

    return products;
  }

  String? _normalizeManagementProductId(String? productId) {
    return switch (productId) {
      'mensal' || googlePlaySubscriptionMonthlyProductId =>
        googlePlaySubscriptionMonthlyProductId,
      'anual' || googlePlaySubscriptionAnnualProductId =>
        googlePlaySubscriptionAnnualProductId,
      _ => productId,
    };
  }
}
