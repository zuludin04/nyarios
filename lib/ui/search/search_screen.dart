import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:nyarios/ui/search/search_controller.dart';
import 'package:nyarios/ui/search/search_result_body.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final String type = Get.arguments['type'];
  final String roomId = Get.arguments['roomId'];
  final String user = Get.arguments['user'];

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(searchControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FloatingSearchBar(
        body: provider.when(
          data: (data) => SearchResultBody(
            chatResult: data.chatResult,
            messageResult: data.messageResult,
            typeResult: type,
          ),
          error: (_, _) => SizedBox(),
          loading: () => CircularProgressIndicator(),
        ),
        backdropColor: Colors.transparent,
        transition: CircularFloatingSearchBarTransition(),
        hint: type == 'lastMessage' ? 'search_contact'.tr : 'search_chat'.tr,
        onQueryChanged: (query) {
          final controller = ref.read(searchControllerProvider.notifier);
          if (type == 'lastMessage') {
            controller.searchChat(query);
          } else {
            controller.searchMessages(roomId, query);
          }
        },
        builder: (context, transition) => Container(),
      ),
    );
  }
}
