import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/multi_select_dialog_item.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  MultiSelectDialog({this.items, this.initialSelectedValues});

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: getProportionateScreenWidth(250),
        child: SingleChildScrollView(
          child: ListBody(children: widget.items.map(buildItem).toList()),
        ),
      ),
      actions: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(child: Text('OK'), onPressed: onSubmitTap)
      ],
    );
  }

  Widget buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return buildCheckbox(checked, item);
  }

  CheckboxListTile buildCheckbox(bool checked, MultiSelectDialogItem<dynamic> item) {
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      onChanged: (checked) => onItemCheckedChange(item.value, checked),
    );
  }

  void onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void onSubmitTap() => Navigator.pop(context, _selectedValues);
}
