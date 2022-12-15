import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:flutter/material.dart';

class PostRowHeder extends StatelessWidget {
  final String name;
  final String image;
  final String date;
  final String userId;
  final PostsEntity post;
  PostRowHeder(
      {Key? key,
      required this.name,
      required this.image,
      required this.date,
      required this.userId,
      required this.post})
      : super(key: key);

  bool isMyPost = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.teal,
          backgroundImage: NetworkImage(image),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.teal[600],
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              date,
              // '${post1['postdate']}',
              style: TextStyle(
                color: Colors.teal[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
