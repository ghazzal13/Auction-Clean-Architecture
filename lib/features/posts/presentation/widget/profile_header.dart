import 'package:flutter/material.dart';

Widget profileHeader(
  context, {
  required String image,
  required String name,
  required String email,
}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                height: 70.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      4.0,
                    ),
                    topRight: Radius.circular(
                      4.0,
                    ),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 64.0,
              backgroundColor: Colors.white70,
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(image),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          email,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    ),
  );
}
