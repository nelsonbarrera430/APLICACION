import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final Function(String) onCategoryTap;

  const CategoryGrid({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'Cuestionario', 'icon': Icons.assignment},
      {'label': 'Resultados', 'icon': Icons.bar_chart},
      {'label': 'Comunidad', 'icon': Icons.group},
      {'label': 'Respiración', 'icon': Icons.air},
      {'label': 'Asistente', 'icon': Icons.smart_toy},
      {'label': 'Ejercicios', 'icon': Icons.fitness_center},
    ];

    return Container(
      color: Colors.black, 
      child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () => onCategoryTap(category['label'] as String),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Cuadro blanco
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4), // Sombra gris suave
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    color: Colors.black87, // Ícono oscuro para contraste
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category['label'] as String,
                    style: const TextStyle(
                      color: Colors.black87, // Texto oscuro
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
