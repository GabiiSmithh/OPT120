import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Atividade',
      theme: ThemeData(
        primaryColor: Colors.teal,
        hintColor: Colors.tealAccent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.teal),
          bodyText1: TextStyle(fontSize: 16.0, color: Colors.black87),
          button: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      home: CadastroAtividadePage(),
    );
  }
}

class CadastroAtividadePage extends StatefulWidget {
  @override
  _CadastroAtividadePageState createState() => _CadastroAtividadePageState();
}

class _CadastroAtividadePageState extends State<CadastroAtividadePage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Atividade Salva!"),
          content: Text("Sua atividade foi salva com sucesso!"),
          backgroundColor: Colors.white, // Alterando a cor de fundo para branco
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro de Atividade',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    hintText: 'Digite o título da atividade',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Digite a descrição da atividade',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Data de Entrega:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse('http://localhost:3024/atividade');
                    final response = await http.post(
                      url,
                      body: {
                        'TITULO': _titleController.text,
                        'DESC': _descriptionController.text,
                        'DATA': _selectedDate.toIso8601String(),
                      },
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      _showSuccessDialog(context);
                    } else {
                      print('Falha ao salvar a atividade. Erro: ${response.statusCode}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
