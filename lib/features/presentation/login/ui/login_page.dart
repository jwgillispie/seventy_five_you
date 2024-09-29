import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/presentation/login/bloc/login_bloc.dart';
import 'package:seventy_five_hard/features/presentation/widgets/form_container_widget.dart';
import 'package:seventy_five_hard/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:seventy_five_you/lib/features/presentation/profile/ui/profile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginBloc loginBloc = LoginBloc();
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Fluttertoast.showToast(msg: "Hello motherucker");
          // add the day object to the backend w bloc
          Navigator.pushReplacementNamed(context, "/home");
        } else if (state is LoginFailureState) {
          Fluttertoast.showToast(msg: state.message);
        } else if (state is LoginNavigateToSignupState) {
          Navigator.pushReplacementNamed(context, "/signUp");
        } else if (state is LoginNavigateToHomeState) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      },
      builder: (context, state) {
        if (state is LoginLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LoginInitialState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 30,
                    ),
                    FormContainerWidget(
                      controller: _emailController,
                      hintText: "Email",
                      isPasswordField: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormContainerWidget(
                      controller: _passwordController,
                      hintText: "Password",
                      isPasswordField: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        loginBloc.add(LoginButtonPressedEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim()));
                        loginBloc.add(
                            LoginNavigateToHomeEvent(firebaseUid: user!.uid));
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
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Don't have an account?"),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          loginBloc.add(LoginNavigateToSignupEvent());
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Error"),
            ),
          );
        }
      },
    );
  }

  // void _signIn() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text.trim();

  //   User? user = await _auth.signInWithEmailAndPassword(email, password);
  //   setState(() {
  //     _isLoading = false;
  //   });

  //   if (user != null) {
  //     Fluttertoast.showToast(msg: "Hello motherfucker");

  //     // Check if the user already has a day created for today
  //     DateTime today = DateTime.now();
  //     String formattedDate = "${today.year}-${today.month}-${today.day}";
  //     bool dayExists = await checkIfDayExists(user.uid, formattedDate);
  //     // If the day doesn't exist, create a new Day object
  //     if (!dayExists) {
  //       await createNewDay(user.uid, formattedDate);
  //     }

  //     Navigator.pushReplacementNamed(context, "/home");
  //   } else {
  //     Fluttertoast.showToast(msg: "Sign In Failed");
  //   }
  // }

  // Future<bool> checkIfDayExists(String firebaseUid, String date) async {
  //   final response = await http
  //       .get(Uri.parse('http://10.0.2.2:8000/day/$firebaseUid/$date'));

  //   if (response.statusCode == 200) {
  //     // If the response status code is 200, check if the response body contains day data
  //     Map<String, dynamic> responseData = json.decode(response.body);
  //     return responseData.isNotEmpty;
  //   } else if (response.statusCode == 404) {
  //     // If the response status code is 404, the day doesn't exist
  //     print("${date}not found");
  //     return false;
  //   } else {
  //     // If the request fails for some other reason, return false
  //     print("${date}not found");
  //     return false;
  //   }
  // }

  // Future<void> createNewDay(String firebaseUid, String date) async {
  //   DateTime today = DateTime.now();
  //   String formattedDate = "${today.year}-${today.month}-${today.day}";
  //   Uri dayUrl = Uri.parse(
  //       "http://10.0.2.2:8000/day/"); // Replace with your backend API URL for day object
  //   Map<String, String> dayHeaders = {
  //     'Content-Type': 'application/json',
  //   };
  //   Map<String, dynamic> dayBody = {
  //     'date': formattedDate, // Set the date to current date
  //     'firebase_uid': firebaseUid,
  //     'diet': [],
  //     'outside_workout': [],
  //     'second_workout': [],
  //     'water': 0,
  //     'alcohol': 0,
  //     'pages': 0,
  //   };

  //   final dayResponse = await http.post(
  //     dayUrl,
  //     headers: dayHeaders,
  //     body: jsonEncode(dayBody),
  //   );

  //   if (dayResponse.statusCode == 200) {
  //     print("Day object successfully sent to backend");
  //     Navigator.pushReplacementNamed(context, "/home");
  //   } else {
  //     print("Failed to send day object to backend: ${dayResponse.statusCode}");
  //   }

  // }
}
