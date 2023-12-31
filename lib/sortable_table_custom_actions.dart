import 'dart:math';

import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';

import 'dummy_data.dart';

class SortableTable extends StatefulWidget {
  const SortableTable({super.key});

  @override
  State<SortableTable> createState() => _SortableTableState();
}

class _SortableTableState extends State<SortableTable> {
  int? _currentSortedColumnIndex = 0;
  bool _currentSortedColumnAscending = true;
  List<List<dynamic>> data = [...dummyData];
  var tableKey = GlobalKey<DynamicTableState>();
  @override
  Widget build(BuildContext context) {
    data.sort((a, b) => a[_currentSortedColumnIndex ?? 0]
        .compareTo(b[_currentSortedColumnIndex ?? 0]));
    if (!_currentSortedColumnAscending) {
      data = data.reversed.toList();
    }
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: DynamicTable(
            key: tableKey,
            header: const Text("Person Table with sorting and custom actions"),
            actions: [
              IconButton(
                onPressed: () {
                  tableKey.currentState?.deleteAllRows();
                },
                tooltip: "Delete All Rows",
                icon: const Icon(Icons.delete),
              ),
            ],
            onRowEdit: (index, row) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Row Edited index:$index row:$row"),
                ),
              );
              data[index] = row;
              return true;
            },
            onRowDelete: (index, row) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Row Deleted index:$index row:$row"),
                ),
              );
              data.removeAt(index);
              return true;
            },
            onRowSave: (index, old, newValue) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content:
              //         Text("Row Saved index:$index old:$old new:$newValue"),
              //   ),
              // );
              if (newValue[0] == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Name cannot be null"),
                  ),
                );
                return null;
              }

              if (newValue[0].toString().length < 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Name must be atleast 3 characters long"),
                  ),
                );
                return null;
              }
              if (newValue[0].toString().length > 20) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Name must be less than 20 characters long"),
                  ),
                );
                return null;
              }
              if (newValue[1] == null) {
                //If newly added row then add unique ID
                newValue[1] = Random()
                    .nextInt(500)
                    .toString(); // to add Unique ID because it is not editable
              }
              data[index] = newValue; // Update data
              if (newValue[0] == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Name cannot be null"),
                  ),
                );
                return null;
              }
              return newValue;
            },
            rowsPerPage: 5,
            availableRowsPerPage: const [
              5,
              10,
              15,
              20,
            ],
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columnSpacing: 60,
            actionColumnTitle: "My Action Title",
            showCheckboxColumn: true,
            onRowsPerPageChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Rows Per Page Changed to $value"),
                ),
              );
            },
            sortAscending: _currentSortedColumnAscending,
            sortColumnIndex: _currentSortedColumnIndex,
            rows: List.generate(
              data.length,
              (index) => DynamicTableDataRow(
                index: index,
                onSelectChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: value ?? false
                          ? Text("Row Selected index:$index")
                          : Text("Row Unselected index:$index"),
                    ),
                  );
                },
                cells: List.generate(
                  data[index].length,
                  (cellIndex) => DynamicTableDataCell(
                    value: data[index][cellIndex],
                  ),
                ),
              ),
            ),
            columns: [
              DynamicTableDataColumn(
                  label: const Text("Name"),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _currentSortedColumnIndex = columnIndex;
                      _currentSortedColumnAscending = ascending;
                    });
                  },
                  dynamicTableInputType: DynamicTableInputType.text()),
              DynamicTableDataColumn(
                  label: const Text("Unique ID"),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _currentSortedColumnIndex = columnIndex;
                      _currentSortedColumnAscending = ascending;
                    });
                  },
                  isEditable: false,
                  dynamicTableInputType: DynamicTableInputType.text()),
              DynamicTableDataColumn(
                label: const Text("Birth Date"),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _currentSortedColumnIndex = columnIndex;
                    _currentSortedColumnAscending = ascending;
                  });
                },
                dynamicTableInputType: DynamicTableInputType.date(
                  context: context,
                  decoration: const InputDecoration(
                      hintText: "Select Birth Date",
                      suffixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder()),
                  initialDate: DateTime(1900),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365),
                  ),
                ),
              ),
              DynamicTableDataColumn(
                label: const Text("Gender"),
                dynamicTableInputType: DynamicTableInputType.dropDown<String>(
                  items: genderDropdown
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return genderDropdown
                        .map((e) => Text(e))
                        .toList(growable: false);
                  },
                  decoration: const InputDecoration(
                      hintText: "Select Gender", border: OutlineInputBorder()),
                  displayBuilder: (value) =>
                      value ??
                      "", // How the string will be displayed in non editing mode
                ),
              ),
              DynamicTableDataColumn(
                  label: const Text("Other Info"),
                  dynamicTableInputType: DynamicTableInputType.text(
                    decoration: const InputDecoration(
                      hintText: "Enter Other Info",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 100,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
