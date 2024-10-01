import 'package:flutter/material.dart';
import '../../models/habit_category.dart';
import '../../data/habit_categories.dart';
import 'day_selector.dart'; // Importe o arquivo DaySelector
import 'create_habit_view.dart'; // Importe o arquivo de criação de hábito

class HabitSelectionView extends StatefulWidget {
  @override
  _HabitSelectionViewState createState() => _HabitSelectionViewState();
}

class _HabitSelectionViewState extends State<HabitSelectionView> {
  List<HabitCategory> selectedCategories = [];
  Map<HabitCategory, List<String>> habitDays = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha seus Hábitos'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: habitCategories.length + 1, // Adiciona +1 para o card de criar hábito
        itemBuilder: (context, index) {
          if (index == habitCategories.length) {
            // Adiciona o botão de criação de hábito personalizado
            return GestureDetector(
              onTap: () async {
                // Navega para a tela de criação de hábito
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateHabitView()),
                );

                // Se o usuário criou um hábito, ele é adicionado à lista
                if (result != null) {
                  setState(() {
                    habitCategories.add(HabitCategory(
                      name: result['name'],
                      description: result['description'] ?? '',
                      iconPath: result['iconPath'] ?? 'assets/icons/default.png', // Ícone padrão se nenhum for escolhido
                    ));
                  });
                }
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.green, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 50, color: Colors.green),
                    SizedBox(height: 10),
                    Text(
                      'Criar Hábito',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }

          final category = habitCategories[index];
          final isSelected = selectedCategories.contains(category);

          return GestureDetector(
            onTap: () {
              // Exibe o card de seleção de dias ao clicar em um hábito
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return DaySelector(
                    onDaysSelected: (selectedDays) {
                      setState(() {
                        habitDays[category] = selectedDays;
                        if (!selectedCategories.contains(category)) {
                          selectedCategories.add(category);
                        }
                      });
                    },
                    onCancelSelection: () {
                      // Função de cancelamento - remove o hábito da lista
                      setState(() {
                        selectedCategories.remove(category);
                        habitDays.remove(category); // Remove os dias selecionados
                      });
                    },
                  );
                },
              );
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: isSelected ? BorderSide(color: Colors.blue, width: 3) : BorderSide.none,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(category.iconPath, height: 50),
                  ),
                  SizedBox(height: 10),
                  Text(
                    category.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      category.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a próxima tela ou salvar os hábitos
          print('Hábitos selecionados: ${selectedCategories.map((e) => e.name).join(', ')}');
          print('Dias selecionados: $habitDays');
          _navigateToNextScreen(context);
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    // Implemente a navegação para a próxima tela aqui
    // Passando os hábitos selecionados e os dias da semana como parâmetro, se necessário
  }
}