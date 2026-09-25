import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// Content for the About section.
class AboutViewModel {
  const AboutViewModel(this._repository);

  final PortfolioRepository _repository;

  String get summary => _repository.profile.summary;
  List<Principle> get principles => _repository.principles;
  Education get education => _repository.education;
  List<Certification> get certifications => _repository.certifications;
  List<LanguageSkill> get languages => _repository.languages;
}
