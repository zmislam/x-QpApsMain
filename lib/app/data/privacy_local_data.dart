import 'package:flutter/material.dart';
import '../models/privacy_local_model.dart';

class PrivacyLocalData {
  PrivacyLocalData._privateConstructor();

  static final PrivacyLocalData _instance = PrivacyLocalData._privateConstructor();

  factory PrivacyLocalData() {
    return _instance;
  }

  static List<PrivacyLocalModel> get privacyList => [
        PrivacyLocalModel(
          name: 'Public',
          value: 'public',
          icon: const Icon(Icons.public),
        ),
        PrivacyLocalModel(
          name: 'Friends',
          value: 'friends',
          icon: const Icon(Icons.group),
        ),
        PrivacyLocalModel(
          name: 'Only Me',
          value: 'only_me',
          icon: const Icon(Icons.lock),
        )
      ];
}
