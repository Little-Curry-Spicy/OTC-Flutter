import 'package:flutter/material.dart';

class SelectCurrency extends StatefulWidget {
  final String? selectedCurrency;
  final Function(String) onSelected;
  final BuildContext context;
  const SelectCurrency({
    super.key,
    required this.selectedCurrency,
    required this.onSelected,
    required this.context,
  });

  @override
  State<SelectCurrency> createState() => _SelectCurrencyState();
}

class _SelectCurrencyState extends State<SelectCurrency> {
  List<String> currencies = ['CNY', 'HKD', 'USD', 'THB', 'VND'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    final context = widget.context;
    return AlertDialog(
      title: Text('法币列表'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              currencies.map((String currency) {
                final isSelected = currency == widget.selectedCurrency;
                return InkWell(
                  onTap: () {
                    setState(() {
                      widget.onSelected(currency);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currency,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.black87,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
