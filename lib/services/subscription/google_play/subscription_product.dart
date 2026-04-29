import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../subscription_api.dart';

class GooglePlaySubscriptionProduct {
  const GooglePlaySubscriptionProduct(this.details);

  final ProductDetails details;

  String get productId => details.id;
  String get title => isAnnual ? 'Plano anual' : 'Plano mensal';
  String get billingPeriodLabel => isAnnual ? 'por ano' : 'por mês';
  String get callToActionLabel => isAnnual ? 'Assinar anual' : 'Assinar mensal';
  String get highlightLabel => isAnnual ? 'Melhor valor' : 'Flexivel';
  String get benefitLabel => isAnnual
      ? 'Economize mantendo acesso premium por 12 meses.'
      : 'Acesso premium com renovação mensal.';
  bool get isAnnual => productId == googlePlaySubscriptionAnnualProductId;
  int get sortOrder => isAnnual ? 1 : 0;
  bool get hasIntroductoryPrice =>
      _selectedPricingPhases.isNotEmpty &&
      introductoryPricingPhase != null &&
      regularPricingPhase != null &&
      introductoryPricingPhase!.priceAmountMicros <
          regularPricingPhase!.priceAmountMicros;
  String get displayPricePrefix => _splitDisplayedPrice().$1;
  String get displayPriceValue => _splitDisplayedPrice().$2;
  String get displayPriceLabel => _normalizeSpacing(
    introductoryPricingPhase?.formattedPrice ?? details.price,
  );
  String get regularPriceLabel =>
      _normalizeSpacing(regularPricingPhase?.formattedPrice ?? details.price);

  PricingPhaseWrapper? get introductoryPricingPhase {
    if (_selectedPricingPhases.isEmpty) {
      return null;
    }
    if (_hasDiscountWithinSelectedOffer || _hasStandaloneOfferDiscount) {
      return _selectedPricingPhases.first;
    }
    return null;
  }

  PricingPhaseWrapper? get regularPricingPhase {
    if (_selectedPricingPhases.isEmpty) {
      return null;
    }
    if (_hasStandaloneOfferDiscount && _matchingBasePlanPricingPhase != null) {
      return _matchingBasePlanPricingPhase;
    }
    if (_selectedPricingPhases.length >= 2) {
      return _selectedPricingPhases.last;
    }
    return _selectedPricingPhases.first;
  }

  bool isPreferredOver(
    GooglePlaySubscriptionProduct other, {
    bool preferIntroductoryPrice = true,
  }) {
    if (hasIntroductoryPrice != other.hasIntroductoryPrice) {
      return preferIntroductoryPrice
          ? hasIntroductoryPrice
          : !hasIntroductoryPrice;
    }
    if (details.rawPrice != other.details.rawPrice) {
      return details.rawPrice < other.details.rawPrice;
    }
    final currentRegularPrice = regularPricingPhase?.priceAmountMicros;
    final otherRegularPrice = other.regularPricingPhase?.priceAmountMicros;
    if (currentRegularPrice != null &&
        otherRegularPrice != null &&
        currentRegularPrice != otherRegularPrice) {
      return currentRegularPrice < otherRegularPrice;
    }
    return false;
  }

  bool get _hasDiscountWithinSelectedOffer {
    if (_selectedPricingPhases.length < 2) {
      return false;
    }
    return _selectedPricingPhases.first.priceAmountMicros <
        _selectedPricingPhases.last.priceAmountMicros;
  }

  bool get _hasStandaloneOfferDiscount {
    final selectedOffer = _selectedOffer;
    final selectedPhase = _selectedPricingPhases.isEmpty
        ? null
        : _selectedPricingPhases.first;
    final basePlanPhase = _matchingBasePlanPricingPhase;
    if (selectedOffer == null ||
        selectedOffer.offerId == null ||
        selectedPhase == null ||
        basePlanPhase == null) {
      return false;
    }
    return selectedPhase.priceAmountMicros < basePlanPhase.priceAmountMicros;
  }

  SubscriptionOfferDetailsWrapper? get _selectedOffer {
    final product = details;
    if (product is! GooglePlayProductDetails) {
      return null;
    }

    final subscriptionOfferDetails =
        product.productDetails.subscriptionOfferDetails;
    final subscriptionIndex = product.subscriptionIndex;
    if (subscriptionOfferDetails == null ||
        subscriptionIndex == null ||
        subscriptionIndex < 0 ||
        subscriptionIndex >= subscriptionOfferDetails.length) {
      return null;
    }

    return subscriptionOfferDetails[subscriptionIndex];
  }

  List<PricingPhaseWrapper> get _selectedPricingPhases =>
      _selectedOffer?.pricingPhases ?? const [];

  PricingPhaseWrapper? get _matchingBasePlanPricingPhase {
    final selectedOffer = _selectedOffer;
    if (selectedOffer == null) {
      return null;
    }

    final allOffers = (details is GooglePlayProductDetails)
        ? (details as GooglePlayProductDetails)
              .productDetails
              .subscriptionOfferDetails
        : null;
    if (allOffers == null || allOffers.isEmpty) {
      return null;
    }

    for (final offer in allOffers) {
      if (offer.basePlanId != selectedOffer.basePlanId ||
          offer.offerId != null) {
        continue;
      }
      if (offer.pricingPhases.isEmpty) {
        continue;
      }
      return offer.pricingPhases.first;
    }

    return null;
  }

  (String, String) _splitDisplayedPrice() {
    final formattedPrice = displayPriceLabel;
    final currencySymbol = _normalizeSpacing(details.currencySymbol);

    if (currencySymbol.isEmpty) {
      return ('', formattedPrice);
    }

    if (formattedPrice.startsWith(currencySymbol)) {
      final amount = formattedPrice.substring(currencySymbol.length).trim();
      return (currencySymbol, amount.isEmpty ? formattedPrice : amount);
    }

    final amount = formattedPrice.replaceFirst(currencySymbol, '').trim();
    return (currencySymbol, amount.isEmpty ? formattedPrice : amount);
  }

  String _normalizeSpacing(String value) {
    return _normalizeBrazilianPrice(value.replaceAll('\u00A0', ' ').trim());
  }

  String _normalizeBrazilianPrice(String value) {
    if (details.currencyCode != 'BRL') {
      return value;
    }
    return value.replaceFirstMapped(
      RegExp(r'(\d+)\.(\d{2})(?!\d)'),
      (match) => '${match[1]},${match[2]}',
    );
  }
}
