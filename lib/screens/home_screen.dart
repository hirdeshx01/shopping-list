import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_list/data/category_rep.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/add_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> _groceryList = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      final url = Uri.https(
        'shopping-list-hirdeshx01-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json',
      );
      final response = await http.get(url);

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data, please try again later.';
          _isLoading = false;
        });
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedList = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            )
            .value;
        loadedList.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryList = loadedList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }

  void _goToAddItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );

    if (newItem == null) {
      return;
    } else {
      setState(() {
        _groceryList.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Groceries'),
        actions: [
          IconButton(
            onPressed: _goToAddItem,
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : _groceryList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _groceryList.length,
                      itemBuilder: ((context, index) => Dismissible(
                            onDismissed: (direction) async {
                              final item = _groceryList[index];

                              final url = Uri.https(
                                'shopping-list-hirdeshx01-default-rtdb.asia-southeast1.firebasedatabase.app',
                                'shopping-list/${_groceryList[index].id}.json',
                              );

                              setState(() {
                                _groceryList.remove(_groceryList[index]);
                              });

                              final response = await http.delete(url);

                              if (response.statusCode >= 400) {
                                setState(() {
                                  _groceryList.insert(index, item);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Unable to delete item.',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                      ),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                );
                              }
                            },
                            key: ValueKey(_groceryList[index].id),
                            background: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.centerRight,
                              color: Theme.of(context).colorScheme.error,
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: _groceryList[index].category.color,
                                ),
                                height: 20,
                                width: 20,
                              ),
                              title: Text(_groceryList[index].name),
                              trailing:
                                  Text(_groceryList[index].quantity.toString()),
                            ),
                          )),
                    )
                  : Center(
                      child: Text(
                        'There are no items in your list!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
    );
  }
}
