import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Para escolher um ícone da galeria

class CreateHabitView extends StatefulWidget {
  @override
  _CreateHabitViewState createState() => _CreateHabitViewState();
}

class _CreateHabitViewState extends State<CreateHabitView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedIconPath; // Armazena o caminho do ícone selecionado

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Novo Hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                // Permite ao usuário escolher uma imagem da galeria
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _selectedIconPath = pickedFile.path;
                  });
                }
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage: _selectedIconPath != null ? FileImage(File(_selectedIconPath!)) : null,
                child: _selectedIconPath == null ? Icon(Icons.add_a_photo, size: 40) : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Hábito'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição (Opcional)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  // Cria o hábito e navega de volta
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'iconPath': _selectedIconPath,
                  });
                } else {
                  print('Erro: O nome do hábito é obrigatório.');
                }
              },
              child: Text('Criar Hábito'),
            ),
          ],
        ),
      ),
    );
  }
}