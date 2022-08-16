import 'dart:io';

import 'package:auction_clean_architecture/core/strings/messages.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/user.dart';
import 'package:auction_clean_architecture/features/posts/presentation/blocs/posts_bloc.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../../authentication/cubit/auth_methoed.dart';
import '../../../domain/entities/posts_entity.dart';
import '../../widget/reuse_widget.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  var formkey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController titel = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController price = TextEditingController();
  DateTime mazadTime = DateTime(1, 1, 1, 1);
  late String category;
  late bool _isLoading = false;
  String dropdownValue = 'Cars';

  @override
  void dispose() {
    super.dispose();
    titel.dispose();
    description.dispose();
    price.dispose();
  }

  File? postImage;
  var picker = ImagePicker();
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        postImage = File(pickedFile.path);
      });
    } else {}
  }

  void removePostImage() {
    setState(() {
      postImage = null;
    });
  }

  late String postImageUrl;

  Future Upload(File? postImage) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        postImageUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userModel = AuthCubit.get(context).userData;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text(
          '  Add Post',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                postImage != null
                    ? Stack(
                        children: [
                          SizedBox(
                            height: 200.0,
                            width: 200.0,
                            child: Container(
                              child: Image.file(
                                postImage!,
                                fit: BoxFit.cover,
                              ),
                              //   AspectRatio(
                              // aspectRatio: 4 / 451,
                            ),
                          ),
                          Positioned(
                            top: 1,
                            right: 1,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  removePostImage();
                                });
                              },
                              icon: const Icon(Icons.close_rounded, size: 25),
                            ),
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            getPostImage();
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.photo_library_outlined),
                            Text(
                              'addPhoto',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 30.0,
                ),
                reuseFormField(
                  controller: titel,
                  type: TextInputType.text,
                  validate:
                      ValidationBuilder(requiredMessage: 'can not be emity')
                          .build(),
                  label: 'Titel',
                ),
                const SizedBox(
                  height: 30.0,
                ),
                reuseFormField(
                  controller: description,
                  type: TextInputType.emailAddress,
                  validate:
                      ValidationBuilder(requiredMessage: 'can not be emity')
                          .build(),
                  label: ' Description',
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: reuseFormField(
                        controller: price,
                        type: TextInputType.number,
                        validate: ValidationBuilder(
                                requiredMessage: 'can not be emity')
                            .build(),
                        label: 'Price',
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SelectCategory(),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SelectDate(),
                const SizedBox(
                  height: 30.0,
                ),
                AddButton(userModel),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SelectDate() => TextButton(
        onPressed: () {
          DatePicker.showDateTimePicker(context, showTitleActions: true,
              onChanged: (date) {
            formatDate(date, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
            mazadTime = date;
            print('change $date in time zone ${date.timeZoneOffset.inHours}');
          }, onConfirm: (date) {
            print('confirm $date');
            setState(() {
              mazadTime = date;
            });
          },
              maxTime: DateTime.now().add(const Duration(days: 20)),
              minTime: DateTime.now(),
              currentTime: DateTime.now());
        },
        child: mazadTime != DateTime(1, 1, 1, 1)
            ? Text(' ${DateFormat.yMd().add_jm().format(mazadTime)}',
                style: const TextStyle(color: Colors.blue))
            : const Text(
                'select date',
                style: TextStyle(color: Colors.blue),
              ),
      );

  Widget AddButton(UserModel userModel) => FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          if (postImage != null) {
            DateTime now = DateTime.now();
            if (formkey.currentState!.validate()) {
              if (mazadTime != DateTime(1, 1, 1, 1)) {
                firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child(
                        'posts/${Uri.file(postImage!.path).pathSegments.last}')
                    .putFile(postImage!)
                    .then((p0) {
                  p0.ref.getDownloadURL().then((value) {
                    final post = PostsEntity(
                      name: userModel.name,
                      uid: userModel.uid,
                      image: userModel.image,
                      price: int.parse(price.text),
                      titel: titel.text,
                      startdate: mazadTime,
                      enddate: mazadTime.add(const Duration(days: 3)),
                      postTime: DateTime.now(),
                      category: dropdownValue.toString(),
                      description: description.text,
                      winner: 'winner',
                      winnerID: 'winnerID',
                      postImage: value,
                    );
                    BlocProvider.of<PostsBloc>(context).add(AddPostEvent(
                      post: post,
                    ));
                  }).then((_) {
                    showSnackBar(context, ADD_SUCCESS_MESSAGE);
                    removePostImage();
                    mazadTime = DateTime(1, 1, 1, 1);
                    titel.clear();
                    price.clear();
                    description.clear();
                    _isLoading = false;
                  });
                });
              } else {
                setState(() {
                  _isLoading = false;
                });
                showToast(text: 'select date', state: ToastStates.ERROR);
              }
            }
          } else {
            setState(() {
              _isLoading = false;
            });
            showToast(text: 'Add Image', state: ToastStates.ERROR);
          }
        },
        label: !_isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Text(
                      'Add',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            : const CircularProgressIndicator(
                color: (Colors.white),
              ),
      );

  Widget SelectCategory() => DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Color.fromARGB(255, 9, 87, 65)),
        underline: Container(
          height: 2,
          color: const Color.fromARGB(255, 10, 137, 97),
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>[
          'Cars',
          'Mobiles',
          'Antiques',
          'Paintings',
          'Furniture',
          'Electrical Devices',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
}
