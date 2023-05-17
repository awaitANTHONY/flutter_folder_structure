class Setting {
  bool? status;
  SettingData? data;

  Setting({this.status, this.data});

  Setting.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SettingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SettingData {
  String? appName;
  String? facebook;
  String? instagram;
  String? youtube;
  String? androidPrivacyPolicy;
  String? androidTermsCondition;
  String? androidAppShareLink;
  String? androidEnableAds;
  String? androidAdsType;
  String? androidApplicationId;
  String? androidInterstitialAdClick;
  String? androidAppopenAdCode;
  String? androidBannerAdCode;
  String? androidInterstitialAdCode;
  String? androidNativeAdCode;
  String? iosEnableAds;
  String? iosAdsType;
  String? iosInterstitialAdClick;
  String? iosAppopenAdCode;
  String? iosBannerAdCode;
  String? iosInterstitialAdCode;
  String? iosNativeAdCode;
  String? iosPrivacyPolicy;
  String? iosTermsCondition;
  String? iosAppShareLink;
  String? iosAppRatingLink;

  SettingData(
      {this.appName,
      this.facebook,
      this.instagram,
      this.youtube,
      this.androidPrivacyPolicy,
      this.androidTermsCondition,
      this.androidAppShareLink,
      this.androidEnableAds,
      this.androidAdsType,
      this.androidApplicationId,
      this.androidInterstitialAdClick,
      this.androidAppopenAdCode,
      this.androidBannerAdCode,
      this.androidInterstitialAdCode,
      this.androidNativeAdCode,
      this.iosEnableAds,
      this.iosAdsType,
      this.iosInterstitialAdClick,
      this.iosAppopenAdCode,
      this.iosBannerAdCode,
      this.iosInterstitialAdCode,
      this.iosNativeAdCode,
      this.iosPrivacyPolicy,
      this.iosTermsCondition,
      this.iosAppShareLink,
      this.iosAppRatingLink});

  SettingData.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    androidPrivacyPolicy = json['android_privacy_policy'];
    androidTermsCondition = json['android_terms_condition'];
    androidAppShareLink = json['android_app_share_link'];
    androidEnableAds = json['android_enable_ads'];
    androidAdsType = json['android_ads_type'];
    androidApplicationId = json['android_application_id'];
    androidInterstitialAdClick = json['android_interstitial_ad_click'];
    androidAppopenAdCode = json['android_appopen_ad_code'];
    androidBannerAdCode = json['android_banner_ad_code'];
    androidInterstitialAdCode = json['android_interstitial_ad_code'];
    androidNativeAdCode = json['android_native_ad_code'];
    iosEnableAds = json['ios_enable_ads'];
    iosAdsType = json['ios_ads_type'];
    iosInterstitialAdClick = json['ios_interstitial_ad_click'];
    iosAppopenAdCode = json['ios_appopen_ad_code'];
    iosBannerAdCode = json['ios_banner_ad_code'];
    iosInterstitialAdCode = json['ios_interstitial_ad_code'];
    iosNativeAdCode = json['ios_native_ad_code'];
    iosPrivacyPolicy = json['ios_privacy_policy'];
    iosTermsCondition = json['ios_terms_condition'];
    iosAppShareLink = json['ios_app_share_link'];
    iosAppRatingLink = json['ios_app_rating_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['android_privacy_policy'] = androidPrivacyPolicy;
    data['android_terms_condition'] = androidTermsCondition;
    data['android_app_share_link'] = androidAppShareLink;
    data['android_enable_ads'] = androidEnableAds;
    data['android_ads_type'] = androidAdsType;
    data['android_application_id'] = androidApplicationId;
    data['android_interstitial_ad_click'] = androidInterstitialAdClick;
    data['android_appopen_ad_code'] = androidAppopenAdCode;
    data['android_banner_ad_code'] = androidBannerAdCode;
    data['android_interstitial_ad_code'] = androidInterstitialAdCode;
    data['android_native_ad_code'] = androidNativeAdCode;
    data['ios_enable_ads'] = iosEnableAds;
    data['ios_ads_type'] = iosAdsType;
    data['ios_interstitial_ad_click'] = iosInterstitialAdClick;
    data['ios_appopen_ad_code'] = iosAppopenAdCode;
    data['ios_banner_ad_code'] = iosBannerAdCode;
    data['ios_interstitial_ad_code'] = iosInterstitialAdCode;
    data['ios_native_ad_code'] = iosNativeAdCode;
    data['ios_privacy_policy'] = iosPrivacyPolicy;
    data['ios_terms_condition'] = iosTermsCondition;
    data['ios_app_share_link'] = iosAppShareLink;
    data['ios_app_rating_link'] = iosAppRatingLink;
    return data;
  }
}
