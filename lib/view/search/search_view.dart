import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/search_provider.dart';
import 'widgets/searchresult_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 1.0,
            pinned: false,
            snap: false,
            floating: true,
            title: TextField(
              textCapitalization: TextCapitalization.words,
              controller: c,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                focusColor: Colors.white,
                hintText: 'Search...',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
              ),
              onEditingComplete: () {
                log(c.text);
                context.read<SearchProvider>().getSearch(c.text.trim());
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          const SearchResultWidget(),
        ],
      ),
    );
  }
}
