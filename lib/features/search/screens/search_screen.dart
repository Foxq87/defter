import 'package:acc/core/commons/commons.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
import '../../../theme/palette.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = "";
  List contentItems = [
    ['kullanıcılar', true],
    ['okullar', false],
  ];
  void selectAndUnselectOthers(int index) {
    if (kDebugMode) {
      print(contentItems.first[1]);
    }
    for (var element in contentItems) {
      setState(() {
        element[1] = false;
        contentItems[index][1] = true;
      });
    }
  }

  Padding buildContentItem({required String text, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: isSelected ? Palette.themeColor : Colors.transparent)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'JetBrainsMonoBold'),
        ),
      ),
    );
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 1, color: Palette.textfieldColor)),
        middle: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: SizedBox(
            height: 40,
            child: CupertinoSearchTextField(
              onChanged: (text) {
                setState(() {
                  query = text;
                });
              },
              controller: searchController,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Palette.textfieldColor,
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(
                  CupertinoIcons.search,
                  color: Palette.placeholderColor,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "JetBrainsMonoRegular",
              ),
              placeholder: 'search',
              placeholderStyle: const TextStyle(
                color: Palette.placeholderColor,
                fontFamily: 'JetBrainsMonoBold',
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(contentItems.length, (index) {
                return CupertinoButton(
                  onPressed: () => selectAndUnselectOthers(index),
                  padding: EdgeInsets.zero,
                  child: buildContentItem(
                      text: contentItems[index][0].toString(),
                      isSelected: contentItems[index][1]),
                );
              })),
          const Divider(
            thickness: 0.6,
            height: 0,
          ),
          Expanded(
            child: ref
                .watch(contentItems.first[1] == true
                    ? searchUserProvider(query)
                    : searchSchoolProvider(query))
                .when(
                  data: (dynamic items) => ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];

                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                contentItems.first[1] == true
                                    ? item.profilePic
                                    : item.avatar),
                          ),
                          title: Text(contentItems.first[1] == true
                              ? item.username
                              : item.title),
                          onTap: () => contentItems.first[1] == true
                              ? navigateToProfile(context, item as UserModel)
                              : navigateToSchool(context, item.id as String));
                    },
                  ),
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          ),
        ],
      ),
    );
  }
}
