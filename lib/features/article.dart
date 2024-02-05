import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';
import '../core/constants/constants.dart';
import '../core/commons/commons.dart';
import '../models/models.dart';
import '../theme/palette.dart';

class ArticleView extends StatefulWidget {
  final Article article;
  const ArticleView({super.key, required this.article});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: controller,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            stretch: false,
            floating: true,
            backgroundColor: Colors.transparent,
            leading: JustIconButton(
                icon: CupertinoIcons.back,
                onPressed: () => Routemaster.of(context).pop(context)),
            actions: [
              JustIconButton(icon: Icons.more_horiz, onPressed: () {}),
              const SizedBox(
                width: 5,
              ),
            ],
            centerTitle: true,
            title: const Text(
              'Article',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'JetBrainsMonoExtraBold',
              ),
            ),
            // trailing: navBarButton(Icons.more_horiz),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            padding: const EdgeInsets.only(top: 10),
            children: [
              //Title
              Text(
                widget.article.title,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              //Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'https://i.ytimg.com/vi/pf1GvrUqeIA/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDpZVVG9T1eWrEJ43_2Jop9OuIMcw',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              //Text
              const Text(
                'Fortunately, reports that Israel bombed a hospital in Gaza and killed 500 people turned out not to be true. But it is true that Israel is dropping many bombs on the territory, and that many innocents have already been killed, and many more will be killed in the days to come. \n\nFew people seem to care much about the 2 million people of Gaza — not Hamas, who tries to provoke brutal reprisals to win international support for their cause, not Israel, which talks of collective punishment and has blockaded Gaza for decades, and not Egypt or other Arab countries, who have refused to take in Gazan refugees. The Gazans are isolated and alone, stateless and forsaken by basically the entire planet.At a time like this, some people might see it as dismissive or callous to talk about the long-term economic future of Gaza. Perhaps it takes a terminal case of Economist Brain to look at a land in the grip of endless war and say “You know what this place needs? Some GDP!”. But I think it’s an important exercise, because economic development provides a nation with a purpose other than the catharsis of violence. \n\nAnd having that long-term vision fixed in place helps to make decisions about leadership in the present, too, because it allows people to ask “Which leaders will get us closer to that bright, prosperous future?”.Nor is it unrealistic to think that in half a century’s time, Gaza might be an economically flourishing place. Large swathes of Hanoi were flattened by American bombs in the 1960s and 70s, but fifty years later it looks like this:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ScrollToHideWidget(
        controller: controller,
        child: Container(
          height: 50,
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Palette.placeholderColor, width: 0.25))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                Constants.comment,
                height: 25,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              SvgPicture.asset(
                Constants.heartOutlined,
                height: 25,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              SvgPicture.asset(
                Constants.repost,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              SvgPicture.asset(
                Constants.upload,
                height: 25,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
