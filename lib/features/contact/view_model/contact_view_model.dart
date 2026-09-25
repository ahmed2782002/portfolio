import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// Content for the Contact section.
class ContactViewModel {
  const ContactViewModel(this._repository);

  final PortfolioRepository _repository;

  String get mailtoUri => _repository.profile.mailtoUri;
  String get location => _repository.profile.location;

  /// Direct channels first, then public profiles.
  List<ContactLink> get channels => [
    ..._repository.contactChannels,
    ..._repository.socialLinks,
  ];
}
