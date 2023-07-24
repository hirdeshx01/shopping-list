import 'package:flutter/material.dart';

import 'package:shopping_list/models/category_rep.dart';

const categories = {
  Categories.vegetables: Category(
    'Vegetables',
    Color.fromARGB(255, 109, 189, 132),
  ),
  Categories.fruit: Category(
    'Fruit',
    Color.fromARGB(255, 188, 151, 73),
  ),
  Categories.meat: Category(
    'Meat',
    Color.fromARGB(255, 186, 89, 70),
  ),
  Categories.dairy: Category(
    'Dairy',
    Color.fromARGB(255, 184, 193, 196),
  ),
  Categories.carbs: Category(
    'Carbs',
    Color.fromARGB(255, 134, 95, 135),
  ),
  Categories.sweets: Category(
    'Sweets',
    Color.fromARGB(255, 190, 139, 66),
  ),
  Categories.spices: Category(
    'Spices',
    Color.fromARGB(255, 188, 93, 58),
  ),
  Categories.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 137, 115, 188),
  ),
  Categories.hygiene: Category(
    'Hygiene',
    Color.fromARGB(255, 159, 107, 162),
  ),
  Categories.other: Category(
    'Other',
    Color.fromARGB(255, 94, 127, 133),
  ),
};
