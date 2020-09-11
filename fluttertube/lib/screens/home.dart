import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VideosBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          height: 30.0,
          child: Image.asset(
            "images/youtube.png",
            fit: BoxFit.fitHeight,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider
                  .of<FavoriteBloc>(context)
                  .outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "${snapshot.data.length}",
                    style: TextStyle(color: Colors.black54),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Favorites())
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black54,
            ),
            onPressed: () async {
              String result =
              await showSearch(context: context, delegate: DataSearch());
              if (result != null) bloc.inSearch.add(result);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        initialData: [],
        stream: bloc.outVideos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                } else if (index > 1) {
                  bloc.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
