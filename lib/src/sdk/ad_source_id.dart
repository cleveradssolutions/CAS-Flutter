enum AdSourceId {
  googleAds(0),
  liftoffMonetize(1),
  kidoz(2),
  chartboost(3),
  unityAds(4),
  applovin(5),
  superAwesome(6),
  startio(7),
  casExchange(8),
  audienceNetwork(9),
  inmobi(10),
  dtExchange(11),
  mytarget(12),
  crosspromo(13),
  ironsource(14),
  yandexAds(15),
  hyprmx(16),
  smaato(18),
  bigo(19),
  ogury(20),
  madex(21),
  loopme(22),
  mintegral(23),
  pangle(24),
  ysoNetwork(25),
  prado(26),

  dspExchange(30),
  lastPageAd(31),
  custom(32),
  unknown(33);

  final int value;

  const AdSourceId(this.value);

  static AdSourceId fromValue(int? value) {
    for (final sourceId in values) {
      if (sourceId.value == value) {
        return sourceId;
      }
    }
    return unknown;
  }
}
