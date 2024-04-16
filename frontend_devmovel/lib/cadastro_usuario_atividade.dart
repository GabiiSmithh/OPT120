import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CadastroUsuarioAtividade extends StatefulWidget {
  @override
  _CadastroUsuarioAtividadeState createState() =>
      _CadastroUsuarioAtividadeState();
}

class _CadastroUsuarioAtividadeState extends State<CadastroUsuarioAtividade> {
  Map<String, dynamic>? selectedUser;
  Map<String, dynamic>? selectedActivity;
  DateTime? selectedDate;
  double? nota;

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchActivities();
  }

  Future<void> fetchUsers() async {
    try {
      var response =
          await http.get(Uri.parse('http://localhost:3024/usuario'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data.map<Map<String, dynamic>>((user) {
            return {
              'id': user['ID_USUARIO'],
              'nome': user['NOME'],
            };
          }).toList();
        });
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> fetchActivities() async {
    try {
      var response =
          await http.get(Uri.parse('http://localhost:3024/atividade'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          activities = data.map<Map<String, dynamic>>((activity) {
            return {
              'id': activity['ID_ATIVIDADE'],
              'titulo': activity['TITULO'],
              'descricao': activity['DESC'],
            };
          }).toList();
        });
      } else {
        print('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Usuário e Atividade',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedUser,
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
              items: users.map((user) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: user,
                  child: Text(user['nome']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Selecione um usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedActivity,
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                });
              },
              items: activities.map((activity) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: activity,
                  child: Text('${activity['titulo']} - ${activity['descricao']}'),
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
                          bodyText1: TextStyle(color: Colors.white),
                        ),
                        colorScheme: ColorScheme.light(
                          primary: Colors.teal,
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
                backgroundColor: Colors.teal,
              ),
              child: Text(
                selectedDate != null
                    ? 'Data selecionada: ${selectedDate.toString().substring(0, 10)}'
                    : 'Selecionar Data',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (selectedUser != null &&
                    selectedActivity != null &&
                    selectedDate != null &&
                    nota != null) {
                  Map<String, dynamic> requestBody = {
                    'usuarioId': selectedUser!['id'].toString(),
                    'atividadeId': selectedActivity!['id'].toString(),
                    'dataEntrega': selectedDate!.toString(),
                    'nota': nota!.toString(),
                  };

                  try {
                    var response = await http.post(
                      Uri.parse('http://localhost:3024/usuario-atividade'),
                      body: requestBody,
                    );

                    if (response.statusCode == 200) {
                      print('Request successful');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Sucesso!'),
                            content: Text('Atividade vinculada com sucesso!'),
                            backgroundColor: Colors.white,
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
                    } else {
                      print(
                          'Request failed with status: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error: $e');
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Aviso'),
                        content: Text(
                          'Por favor, selecione um usuário, uma atividade, uma data e insira uma nota.',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.white,
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
                backgroundColor: Colors.teal,
              ),
              child: Text(
                'Vincular',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CadastroUsuarioAtividade(),
  ));
}
