import 'package:flutter/material.dart';

List<String> allCategories = [
  "",
  "Beauty",
  "Food and drink",
  "Health",
  "Hotels and travels",
  "Spa and Wellness",
  "Study and Work"
];

Widget getIcon(String category, String? filteredCategory) {
  double selected = 40;
  double notSelected = 30;
  switch(category) {
    case "Beauty":
      return Icon(Icons.cut,
      color: (category == filteredCategory) ? Colors.red : Colors.black,
      size: (category == filteredCategory) ? selected : notSelected,
      );
    case "Food and drink":
      return Icon(Icons.food_bank,
        color: (category == filteredCategory) ? Colors.red : Colors.black,
        size: (category == filteredCategory) ? selected : notSelected,
      );
    case "Health":
      return Icon(Icons.health_and_safety,
        color: (category == filteredCategory) ? Colors.red : Colors.black,
        size: (category == filteredCategory) ? selected : notSelected,
      );
    case "Hotels and travels":
      return Icon(Icons.airplanemode_on,
        color: (category == filteredCategory) ? Colors.red : Colors.black,
        size: (category == filteredCategory) ? selected : notSelected,
      );
    case "Spa and Wellness":
      return Icon(Icons.spa,
        color: (category == filteredCategory) ? Colors.red : Colors.black,
        size: (category == filteredCategory) ? selected : notSelected,
      );
    case "Study and Work":
      return Icon(Icons.laptop,
        color: (category == filteredCategory) ? Colors.red : Colors.black,
        size: (category == filteredCategory) ? selected : notSelected,
      );
      default:
        return const SizedBox();
  }
}