import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroUsuarioAtividade extends StatefulWidget {
  @override
  _CadastroUsuarioAtividadeState createState() =>
      _CadastroUsuarioAtividadeState();
}

class _CadastroUsuarioAtividadeState extends State<CadastroUsuarioAtividade> {
  String? selectedUser; // Permit null value
  String? selectedActivity; // Permit null value
  DateTime? selectedDate; // Selected date
  double? nota; // Entered grade

  List<String> users = ['Anelly', 'Gabriela', 'Winicius'];
  List<String> activities = ['Atividade 1', 'Atividade 2', 'Atividade 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formulário',
          style: TextStyle(color: Colors.white), // Altera a cor do texto para branco
        ),
        backgroundColor: Colors.teal, // Define a cor da AppBar como teal
      ),
      backgroundColor: Colors.grey[200], // Set background color to gray
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: selectedUser,
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
              items: users.map((user) {
                return DropdownMenuItem<String>(
                  value: user,
                  child: Text(user),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Selecione um usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedActivity,
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                });
              },
              items: activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Selecione uma atividade',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Digite a nota',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    nota = double.tryParse(value);
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        textTheme: TextTheme(
                          bodyText1: TextStyle(color: Colors.white), // Altera a cor do texto
                        ),
                        colorScheme: ColorScheme.light(
                          primary: Colors.teal, // Altera a cor do botão de seleção de data
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Define a cor de fundo do botão
              ),
              child: Text(
                selectedDate != null
                    ? 'Data selecionada: ${selectedDate.toString().substring(0, 10)}'
                    : 'Selecionar Data',
                style: TextStyle(color: Colors.white), // Altera a cor do texto
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (selectedUser != null &&
                    selectedActivity != null &&
                    selectedDate != null &&
                    nota != null) {
                  print('Usuário selecionado: $selectedUser');
                  print('Atividade selecionada: $selectedActivity');
                  print('Data selecionada: $selectedDate');
                  print('Nota selecionada: $nota');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Aviso'),
                        content: Text(
                            'Por favor, selecione um usuário, uma atividade, uma data e insira uma nota.'),
                        backgroundColor: Colors.white, // Altera a cor de fundo do diálogo para grey[200]
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Define a cor de fundo do botão
              ),
              child: Text(
                'Vincular',
                style: TextStyle(color: Colors.white), // Altera a cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
