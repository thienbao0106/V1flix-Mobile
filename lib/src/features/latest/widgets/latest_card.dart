import 'package:app/src/features/latest/widgets/info_episode.dart';
import 'package:app/src/features/video/screens/video.dart';
import 'package:app/src/models/episodes.dart';
import 'package:app/src/utils/find_image.dart';
import 'package:app/src/utils/find_source.dart';
import 'package:flutter/material.dart';

class LatestCard extends StatelessWidget {
  const LatestCard(
      {super.key,
      required this.episode,
      required this.nextTitle,
      required this.isFirst});

  final Episode episode;
  final String? nextTitle;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final String currentTitle = episode.series?.title.mainTitle ?? "";
    double fontTitleSize = 20;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isFirst
            ? Text(
                currentTitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontTitleSize),
              )
            : Container(),
        currentTitle != nextTitle ? const SizedBox(height: 10) : Container(),
        Row(
          children: [
            SizedBox(
                width: 150,
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => VideoScreen(
                                  title: episode.title,
                                  epNum: episode.epNum,
                                  source: handleSource(episode.sources),
                                )))
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      episode.thumbnail == ''
                          ? defaultImage("thumbnail")
                          : episode.thumbnail,
                      fit: BoxFit.fill,
                      height: 100,
                    ),
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            InfoEpisode(episode: episode)
          ],
        ),
        const SizedBox(height: 10),
        currentTitle != nextTitle
            ? Text(
                nextTitle!,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontTitleSize),
              )
            : Container(),
        currentTitle != nextTitle ? const SizedBox(height: 10) : Container(),
      ],
    );
  }
}
