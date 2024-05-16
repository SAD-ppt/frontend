import 'package:flutter/material.dart';

class FieldsList extends StatefulWidget {
  final Function(List<String>) onFieldsChanged;
  const FieldsList({super.key, required this.onFieldsChanged});

  @override
  State<StatefulWidget> createState() => _FieldsListState();
}

class _FieldsListState extends State<FieldsList> {
  late List<(String, bool)> fieldLabels;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fieldLabels = List.generate(1, (index) => ('', true));
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var (i, field) in fieldLabels.indexed) {
      if (!field.$2) {
        continue;
      }
      children.add(Dismissible(
        background: Container(
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          alignment: Alignment.centerRight,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            fieldLabels[i] = (field.$1, false);
            widget.onFieldsChanged(fieldLabels
                .where((element) => element.$2)
                .map((e) => e.$1)
                .toList());
          });
        },
        key: ValueKey(i),
        child: _Field(onChanged: (value) {
          fieldLabels[i] = (value, true);
          final newFieldLabels = fieldLabels
              .where((element) => element.$2)
              .map((e) => e.$1)
              .toList();
          widget.onFieldsChanged(List<String>.from(newFieldLabels));
        }),
      ));
      if (i < fieldLabels.length - 1) {
        children.add(const SizedBox(height: 8.0));
      }
    }
    children.add(const SizedBox(height: 16.0));
    children.add(
      ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: double.infinity),
        child: _AddNewFieldButton(
            onPressed: () => setState(() {
                  fieldLabels.add(('', true));
                })),
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

class _AddNewFieldButton extends StatelessWidget {
  final void Function() onPressed;
  const _AddNewFieldButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      onPressed: onPressed,
      child: Icon(Icons.add, size: 24, color: Theme.of(context).primaryColor),
    );
  }
}
