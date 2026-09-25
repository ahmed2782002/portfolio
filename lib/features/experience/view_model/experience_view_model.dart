import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// Content for the Experience section.
class ExperienceViewModel {
  const ExperienceViewModel(this._repository);

  final PortfolioRepository _repository;

  List<ExperienceEntry> get entries => _repository.experience;

  static bool isCurrent(ExperienceEntry entry) =>
      entry.period.toLowerCase().contains('present');
}
