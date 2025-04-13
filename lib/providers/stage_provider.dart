// lib/providers/stage_provider.dart

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/models/stage/stage_data.dart';
import 'package:rm_veriphy/services/stage_service.dart';

class StageProvider with ChangeNotifier {
  final StageService _stageService;

  StageData? _stageData;
  bool _isLoading = false;
  String? _error;

  StageProvider(this._stageService);

  // Getters
  StageData? get stageData => _stageData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStageData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _stageData = await _stageService.getStageData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
