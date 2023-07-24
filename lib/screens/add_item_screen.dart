import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_list/data/category_rep.dart';
import 'package:shopping_list/models/category_rep.dart';
import 'package:shopping_list/models/grocery_item.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _onAddItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final url = Uri.https(
        'shopping-list-hirdeshx01-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json',
      );
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.title
          },
        ),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        GroceryItem(
            id: responseData['name'],
            name: _enteredName,
            quantity: _enteredQuantity,
            category: _selectedCategory),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text('Add Item'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length <= 1) {
                        return 'Must be between 1 and 50 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredName = newValue!;
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null) {
                            return 'Must be a valid positive number';
                          }
                          return null;
                        },
                        initialValue: _enteredQuantity.toString(),
                        onSaved: (newValue) {
                          _enteredQuantity = int.parse(newValue!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: category.value.color,
                                    ),
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(category.value.title)
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Reset'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    FilledButton(
                      onPressed: _isSending ? null : _onAddItem,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator())
                          : const Text('Add Item'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
