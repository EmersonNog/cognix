class StudyPlanRefreshNotifier {
  bool _dirty = false;

  void markDirty() {
    _dirty = true;
  }

  bool consumeDirty() {
    final wasDirty = _dirty;
    _dirty = false;
    return wasDirty;
  }
}

final studyPlanRefreshNotifier = StudyPlanRefreshNotifier();
