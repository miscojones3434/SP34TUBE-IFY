import 'pt34_brand.dart';
import 'pt34_routes.dart';

/// Secciones propias de SP34TUBE-IFY.
///
/// Este archivo no modifica ni desactiva ninguna función original de Spotube.
enum Pt34Section {
  home,
  myActivity,
  mySongs,
  createMusic,
  distribution,
  profile,
}

extension Pt34SectionData on Pt34Section {
  String get title {
    switch (this) {
      case Pt34Section.home:
        return Pt34Brand.homeTitle;
      case Pt34Section.myActivity:
        return Pt34Brand.myActivityTitle;
      case Pt34Section.mySongs:
        return Pt34Brand.mySongsTitle;
      case Pt34Section.createMusic:
        return Pt34Brand.createMusicTitle;
      case Pt34Section.distribution:
        return Pt34Brand.distributionTitle;
      case Pt34Section.profile:
        return Pt34Brand.profileTitle;
    }
  }

  String get route {
    switch (this) {
      case Pt34Section.home:
        return Pt34Routes.home;
      case Pt34Section.myActivity:
        return Pt34Routes.myActivity;
      case Pt34Section.mySongs:
        return Pt34Routes.mySongs;
      case Pt34Section.createMusic:
        return Pt34Routes.createMusic;
      case Pt34Section.distribution:
        return Pt34Routes.distribution;
      case Pt34Section.profile:
        return Pt34Routes.profile;
    }
  }

  bool get isEnabled => true;
}
