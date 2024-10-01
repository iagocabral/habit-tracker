import 'package:flutter/material.dart';

class DaySelector extends StatefulWidget {
  final Function(List<String>) onDaysSelected;
  final Function onCancelSelection; // Adiciona uma função para o cancelamento

  DaySelector({required this.onDaysSelected, required this.onCancelSelection});

  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  List<String> _selectedDays = [];

  final List<String> _daysOfWeek = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado'
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selecione os dias para o hábito:'),
            Wrap(
              spacing: 8.0,
              children: _daysOfWeek.map((day) {
                final isSelected = _selectedDays.contains(day);
                return ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                    widget.onDaysSelected(_selectedDays); // Notifica os dias selecionados
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onCancelSelection(); // Chama a função de cancelamento
                    Navigator.pop(context); // Fecha o modal
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o modal
                  },
                  child: Text('Concluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}