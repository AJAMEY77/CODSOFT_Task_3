import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/controller/player_controller.dart';
import 'package:musicapp/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: Colors.white,
          ),
          title: const Text(
            'Beats',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: "bold"),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Song "),
              );
            } else {
              // print(snapshot.data);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.only(bottom: 4.0),
                        child: Obx(
                          () => ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            tileColor: Colors.blue[100],
                            title: Text(
                              snapshot.data![index].displayNameWOExt,
                              style:
                                  TextStyle(fontFamily: "bold", fontSize: 14),
                            ),
                            subtitle: Text(
                              "${snapshot.data![index].artist}",
                              style:
                                  TextStyle(fontFamily: "bold", fontSize: 12),
                            ),
                            leading: QueryArtworkWidget(
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                color: Colors.blue,
                                size: 32,
                              ),
                            ),
                            trailing: controller.playIndex == index &&
                                    controller.isPlaying.value
                                ? Icon(
                                    Icons.play_arrow,
                                    color: Colors.blue,
                                    size: 26,
                                  )
                                : null,
                            onTap: () {
                              Get.to(
                                  () => Player(
                                        data: snapshot.data!,
                                      ),
                                  transition: Transition.downToUp);

                              controller.playSong(
                                  snapshot.data![index].uri, index);
                            },
                          ),
                        ));
                  },
                ),
              );
            }
          },
        ));
  }
}
