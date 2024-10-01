import '../models/habit_category.dart';

List<HabitCategory> habitCategories = [
  HabitCategory(
    name: "Work Out",
    iconPath: "assets/icons/workout.png", // Você precisará adicionar ícones no projeto
    description: "Exercícios físicos para manter a saúde.",
  ),
  HabitCategory(
    name: "Read Book",
    iconPath: "assets/icons/read.png",
    description: "Ler livros diariamente.",
  ),
  HabitCategory(
    name: "Music",
    iconPath: "assets/icons/music.png",
    description: "Prática de instrumentos musicais.",
  ),
  // Adicione mais categorias conforme necessário
];