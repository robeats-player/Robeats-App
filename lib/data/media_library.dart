import 'dart:collection';
import 'dart:io';

import 'package:Robeats/data/song_data_controller.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/network/media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_tags/dart_tags.dart';

class MediaLibrary {
  AudioPlayer audioPlayer;
  Set<Song> _songSet = Set();
  Queue _songQueue = Queue();

  MediaLibrary() {
    loadAudioPlayer();
    loadSongs();
  }

  Set<Song> get songSet => _songSet;

  Queue<Song> get songQueue => _songQueue;

  Future<Directory> get directory async {
    Directory appDataDirectory = await getMediaDirectory();
    return Directory(appDataDirectory.path + "/" + "music");
  }

  void loadAudioPlayer() {
    audioPlayer = AudioPlayer();
    //todo: more loading...
  }

  void loadSongs() async {
    List<FileSystemEntity> entities = (await this.directory).listSync(
        recursive: true);

    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        Tag metaTags = await _metaTags(entity);

        String fileName = _getFileName(entity);
        String songTitle = metaTags.tags['title'];
        String artist = metaTags.tags['artist'];

        _songSet.add(Song(
            fileName, songTitle, artist, Duration(minutes: 1)
        ));
      }
    }
  }

  void playQueue() {
    //todo: implement.
  }

  void playSong(Song song) async {
    String url = await song.directory;
    PlayingSong playingSong = PlayingSong(song);

    stop();
    audioPlayer.play(url, volume: 0.35); //todo: implement volume.
    _updateSink(playingSong);
  }

  void playPlaylist(Playlist playlist) {
    _songQueue.clear();
    _songQueue.addAll(playlist.songs);

    playQueue();
  }

  void stop() {
    SongDataController dataController = Robeats.songDataController;

    dataController.songSink.add(null);
    audioPlayer.stop();
  }

  void shuffle() {
    //todo: implement.
  }

  void loop(Song song) {
    //todo: implement.
  }

  void _updateSink(PlayingSong song) {
    SongDataController dataController = Robeats.songDataController;
    dataController.songSink.add(song);
  }

  static String _getFileName(FileSystemEntity entity) {
    return entity.path
        .split('/')
        .last;
  }

  static Future<Tag> _metaTags(File file) async {
    TagProcessor tagProcessor = TagProcessor();
    List<Tag> tags = await tagProcessor.getTagsFromByteArray(
        file.readAsBytes(),
        [TagType.id3v2]
    );

    return tags.isNotEmpty ? tags[0] : null;
  }
}