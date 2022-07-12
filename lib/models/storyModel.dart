import 'package:meta/meta.dart';

enum MediaType {
  image,
  video,
  text,
}

class Story {
  String id;
  String description;
  Map tag;
  int type;
  MediaType media;
  String url;
  String deadLine;
  Duration duration = Duration(seconds: 10);

  var user;

  Story({
    @required this.id,
    @required this.description,
    @required this.tag,
    @required this.type,
    @required this.media,
    @required this.url,
    @required this.user,
    this.duration,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'description': description,
      'tag': tag,
      'imageUrl': url,
      'type': type,
      'user': user,
      'deadLine': deadLine,
    };
  }

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    tag = json['tag'];
    url = json['imageUrl'];
    type = json['type'];
    user = json['user'];
    deadLine = json['deadline'];
    if (json['type'] == 0) {
      if (json['isImage']) {
        media = MediaType.image;
      } else {
        media = MediaType.video;
      }
    } else {
      media = MediaType.text;
    }
  }
}
