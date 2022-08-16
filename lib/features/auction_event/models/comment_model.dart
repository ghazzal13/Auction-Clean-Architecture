class CommentModel {
  String? uid;
  String? postId;
  String? name;
  String? image;
  DateTime? dateTime;
  String? comment;
  String? commentId;

  CommentModel({
    this.uid,
    this.name,
    this.image,
    this.dateTime,
    this.postId,
    this.comment,
    this.commentId,
  });

  factory CommentModel.fromMap(map) {
    return CommentModel(
      uid: map['uid'],
      name: map['name'],
      image: map['image'],
      dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
      postId: map['postId'],
      comment: map['comment'],
      commentId: map['commentId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'image': image,
        'dateTime': dateTime,
        'postId': postId,
        'comment': comment,
        'commentId': commentId,
      };
}
