import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';

import 'dummy_data.dart';

class AutocompleteEample extends StatefulWidget {
  const AutocompleteEample({super.key});

  @override
  State<AutocompleteEample> createState() => _AutocompleteEampleState();
}

class _AutocompleteEampleState extends State<AutocompleteEample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DynamicTable(
        header: const Text("Person Table with AutoComplete Input"),
        rowsPerPage: 5,
        showActions: true,
        showFirstLastButtons: true,
        availableRowsPerPage: const [
          5,
          10,
          15,
          20,
        ],
        dataRowMinHeight: 60,
        dataRowMaxHeight: 60,
        columnSpacing: 60,
        showCheckboxColumn: true,
        onRowsPerPageChanged: (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Rows Per Page Changed to $value"),
            ),
          );
        },
        rows: List.generate(
          dummyData.length,
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
              dummyData[index].length,
              (cellIndex) => DynamicTableDataCell(
                value: dummyData[index][cellIndex],
              ),
            ),
          ),
        ),
        columns: [
          DynamicTableDataColumn(
            label: const Text("Name (AutoComplete)"),
            onSort: (columnIndex, ascending) {},
            dynamicTableInputType: DynamicTableInputType.autocompleteInput(
              optionsBuilder: (value) {
                return dummyData
                    .map((e) => e[0] as String)
                    .where(
                      (element) => element
                          .toLowerCase()
                          .contains(value.text.toLowerCase()),
                    )
                    .toList();
              },

              //The sring display in non editing mode
              displayBuilder: (value) => value ?? "",

              // Autocomplete items take full screen width to limit the width use below property
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: SizedBox(
                      width: 300,
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(options.elementAt(index)),
                            onTap: () {
                              onSelected(options.elementAt(index));
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // dynamicTableInputType: DynamicTableInputType.text()),
          DynamicTableDataColumn(
              label: const Text("Unique ID"),
              onSort: (columnIndex, ascending) {},
              isEditable: false,
              dynamicTableInputType: DynamicTableTextInput()),
          // dynamicTableInputType: DynamicTableInputType.text()),
          DynamicTableDataColumn(
            label: const Text("Birth Date"),
            onSort: (columnIndex, ascending) {},
            // dynamicTableInputType: DynamicTableDateInput()
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
            // dynamicTableInputType: DynamicTableDropDownInput<String>()
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
              onSort: (columnIndex, ascending) {},
              dynamicTableInputType: DynamicTableInputType.text(
                decoration: const InputDecoration(
                  hintText: "Enter Other Info",
                  border: OutlineInputBorder(),
                ),
                maxLines: 100,
              )),
        ],
      ),
    );
  }
}
