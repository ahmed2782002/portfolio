import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// Content for the Services section.
class ServicesViewModel {
  const ServicesViewModel(this._repository);

  final PortfolioRepository _repository;

  List<ServiceOffering> get services => _repository.services;
}
