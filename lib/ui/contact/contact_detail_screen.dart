import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/model/profile.dart';
import '../../data/nyarios_repository.dart';
import '../../services/storage_services.dart';

class ContactDetailScreen extends StatelessWidget {
  final Profile profile = Get.arguments;

  ContactDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('', elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1.5),
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      profile.photo!,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile.name!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                stream: NyariosRepository().getOnlineStatus(profile.uid),
                builder: (context, snapshot) {
                  String status = snapshot.data?.data()?["visibility"] ?? "";
                  return Visibility(
                    visible:
                        snapshot.connectionState == ConnectionState.active &&
                            status == "Online",
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 14,
                          color: StorageServices.to.darkMode
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
