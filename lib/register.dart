import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kostgo/home.dart';
import 'screens/home_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("images/register.png", fit: BoxFit.cover),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 95),
                Center(
                  child: Text("Daftar Akun",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    "Isi data registrasi berikut dengan benar",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 31),
                _buildTextField(_namaController, "Masukkan nama", "images/nama.png"),
                const SizedBox(height: 26),
                _buildTextField(_emailController, "Masukkan email", "images/username.png"),
                const SizedBox(height: 26),
                _buildTextField(_passwordController, "Masukkan password", "images/blocked.png", obscureText: true),
                const SizedBox(height: 40),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      _buildButton("Daftarkan", _handleRegister, Colors.white, const Color(0xFF4C6496)),
                      const SizedBox(height: 20),
                      _buildButton("Sign in with Google", _signInWithGoogle, const Color(0xFF4C6496), Colors.white),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, String iconPath, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFFC9C9C9), fontSize: 14),
          prefixIcon: Image.asset(iconPath),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Mohon isi data';
          if (hint.contains("email") && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Email tidak valid';
          if (hint.contains("password") && value.length < 8) return 'Minimal 8 karakter';
          return null;
        },
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color textColor, Color bgColor) {
    return Container(
      width: 350,
      height: 70,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(30)),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'nama': _namaController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'buyer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Registrasi berhasil!", backgroundColor: Colors.green, textColor: Colors.white);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e", backgroundColor: Colors.red, textColor: Colors.white);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _isLoading = true);
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'nama': user.displayName,
          'role': 'buyer',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Fluttertoast.showToast(msg: "Login berhasil!", backgroundColor: Colors.green, textColor: Colors.white);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e", backgroundColor: Colors.red, textColor: Colors.white);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
