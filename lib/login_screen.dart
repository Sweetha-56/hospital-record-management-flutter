import 'package:flutter/material.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;

  void login() {
    String username =
        usernameController.text.trim();

    String password =
        passwordController.text.trim();

    if (username == "admin" &&
        password == "admin123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const DashboardScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid Username or Password",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hospital Login",
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_hospital,
                  size: 100,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Hospital Record Management",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller:
                      usernameController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Username",
                    prefixIcon:
                        Icon(Icons.person),
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller:
                      passwordController,
                  obscureText:
                      obscurePassword,
                  onSubmitted: (_) =>
                      login(),
                  decoration:
                      InputDecoration(
                    labelText:
                        "Password",
                    prefixIcon:
                        const Icon(
                      Icons.lock,
                    ),
                    suffixIcon:
                        IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons
                                .visibility
                            : Icons
                                .visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },
                    ),
                    border:
                        const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}