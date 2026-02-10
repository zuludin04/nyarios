import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/ui/search/search_controller.dart';
import 'package:nyarios/ui/search/search_result_body.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String type;
  final String roomId;
  final String userId;
  final String username;

  const SearchScreen({
    super.key,
    required this.type,
    required this.roomId,
    required this.userId,
    required this.username,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
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
            typeResult: widget.type,
            userId: widget.userId,
            username: widget.username,
          ),
          error: (_, _) => SizedBox(),
          loading: () => CircularProgressIndicator(),
        ),
        backdropColor: Colors.transparent,
        transition: CircularFloatingSearchBarTransition(),
        hint: widget.type == 'lastMessage'
            ? AppLocalizations.of(context)!.search_contact
            : AppLocalizations.of(context)!.search_chat,
        onQueryChanged: (query) {
          final controller = ref.read(searchControllerProvider.notifier);
          if (widget.type == 'lastMessage') {
            controller.searchChat(query);
          } else {
            controller.searchMessages(widget.roomId, query);
          }
        },
        builder: (context, transition) => Container(),
      ),
    );
  }
}
