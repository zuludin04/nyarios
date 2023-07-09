import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import 'nyarios_search_controller.dart';
import 'widgets/search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FloatingSearchBarController _controller = FloatingSearchBarController();
  final NyariosSearchController _searchController = Get.find();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FloatingSearchBar(
        controller: _controller,
        body: SearchResults(controller: _searchController),
        backdropColor: Colors.transparent,
        transition: CircularFloatingSearchBarTransition(),
        hint: _searchController.type == 'contacts'
            ? 'search_contact'.tr
            : 'search_chat'.tr,
        onQueryChanged: (query) {
          if (_searchController.type == 'contacts') {
            _searchController.searchContact(query);
          } else {
            _searchController.searchChat(query);
          }
        },
        builder: (context, transition) {
          return Container();
        },
      ),
    );
  }
}
