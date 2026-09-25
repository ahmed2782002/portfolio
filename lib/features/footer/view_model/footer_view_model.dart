import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// Content for the site footer.
class FooterViewModel {
  const FooterViewModel(this._repository);

  final PortfolioRepository _repository;

  /// Read once at load, not on every rebuild.
  static final int _year = DateTime.now().year;

  Profile get profile => _repository.profile;
  List<ContactLink> get contactChannels => _repository.contactChannels;
  List<ContactLink> get socialLinks => _repository.socialLinks;

  String get copyright => '© $_year ${profile.fullName}. All rights reserved.';
}
