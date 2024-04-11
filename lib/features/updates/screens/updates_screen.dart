import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/updates/controller/update_controller.dart';
import 'package:acc/features/updates/widgets/update_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/commons/large_text.dart';
import '../../../models/update_model.dart';
import '../../../theme/palette.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> {
  navigatToSuggest() {
    Routemaster.of(context).push('/suggest-feature-screen');
  }

  navigateToCreateUpdate() {
    Routemaster.of(context).push('/create-update-screen');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 1, color: Palette.textFieldColor)),
        middle: largeText('yenilikler', false),
      ),
      floatingActionButton: user.roles.contains('developer')
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(100),
              color: Palette.themeColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                navigateToCreateUpdate();
              },
            )
          : CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(100),
              color: Palette.themeColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                navigatToSuggest();
              },
            ),
      body: ref.watch(getUpdatesProvider).when(
            data: (List<Update> updates) {
              return ListView.builder(
                itemCount: updates.length,
                itemBuilder: (BuildContext context, int index) {
                  final update = updates[index];
                  return UpdateCard(update: update);
                },
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => Loader(),
          ),
    );
  }
}
