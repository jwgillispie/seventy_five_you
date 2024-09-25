// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/presentation/signup/bloc/signup_bloc.dart';
import 'package:seventy_five_hard/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:seventy_five_hard/features/presentation/widgets/form_container_widget.dart';
import 'package:seventy_five_hard/features/presentation/login/ui/login_page.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _isLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final SignupBloc signupBloc = SignupBloc();
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      bloc: signupBloc,
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pushReplacementNamed(context, "/home");
        } else if (state is SignupFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("X" + state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is SignupNavigateToLoginState) {
          Navigator.pushReplacementNamed(context, "/login");
        }
      },
      builder: (context, state) {
        if (state is SignupLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Sign Up"),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is SignupInitial) {
          print("SignupInitial");
          return Scaffold(
            appBar: AppBar(
              title: Text("Sign Up"),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign Up",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 30,
                      ),
                      FormContainerWidget(
                        controller: _usernameController,
                        hintText: "Username",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _emailController,
                        hintText: "Email",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _passwordController,
                        hintText: "Password",
                        isPasswordField: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _firstNameController,
                        hintText: "First Name",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormContainerWidget(
                        controller: _lastNameController,
                        hintText: "Last Name",
                        isPasswordField: false,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("button pressed");
                          signupBloc.add(SignupButtonPressedEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              username: _usernameController.text.trim(),
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              days: []));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("login oressed");
                                signupBloc.add(SignupNavigateToLoginEvent());
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          print("Unknown state");
          return Container();
        }
      },
    );
  }
}

//   void _signUp() async {
//     setState(() {
//       _isLoading = true;
//     });

//     String username = _usernameController.text.trim();
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//     String firstName = _firstNameController.text.trim();
//     String lastName = _lastNameController.text.trim();

//     try {
//       User? user = await _auth.signUpWithEmailAndPassword(email, password);

//       setState(() {
//         _isLoading = false;
//       });

//       if (user != null) {
//         print("User signed up successfully");

//         // Send user data to the backend
//         bool userDataSent = await sendUserDataToBackend(
//             user.uid, username, email, firstName, lastName);

//         if (userDataSent) {
//           print("User data successfully sent to backend");

//           // Send day object to the backend
//           bool dayObjectSent = await createNewDay(user.uid);

//           if (dayObjectSent) {
//             print("Day object successfully sent to backend---");
//             Navigator.pushReplacementNamed(context, "/home");
//           } else {
//             print("Failed to send day object to backend");
//           }
//         } else {
//           print("Failed to send user data to backend");
//         }
//       } else {
//         print("Sign Up Failed");
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error during sign up: $e");
//     }
//   }

//   // Future<bool> sendUserDataToBackend(String firebaseUid, String username,
//   //     String email, String firstName, String lastName) async {
//   //   Uri userUrl = Uri.parse("http://10.0.2.2:8000/user/");
//   //   Map<String, String> userHeaders = {
//   //     'Content-Type': 'application/json',
//   //   };
//   //   Map<String, dynamic> userBody = {
//   //     'firebase_uid': firebaseUid,
//   //     'display_name': username,
//   //     'email': email,
//   //     'first_name': firstName,
//   //     'last_name': lastName,
//   //   };

//   //   try {
//   //     final userResponse = await http.post(
//   //       userUrl,
//   //       headers: userHeaders,
//   //       body: jsonEncode(userBody),
//   //     );
//   //     return userResponse.statusCode == 200;
//   //   } catch (e) {
//   //     print("Error sending user data to backend: $e");
//   //     return false;
//   //   }
//   // }

//   Future<bool> createNewDay(String firebaseUid) async {
//     DateTime today = DateTime.now();
//     String formattedDate = "${today.year}-${today.month}-${today.day}";
//     Uri dayUrl = Uri.parse(
//         "http://localhost:8000/day/"); // Replace with your backend API URL for day object
//     Map<String, String> dayHeaders = {
//       'Content-Type': 'application/json',
//     };
//     Map<String, dynamic> dayBody = {
//       'date': formattedDate, // Set the date to current date
//       'firebase_uid': firebaseUid,
//       'diet': [],
//       'outside_workout': [],
//       'second_workout': [],
//       'water': 0,
//       'alcohol': 0,
//       'pages': 0,
//     };

//     final dayResponse = await http.post(
//       dayUrl,
//       headers: dayHeaders,
//       body: jsonEncode(dayBody),
//     );

//     if (dayResponse.statusCode == 200) {
//       print("Day object successfully sent to backend");
//       return true;
//     } else {
//       print("Failed to send day object to backend: ${dayResponse.statusCode}");
//       return false;
//     }
//   }
// }

