import 'package:app/src/features/series/widget/description.dart';
import 'package:app/src/globals/user_data.dart';
import 'package:app/src/models/episodes.dart';
import 'package:app/src/utils/find_source.dart';
import 'package:flutter/material.dart';

//Widgets
import 'package:app/src/common_widgets/loading.dart';
import 'package:app/src/features/series/widget/action_button.dart';
import 'package:app/src/features/series/widget/content_header.dart';
import 'package:app/src/features/series/widget/video_trailer.dart';
import 'package:app/src/features/series/widget/list_episodes.dart';

//Services
import 'package:app/src/features/series/services/detail_series.dart';

//Models
import 'package:app/src/models/series.dart';
import 'package:flutter/services.dart';
import 'package:app/src/models/source.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key, required this.seriesTitle});

  final String seriesTitle;

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  late Series _detailSeries;
  final DetailSeriesService _detailSeriesService = DetailSeriesService();
  final double _paddingSize = 5;
  late bool loading = true;
  late Source source = Source(id: "", value: "", kind: "");
  late int epNum = 1;
  late String title = "";
  late Episode episode;

  @override
  void initState() {
    super.initState();

    _load();
  }

  void _load() async {
    _detailSeries =
        await _detailSeriesService.getDetails(title: widget.seriesTitle);
    if (_detailSeries.episodes!.isNotEmpty) {
      Episode currentUserEpisode = GlobalUserData()
          .currentlyWatching
          .firstWhere(
              (episode) =>
                  episode.series?.title.mainTitle ==
                  _detailSeries.title.mainTitle,
              orElse: () => Episode(id: "", title: "", epNum: 1));
      if (currentUserEpisode.id != "") {
        source = handleSource(currentUserEpisode.sources as List<Source>);
        epNum = currentUserEpisode.epNum;
        title = currentUserEpisode.title;
        episode = currentUserEpisode;
      } else {
        title = _detailSeries.episodes!.first.title;
        epNum = _detailSeries.episodes!.first.epNum;
        source =
            handleSource(_detailSeries.episodes!.first.sources as List<Source>);
        episode = _detailSeries.episodes!.first;
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: (loading)
          ? const Loading(message: "Getting data")
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                VideoTrailer(trailer: _detailSeries.trailer),
                const SizedBox(height: 10),
                ContentHeader(
                  series: _detailSeries,
                ),
                const SizedBox(height: 10),
                source.id != ''
                    ? ActionButton(
                        paddingSize: _paddingSize,
                        source: source,
                        title: title,
                        epNum: epNum,
                        episode: episode)
                    : Container(),
                const SizedBox(height: 10),
                DescriptionText(
                    description: _detailSeries.description ?? "",
                    paddingSize: _paddingSize),
                const SizedBox(height: 20),
                Padding(
                  padding:
                      EdgeInsets.only(left: _paddingSize, right: _paddingSize),
                  child: const Text(
                    "List Episodes",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListEpisodes(
                  episodes: _detailSeries.episodes ?? [],
                  paddingSize: _paddingSize,
                  duration: _detailSeries.duration ?? 0,
                )
              ],
            ),
    );
  }
}
