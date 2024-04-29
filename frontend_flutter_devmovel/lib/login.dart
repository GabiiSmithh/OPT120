import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:crypto/crypto.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showSnackBarMessage(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _realizarLogin() async {
    final email = _emailController.text;
    final senha = _senhaController.text;

    String hashedPassword = hashPassword(senha);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3024/api/login'),
        body: {'email': email, 'senha': hashedPassword},
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final token = jsonResponse['token'] as String;
        html.window.localStorage['token'] = token;

        final message = jsonResponse['message'] as String;
        print('Login realizado com sucesso');
        _showSnackBarMessage(context, message, backgroundColor: Colors.green);
        html.window.location.reload();
      } else {
        final errorMessage = jsonResponse['erro'] as String;
        print('Erro durante o login: $errorMessage');
        _showSnackBarMessage(context, errorMessage,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print('Erro durante a solicitação: $e');
      _showSnackBarMessage(context, 'Erro durante a solicitação: $e',
          backgroundColor: Colors.red);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Login'),
    ),
    body: Container(
      decoration: BoxDecoration(
        color: Colors.teal, // Set background color to teal
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white, // Set background color of the white box
              borderRadius: BorderRadius.circular(10.0), // Add rounded corners
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Bem Vindo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal, // Set text color to teal
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      controller: _senhaController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _realizarLogin();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      backgroundColor: Colors.white, // Altera a cor do texto para branco
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastroUsuario');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal, // Set button text color to teal
                    ),
                    child: Text('Cadastre-se'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}