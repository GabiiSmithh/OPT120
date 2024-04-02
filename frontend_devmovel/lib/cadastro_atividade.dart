import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Atividade'),
        backgroundColor: Colors.teal, // Altera a cor da barra superior
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Define a cor de fundo desejada
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5, // Define a largura do TextField
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Título',
                    hintText: 'Digite o título da atividade',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal), // Altera a cor da linha
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5, // Define a largura do TextField
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Digite a descrição da atividade',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal), // Altera a cor da linha
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
                width: MediaQuery.of(context).size.width * 0.4, // Define a largura do ElevatedButton
                child: ElevatedButton(
                  onPressed: () {
                    // Implementar a lógica de salvar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Altera a cor de fundo do botão
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white), // Altera a cor do texto do botão
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
