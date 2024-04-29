import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroAtividadeScreen extends StatefulWidget {
  const CadastroAtividadeScreen({Key? key}) : super(key: key);

  @override
  _CadastroAtividadeScreenState createState() =>
      _CadastroAtividadeScreenState();
}

class _CadastroAtividadeScreenState extends State<CadastroAtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  late DateTime _dataEntrega;

  double screenWidth = 0.0;
  double screenHeight = 0.0;
  final _dataEntregaController = TextEditingController();
  bool _dataEntregaError = false;

  @override
  void initState() {
    super.initState();
    _dataEntrega = DateTime.now();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dataEntrega,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dataEntrega),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        setState(() {
          _dataEntrega = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
          _updateDataEntregaText();
        });
      }
    }
  }

  void _updateDataEntregaText() {
    final formattedDate = '${_dataEntrega.day.toString().padLeft(2, '0')}/'
        '${_dataEntrega.month.toString().padLeft(2, '0')}/'
        '${_dataEntrega.year.toString().substring(2)} '
        '${_dataEntrega.hour.toString().padLeft(2, '0')}:'
        '${_dataEntrega.minute.toString().padLeft(2, '0')}';
    _dataEntregaController.text = formattedDate;
    setState(() {
      _dataEntregaError = false;
    });
  }

  void _showSnackBarMessage(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: Text(message),
          actions: <Widget>[
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


  Future<void> _cadastrarAtividade() async {
    final titulo = _tituloController.text;
    final descricao = _descricaoController.text;
    final dataEntrega = _dataEntrega.toString();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3024/api/atividade'),
        body: {'titulo': titulo, 'descricao': descricao, 'data': dataEntrega},
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final message = jsonResponse['message'] as String;
        print('Atividade cadastrada com sucesso');
        _showSnackBarMessage(context, message, backgroundColor: Colors.white);
      } else {
        final errorMessage = jsonResponse['erro'] as String;
        print('Erro ao cadastrar atividade: $errorMessage');
        _showSnackBarMessage(context, errorMessage,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      final errorMessage = 'Erro durante a solicitação: $e';
      _showSnackBarMessage(context, errorMessage, backgroundColor: Colors.red);
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Cadastro de Atividade',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.teal,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.2,
            horizontal: screenWidth * 0.1,
          ),
          child: Center(
            child: SizedBox(
              width: screenWidth * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um título';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _descricaoController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Descrição da Atividade',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                          prefixIcon: Icon(Icons.description),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma descrição';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextFormField(
                              controller: _dataEntregaController,
                              readOnly: true,
                              onTap: () => _selectDateTime(context),
                              style: TextStyle(
                                  color: _dataEntregaError
                                      ? Colors.red
                                      : Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Data de Entrega',
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                prefixIcon: Icon(Icons.calendar_today),
                                errorText: _dataEntregaError
                                    ? 'Por favor, insira uma data de entrega'
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _dataEntregaError =
                              _dataEntregaController.text.isEmpty;
                        });
                        if (_formKey.currentState!.validate() &&
                            !_dataEntregaError) {
                          _cadastrarAtividade();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02),
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
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
