import 'package:flutter/material.dart';

class FieldsList extends StatefulWidget {
  final Function(List<String>) onFieldsChanged;
  const FieldsList({super.key, required this.onFieldsChanged});

  @override
  State<StatefulWidget> createState() => _FieldsListState();
}

class _FieldsListState extends State<FieldsList> {
  late List<String> fieldLabels;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fieldLabels = List.generate(1, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var (i, _) in fieldLabels.indexed) {
      children.add(_Field(onChanged: (value) {
        fieldLabels[i] = value;
        widget.onFieldsChanged(List<String>.from(fieldLabels));
      }));
      if (i < fieldLabels.length - 1) {
        children.add(const SizedBox(height: 8.0));
      }
    }
    children.add(const SizedBox(height: 16.0));
    children.add(
      Align(
        alignment: Alignment.centerRight,
        child: OutlinedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)))),
            onPressed: () {
              setState(() {
                fieldLabels.add('');
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add,
                    size: 24, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.apply(fontSizeDelta: 4),
                    'Add new field'),
              ],
            )),
      ),
    );
    return Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: children));
  }
}

class _Field extends StatelessWidget {
  final void Function(String)? onChanged;
  const _Field({this.onChanged});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: "Field Name",
        border: OutlineInputBorder(),
      ),
    );
  }
}
