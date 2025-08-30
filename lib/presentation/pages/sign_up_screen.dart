import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/service/firebase/auth_exception_handler.dart';
import 'package:nutralyse_jd/service/firebase/authentication_service.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();

  final AuthenticationService _firebaseAuthService = AuthenticationService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedGender;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalLahirController.text =
        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  Future<void> handleSignUp() async {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String tanggalLahir = _tanggalLahirController.text.trim();
    String jenisKelamin = _selectedGender ?? '';

    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: "Password tidak sama");
      return;
    }

    if (jenisKelamin.isEmpty) {
      Fluttertoast.showToast(msg: "Pilih jenis kelamin");
      return;
    }

    final status = await _firebaseAuthService.signupWithEmailAndPassword(
      fullName: fullName,
      email: email,
      password: password,
      tanggalLahir: tanggalLahir,
      jenisKelamin: jenisKelamin,
    );

    if (status == AuthResultStatus.successful) {
      Fluttertoast.showToast(
        msg: "Daftar berhasil!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        context.go('/login');
      });
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      Fluttertoast.showToast(msg: errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Buat akun dan mulai perjalanan sehatmu",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Nama Lengkap
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Nama Lengkap",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Masukkan nama lengkap" : null,
                ),
                const SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Masukkan email" : null,
                ),
                const SizedBox(height: 15),

                // Tanggal Lahir
                TextFormField(
                  controller: _tanggalLahirController,
                  readOnly: true,
                  onTap: () => _pickDate(context),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    hintText: "Tanggal Lahir",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Masukkan tanggal lahir" : null,
                ),
                const SizedBox(height: 15),

                // Jenis Kelamin
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jenis Kelamin",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = 'Laki-laki';
                              });
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.male,
                                  color: _selectedGender == 'Laki-laki'
                                      ? Colors.blue
                                      : Colors.grey,
                                  size: 40,
                                ),
                                const SizedBox(height: 5),
                                const Text('Laki-laki'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = 'Perempuan';
                              });
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.female,
                                  color: _selectedGender == 'Perempuan'
                                      ? Colors.pink
                                      : Colors.grey,
                                  size: 40,
                                ),
                                const SizedBox(height: 5),
                                const Text('Perempuan'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Masukkan password" : null,
                ),
                const SizedBox(height: 15),

                // Konfirmasi Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    hintText: "Konfirmasi Password",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan konfirmasi password";
                    }
                    if (value != _passwordController.text) {
                      return "Password tidak sama";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4D47C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleSignUp();
                      }
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Sudah punya akun?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah Punya Akun ? "),
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
