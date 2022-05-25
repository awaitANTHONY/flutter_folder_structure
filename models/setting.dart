class Setting {
  bool? status;
  Settings? settings;

  Setting({this.status, this.settings});

  Setting.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (settings != null) {
      data['settings'] = settings?.toJson();
    }
    return data;
  }
}

class Settings {
  String? facebook;
  String? youtube;
  String? androidPrivacyPolicy;
  String? androidAppShareLink;
  String? androidLiveControl;
  String? androidAdsStatus;
  String? androidAdsControl;
  String? androidAppId;
  String? androidBannerAddCode;
  String? androidInterstitialAddCode;
  String? iosPrivacyPolicy;
  String? iosAppShareLink;
  String? iosAppRatingLink;
  String? iosLiveControl;
  String? iosAdsStatus;
  String? iosAdsControl;
  String? iosAppId;
  String? iosBannerAddCode;
  String? iosInterstitialAddCode;
  String? instagram;
  String? twitter;

  Settings(
      {this.facebook,
      this.youtube,
      this.androidPrivacyPolicy,
      this.androidAppShareLink,
      this.androidLiveControl,
      this.androidAdsStatus,
      this.androidAdsControl,
      this.androidAppId,
      this.androidBannerAddCode,
      this.androidInterstitialAddCode,
      this.iosPrivacyPolicy,
      this.iosAppShareLink,
      this.iosAppRatingLink,
      this.iosLiveControl,
      this.iosAdsStatus,
      this.iosAdsControl,
      this.iosAppId,
      this.iosBannerAddCode,
      this.iosInterstitialAddCode,
      this.instagram,
      this.twitter});

  Settings.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    youtube = json['youtube'];
    androidPrivacyPolicy = json['android_privacy_policy'];
    androidAppShareLink = json['android_app_share_link'];
    androidLiveControl = json['android_live_control'];
    androidAdsStatus = json['android_ads_status'];
    androidAdsControl = json['android_ads_control'];
    androidAppId = json['android_app_id'];
    androidBannerAddCode = json['android_banner_add_code'];
    androidInterstitialAddCode = json['android_interstitial_add_code'];
    iosPrivacyPolicy = json['ios_privacy_policy'];
    iosAppShareLink = json['ios_app_share_link'];
    iosAppRatingLink = json['ios_app_rating_link'];
    iosLiveControl = json['ios_live_control'];
    iosAdsStatus = json['ios_ads_status'];
    iosAdsControl = json['ios_ads_control'];
    iosAppId = json['ios_app_id'];
    iosBannerAddCode = json['ios_banner_add_code'];
    iosInterstitialAddCode = json['ios_interstitial_add_code'];
    instagram = json['instagram'];
    twitter = json['twitter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['facebook'] = facebook;
    data['youtube'] = youtube;
    data['android_privacy_policy'] = androidPrivacyPolicy;
    data['android_app_share_link'] = androidAppShareLink;
    data['android_live_control'] = androidLiveControl;
    data['android_ads_status'] = androidAdsStatus;
    data['android_ads_control'] = androidAdsControl;
    data['android_app_id'] = androidAppId;
    data['android_banner_add_code'] = androidBannerAddCode;
    data['android_interstitial_add_code'] = androidInterstitialAddCode;
    data['ios_privacy_policy'] = iosPrivacyPolicy;
    data['ios_app_share_link'] = iosAppShareLink;
    data['ios_app_rating_link'] = iosAppRatingLink;
    data['ios_live_control'] = iosLiveControl;
    data['ios_ads_status'] = iosAdsStatus;
    data['ios_ads_control'] = iosAdsControl;
    data['ios_app_id'] = iosAppId;
    data['ios_banner_add_code'] = iosBannerAddCode;
    data['ios_interstitial_add_code'] = iosInterstitialAddCode;
    data['instagram'] = instagram;
    data['twitter'] = twitter;
    return data;
  }
}
