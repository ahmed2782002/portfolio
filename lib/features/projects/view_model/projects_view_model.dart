import 'package:flutter/foundation.dart';

import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// Which case study is open and which of its screenshots is in front.
class ProjectsViewModel extends ChangeNotifier {
  ProjectsViewModel(this._repository);

  final PortfolioRepository _repository;

  int _projectIndex = 0;
  int _shotIndex = 0;

  List<Project> get projects => _repository.projects;
  List<AdditionalProject> get additionalProjects =>
      _repository.additionalProjects;

  int get projectIndex => _projectIndex;
  int get shotIndex => _shotIndex;

  Project get project => projects[_projectIndex];
  Screenshot get screenshot => project.screenshots[_shotIndex];

  bool get canStepBack => _shotIndex > 0;
  bool get canStepForward => _shotIndex < project.screenshots.length - 1;

  void selectProject(int index) {
    if (index == _projectIndex || index < 0 || index >= projects.length) {
      return;
    }
    _projectIndex = index;
    _shotIndex = 0;
    notifyListeners();
  }

  void selectShot(int index) {
    final clamped = index.clamp(0, project.screenshots.length - 1);
    if (clamped == _shotIndex) return;
    _shotIndex = clamped;
    notifyListeners();
  }

  void step(int delta) => selectShot(_shotIndex + delta);
}
