import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:auction_clean_architecture/features/auction_event/cubit/states.dart';
import 'package:auction_clean_architecture/features/posts/presentation/widget/reuse_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  var userModel;
  @override
  void initState() {
    userModel = AuctionCubit.get(context).userData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionStates>(
        listener: (conttext, state) {},
        builder: (context, state) {
          var profileImage = AuctionCubit.get(context).profileImage;

          nameController.text = userModel.name!;
          emailController.text = userModel.email!;
          addressController.text = userModel.address!;
          Size size = MediaQuery.of(context).size;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Edit Profile'),
            ),
            body: Stack(
              children: [
                Container(
                  height: size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("asset/image/222.jpg"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (state is AuctionUserUpdateLoadingState)
                              const LinearProgressIndicator(),
                            if (state is AuctionUserUpdateLoadingState)
                              const SizedBox(
                                height: 10.0,
                              ),
                            Stack(
                              children: [
                                profileImage != null
                                    ? CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            FileImage(profileImage),
                                        backgroundColor: Colors.red,
                                      )
                                    : CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            NetworkImage('${userModel.image}'),
                                        backgroundColor: Colors.red,
                                      ),
                                Positioned(
                                  bottom: -10,
                                  left: 80,
                                  child: IconButton(
                                    onPressed: () {
                                      AuctionCubit.get(context)
                                          .getProfileImage();
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            defaultFormField(
                              controller: nameController,
                              type: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'name must not be empty';
                                }
                                return null;
                              },
                              label: 'name',
                              prefix: Icons.account_box,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              controller: emailController,
                              type: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'email must not be empty';
                                }
                                return null;
                              },
                              label: 'email',
                              prefix: Icons.alternate_email_outlined,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                controller: addressController,
                                type: TextInputType.text,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'address must not be empty';
                                  }
                                  return null;
                                },
                                label: 'address',
                                prefix: Icons.place),
                            const SizedBox(
                              height: 100.0,
                            ),
                            FloatingActionButton.extended(
                              onPressed: () {
                                if (profileImage != null) {
                                  AuctionCubit.get(context)
                                      .upLoadProfileImage();
                                }
                                if (formKey.currentState!.validate()) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({
                                    'name': nameController.text,
                                    'email': emailController.text,
                                    'address': addressController.text
                                  }, SetOptions(merge: true)).then((value) {
                                    AuctionCubit.get(context).getUserzData();
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              backgroundColor: Colors.teal,
                              icon: const Icon(Icons.save_outlined),
                              label: const Text(
                                'save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
