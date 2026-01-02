import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/app/routes/app_routes.dart';
import 'package:smart_health_care/core/utils/snackbar_utils.dart';
import 'package:smart_health_care/features/auth/presentation/pages/signup_screen.dart';
import 'package:smart_health_care/features/auth/presentation/state/auth_state.dart';
import 'package:smart_health_care/features/auth/presentation/view_models/auth_viewmodel.dart';
import 'package:smart_health_care/features/dashboard/presentation/pages/dashboard_screen.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
@override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();

  }
  Future<void> _handleLogin() async {

    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
    }


    
  }

   void _navigateToSignup() {
    AppRoutes.push(context, const SignUpScreen());
  }
  bool hidePassword = true;


  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, const DashboardScreen());
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFFD7F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

          
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(31, 0, 0, 0),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.local_pharmacy,
                          size: 60, color: Colors.green),
                      SizedBox(height: 8),
                      Text(
                        "Olala Health Care",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Login Here!!!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

               
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white), // ✅ WHITE TEXT
                  decoration: inputDecoration("Email", Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

           
                TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  style: const TextStyle(color: Colors.white), // ✅ WHITE TEXT
                  decoration: inputDecoration(
                    "Password",
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                
                SizedBox(
                  width: 170,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 9, 124, 217),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    TextButton(
                      onPressed: _navigateToSignup,
                      child: const Text("Sign Up Here"),
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

  
  InputDecoration inputDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFF3F51B5),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: suffix,
      hintStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }
}
