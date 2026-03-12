
import 'package:get_storage/get_storage.dart';
import '../config/constants/local_storage_key.dart';
import '../models/app_settings_model.dart';

class AppSettingsData {
  late final GetStorage _getStorage;
  AppSettingsData() {
    _getStorage = GetStorage();
  }

  // =============================== save data =================================
  void saveAppSettingsData(AppSettingsModel model) {
    _getStorage.write(LocalStorageKey.APP_SETTINGS_KEY, model.toJson());
  }

  // =============================== get data ==================================
  AppSettingsModel getAppSettingsData() {
    String? data = _getStorage.read(LocalStorageKey.APP_SETTINGS_KEY);

    AppSettingsModel? model;
    if (data != null) {
      model = AppSettingsModel.fromJson(data);
    }
    return model ?? AppSettingsModel();


  }


}
