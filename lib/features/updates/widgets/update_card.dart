import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/user_square.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/updates/controller/update_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/update_model.dart';

class UpdateCard extends ConsumerStatefulWidget {
  final Update update;
  const UpdateCard({super.key, required this.update});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateCardState();
}

class _UpdateCardState extends ConsumerState<UpdateCard> {
  void deleteUpdate() {
    ref
        .read(updateControllerProvider.notifier)
        .deleteUpdate(widget.update, context);
  }

  Widget profilePicture(UserModel user) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 0.15, color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
            image: AssetImage("assets/defter-icon-ios.png"), fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    print(widget.update.imageLinks.length);
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
      ).copyWith(
        top: 10.0,
      ),
      child: Column(
        children: [
          ListTile(
            leading: profilePicture(currentUser),
            title: Text(widget.update.title),
            subtitle: Text(widget.update.description),
            trailing: currentUser.roles.contains('developer')
                ? IconButton(
                    icon: Icon(
                      CupertinoIcons.delete,
                      color: Palette.redColor,
                    ),
                    onPressed: deleteUpdate,
                  )
                : null,
          ),
          if (widget.update.imageLinks.length == 1)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ImageView(
                        imageUrls: widget.update.imageLinks,
                        imageFiles: [],
                        index: 0)));
              },
              child: Container(
                margin: EdgeInsets.all(10),
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.25, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(widget.update.imageLinks.first),
                        fit: BoxFit.cover)),
              ),
            )
          else if (widget.update.imageLinks.length == 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0)
                  .copyWith(bottom: 15),
              child: SizedBox(
                height: 150,
                child: Row(
                  children:
                      List.generate(widget.update.imageLinks.length, (index) {
                    return Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => ImageView(
                                imageUrls: widget.update.imageLinks,
                                imageFiles: [],
                                index: index)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: index == 0 ? 7 : 0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.25, color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(
                                    widget.update.imageLinks[index]),
                                fit: BoxFit.cover)),
                      ),
                    ));
                  }),
                ),
              ),
            )
          else if (widget.update.imageLinks.length == 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0)
                  .copyWith(bottom: 15),
              child: SizedBox(
                height: 150,
                child: Row(
                  children:
                      List.generate(widget.update.imageLinks.length, (index) {
                    return Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => ImageView(
                                imageUrls: widget.update.imageLinks,
                                imageFiles: [],
                                index: index)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            right: index == 0 || index == 1 ? 7 : 0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.25, color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(
                                    widget.update.imageLinks[index]),
                                fit: BoxFit.cover)),
                      ),
                    ));
                  }),
                ),
              ),
            )
          else if (widget.update.imageLinks.length >= 4)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0)
                  .copyWith(bottom: 15),
              child: Wrap(
                runSpacing: 7.0,
                spacing: 7.0,
                direction: Axis.horizontal,
                children: List.generate(4, (index) {
                  return Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => ImageView(
                              imageUrls: widget.update.imageLinks,
                              imageFiles: [],
                              index: index)));
                    },
                    child: widget.update.imageLinks.length > 4 && index == 3
                        ? Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            decoration: BoxDecoration(
                              color: Palette.darkGreyColor,
                              border:
                                  Border.all(width: 0.25, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                              "+${widget.update.imageLinks.length - 3}",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'JetBrainsMonoExtraBold'),
                            )),
                          )
                        : Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 0.25, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.update.imageLinks[index]),
                                    fit: BoxFit.cover)),
                          ),
                  ));
                }),
              ),
            )
        ],
      ),
    );
  }
}
