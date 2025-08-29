import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/common/config/storage.dart';
import 'package:nutralyse_jd/presentation/widget/form_container_widget.dart';
import 'package:nutralyse_jd/presentation/widget/loading_dialog.dart';
import 'package:nutralyse_jd/service/firebase/auth_exception_handler.dart';
import 'package:nutralyse_jd/service/firebase/authentication_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final AuthenticationService _firebaseAuthService = AuthenticationService();

  // Function to validate email format
  String? _validateEmail(String? value) {
    const emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Function to validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _firebaseAuthService.loginWithGoogle();

      // Get userId from secure storage
      String? userId = await SecureStorage().getUserId();

      // Check if user classification is complete
      bool isCompleteClassification =
      await _firebaseAuthService.isClassificationCompleted(userId!);

      if (isCompleteClassification) {
        context.go('/home');
      } else {
        context.go('/user-clasification');
      }
    } catch (e) {
      // Handle error (e.g., show a dialog or snackbar)
      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      LoadingDialog.showLoadingDialog(context, "Loading...");

      // Attempt to log in with email and password
      AuthResultStatus status =
      await _firebaseAuthService.loginWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Hide loading dialog
      LoadingDialog.hideLoadingDialog(context);

      // Handle the result
      if (status == AuthResultStatus.successful) {
        Fluttertoast.showToast(msg: "Successfully logged in!");

        // Get user ID from secure storage
        String? userId = await SecureStorage().getUserId();

        // Check if user classification is complete
        bool isCompleteClassification =
        await _firebaseAuthService.isClassificationCompleted(userId!);

        if (isCompleteClassification) {
          context.go('/home');
        } else {
          context.go('/user-clasification');
        }
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        Fluttertoast.showToast(msg: errorMsg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff8e2de2),
                Color(0xff4a00e0),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormContainerWidget(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        inputType: TextInputType.emailAddress,
                        isPasswordField: false,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.go('/forget-password');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xff281537),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(300, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: const Color(0xff4a00e0),
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _signInWithGoogle,
                        style: TextButton.styleFrom(
                          iconColor: Colors.black,
                          backgroundColor: Colors.grey[200],
                          minimumSize: const Size(300, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Login with Google',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          context.go('/sign-up');
                        },
                        child: const Text('Belum Memiliki Akun? Sign up'),
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
  }
}
