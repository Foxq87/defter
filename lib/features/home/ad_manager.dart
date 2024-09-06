import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  // Replace with your actual Ad Unit ID
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test Ad Unit ID

  static BannerAd createNewAd() {
    BannerAd bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
        // Implement other listener methods if needed.
      ),
    );

    return bannerAd;
  }
}