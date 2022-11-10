import 'package:auction_clean_architecture/core/strings/failures.dart';
import 'package:flutter/material.dart';

Widget offlineWidget() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.wifi_off,
            size: 50,
          ),
          SizedBox(
            height: 30,
          ),
          Text(OFFLINE_FAILURE_MESSAGE),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
