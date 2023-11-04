import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String title;
  final Widget child;
  final bool? initiallyOpen;
  final double? openedHeight;

  const Accordion(
      {super.key,
      required this.title,
      required this.child,
      this.initiallyOpen,
      this.openedHeight});

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool open = true;

  void toggleOpen() {
    setState(() {
      open = !open;
    });
  }

  @override
  void initState() {
    super.initState();

    open = widget.initiallyOpen ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          child: ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(open
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded),
            onTap: toggleOpen,
          ),
        ),
        AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: open
                ? widget.openedHeight ??
                    MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.bottom -
                        MediaQuery.of(context).padding.top -
                        450
                : 0,
            curve: Curves.fastOutSlowIn,
            child: open ? widget.child : null),
      ],
    );
  }
}
