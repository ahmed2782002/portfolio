import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// Content for the Skills section.
class SkillsViewModel {
  const SkillsViewModel(this._repository);

  final PortfolioRepository _repository;

  List<SkillGroup> get groups => _repository.skillGroups;
}
