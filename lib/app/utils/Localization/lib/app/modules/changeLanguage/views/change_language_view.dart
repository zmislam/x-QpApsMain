import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../../../../models/language.dart' hide LanguageModel;
import '../controllers/languageController.dart';

class ChangeLanguageView extends StatelessWidget {
  ChangeLanguageView({super.key});

  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Language'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your preferred language'.tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: languageController.languages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final language = languageController.languages[index];
                  return _LanguageCard(
                    language: language,
                    isSelected: languageController.currentLanguage.value.code == language.code,
                    onTap: () => languageController.changeLanguage(language),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final LanguageModel language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Text(
          language.flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          language.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isSelected
            ? Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
        )
            : const Icon(
          Icons.circle_outlined,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          )
              : BorderSide.none,
        ),
      ),
    );
  }
}