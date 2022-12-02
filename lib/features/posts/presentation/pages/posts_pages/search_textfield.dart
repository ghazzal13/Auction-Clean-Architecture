import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool searchBoolean;
  const SearchTextField(
      {super.key, required this.controller, required this.searchBoolean});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState(
      controller: controller, searchBoolean: searchBoolean);
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController controller;
  bool searchBoolean;
  _SearchTextFieldState({
    required this.controller,
    required this.searchBoolean,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          AuctionCubit.get(context).getSearch(value);
        });
      },
      controller: controller,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
}
