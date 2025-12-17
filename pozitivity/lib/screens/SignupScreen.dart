import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pozitivity/screens/MainScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> signUp(
      String name, String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = credential.user;

      await user!.updateDisplayName(name);
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Kayıt başarılı! Hoş geldin ${user!.displayName}")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "";

      if (e.code == 'email-already-in-use') {
        message = "Bu email zaten kayıtlı!";
      } else if (e.code == 'invalid-email') {
        message = "Geçersiz email formatı!";
      } else if (e.code == 'weak-password') {
        message = "Şifre en az 6 karakter olmalı!";
      } else {
        message = "Hata: ${e.message}";
      }

      _showError(message);
    }
  }

  void _registerUser() async {
    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Lütfen tüm alanları doldurun!");
      setState(() => _isLoading = false);
      return;
    }

    await signUp(name, email, password, context);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const Color screenBackgroundColor = Color(0xFFF0F5F1);
    const Color primaryGreenColor = Color.fromARGB(163, 163, 190, 164);

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                'Hemen Kayıt Ol',
                style: const TextStyle(
                  fontSize: 38,
                  color: const Color.fromARGB(255, 175, 202, 176),
                  fontWeight: FontWeight.normal, // Düz yazı
                ),
              ),
            ),
            const SizedBox(height: 40),

            _buildInputField(
              label: 'Adınız Soyadınız',
              controller: _nameController,
            ),
            const SizedBox(height: 20),

            _buildInputField(
              label: 'E-posta Adresi',
              controller: _emailController,
            ),
            const SizedBox(height: 20),

            _buildInputField(
              label: 'Şifre Belirle',
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isLoading ? null : _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreenColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: _isLoading
                  ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
                  : const Text(
                'Kayıt Ol',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Zaten hesabın var mı?'),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Giriş Yap',
                    style: TextStyle(
                      color: Color.fromARGB(163, 163, 190, 164),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    const Color primaryGreenColor = Color.fromARGB(163, 163, 190, 164);
    bool _isPasswordVisible = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? !_isPasswordVisible : false,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              prefixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: primaryGreenColor,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
                  : Icon(
                label == 'Adınız Soyadınız'
                    ? Icons.person_outline
                    : Icons.email_outlined,
                color: primaryGreenColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
