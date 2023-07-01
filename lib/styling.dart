import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'dummy_data.dart';

class StylingTable extends StatefulWidget {
  const StylingTable({super.key});

  @override
  State<StylingTable> createState() => _StylingTableState();
}

class _StylingTableState extends State<StylingTable> {
  final bool _showFirstLastButtons = true;
  final bool _showCheckboxColumn = true;
  final bool _showRowsPerPage = true;
  double dividerThickness = 2;
  Color rowColor = Colors.blueGrey.shade100.withOpacity(0.5);
  Color rowHoverColor = Colors.blueGrey.shade100.withOpacity(0.5);
  Color headerColor = Colors.blueGrey.shade100.withOpacity(0.5);
  Color selectedRowColor = Colors.blueGrey.shade100.withOpacity(0.5);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    Color? color = await showDialog<Color>(
                      context: context,
                      builder: (context) {
                        return ColorPickerDailog(
                          selectedColor: rowColor,
                        );
                      },
                    );
                    if (color != null) {
                      setState(() {
                        rowColor = color;
                      });
                    }
                  },
                  child: CircleAvatar(backgroundColor: rowColor),
                ),
                const Text("Row Color"),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    Color? color = await showDialog<Color>(
                      context: context,
                      builder: (context) {
                        return ColorPickerDailog(
                          selectedColor: rowHoverColor,
                        );
                      },
                    );
                    if (color != null) {
                      setState(() {
                        rowHoverColor = color;
                      });
                    }
                  },
                  child: CircleAvatar(backgroundColor: rowHoverColor),
                ),
                const Text("Row Hover Color"),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    Color? color = await showDialog<Color>(
                      context: context,
                      builder: (context) {
                        return ColorPickerDailog(
                          selectedColor: selectedRowColor,
                        );
                      },
                    );
                    if (color != null) {
                      setState(() {
                        selectedRowColor = color;
                      });
                    }
                  },
                  child: CircleAvatar(backgroundColor: selectedRowColor),
                ),
                const Text("Selected Row Color"),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    Color? color = await showDialog<Color>(
                      context: context,
                      builder: (context) {
                        return ColorPickerDailog(
                          selectedColor: headerColor,
                        );
                      },
                    );
                    if (color != null) {
                      setState(() {
                        headerColor = color;
                      });
                    }
                  },
                  child: CircleAvatar(backgroundColor: headerColor),
                ),
                const Text("Header Color"),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                    value: dividerThickness,
                    max: 10,
                    min: 2,
                    label: dividerThickness.toString(),
                    onChanged: (value) {
                      setState(() {
                        dividerThickness = value;
                      });
                    }),
                const Text("Divider Thickness"),
              ],
            )
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Theme(
            data: ThemeData(
              cardColor: Colors.yellow.shade200,
              secondaryHeaderColor: Colors
                  .orange.shade100, //header color when selectedRow count >0
            ),
            child: DataTableTheme(
              data: DataTableThemeData(
                dividerThickness: dividerThickness,
                headingRowColor: MaterialStatePropertyAll(headerColor),
              ),
              child: DynamicTable(
                header: const Text("Person Table"),
                rowsPerPage: 5,
                showFirstLastButtons: _showFirstLastButtons,
                availableRowsPerPage: const [
                  5,
                  10,
                  15,
                  20,
                ],
                dataRowMinHeight: 60,
                dataRowMaxHeight: 60,
                columnSpacing: 60,
                showCheckboxColumn: _showCheckboxColumn,
                onRowsPerPageChanged: _showRowsPerPage
                    ? (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Rows Per Page Changed to $value"),
                          ),
                        );
                      }
                    : null,
                rows: List.generate(
                  dummyData.length,
                  (index) => DynamicTableDataRow(
                    index: index,
                    // if wanted diffrent color for diffrent index row add color here else add from DataTableThemeData
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return selectedRowColor.withOpacity(0.2);
                      } else if (states.contains(MaterialState.hovered)) {
                        return rowHoverColor; // Use this value where hovered.
                      }
                      return rowColor
                          .withOpacity(0.2); // Use the default value.
                    }),
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
                      label: const Text("Name"),
                      onSort: (columnIndex, ascending) {},
                      dynamicTableInputType: DynamicTableTextInput()),
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
                    dynamicTableInputType:
                        DynamicTableInputType.dropDown<String>(
                      items: genderDropdown,
                      selectedItemBuilder: (context) {
                        return genderDropdown
                            .map((e) => Text(e))
                            .toList(growable: false);
                      },
                      decoration: const InputDecoration(
                          hintText: "Select Gender",
                          border: OutlineInputBorder()),
                      displayBuilder: (value) =>
                          value ??
                          "", // How the string will be displayed in non editing mode
                      itemBuilder: (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      },
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
            ),
          ),
        ),
      ],
    );
  }
}

class ColorPickerDailog extends StatefulWidget {
  const ColorPickerDailog({super.key, required this.selectedColor});
  final Color selectedColor;
  @override
  State<ColorPickerDailog> createState() => _ColorPickerDailogState();
}

class _ColorPickerDailogState extends State<ColorPickerDailog> {
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    selectedColor = widget.selectedColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pick a color"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
          child: const Text("OK"),
        ),
      ],
      content: MaterialPicker(
        pickerColor: Colors.blue,
        onColorChanged: (value) {
          setState(() {
            selectedColor = value;
          });
        },
      ),
    );
  }
}
