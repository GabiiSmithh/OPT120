import 'package:flutter/material.dart';

class CadastroUsuarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTextFieldWithLabel("Nome", Icons.person),
            SizedBox(height: 20),
            _buildTextFieldWithLabel("Email", Icons.email),
            SizedBox(height: 20),
            _buildTextFieldWithLabel("Senha", Icons.lock, obscureText: true),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Implementar a lógica de salvar
              },
              icon: Icon(Icons.save),
              label: Text('Salvar', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(String labelText, IconData iconData,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 20),
            SizedBox(width: 8),
            Text(
              labelText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(maxWidth: 300), // Define o tamanho máximo
          child: TextFormField(
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: 'Digite seu $labelText',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.purple[50],
            ),
          ),
        ),
      ],
    );
  }
}
