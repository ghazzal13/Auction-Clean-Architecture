import 'package:flutter/material.dart';

import '../../../features/auction_event/cubit/cubit.dart';
import '../../../features/posts/domain/entities/posts_entity.dart';

class PostBody extends StatelessWidget {
  final PostsEntity post1;
  const PostBody({Key? key, required this.post1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postmmm = AuctionCubit.get(context).postByID;
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.99,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('${post1.postImage}'),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text(
                  'Titel: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${post1.titel}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Category: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${post1.category}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Price: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${postmmm.price}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              child: Text(
                '${post1.description}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal[600],
                  fontWeight: FontWeight.w600,
                ),
                // maxLines: 5,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
