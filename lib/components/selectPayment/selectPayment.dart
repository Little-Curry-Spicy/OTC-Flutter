import 'package:flutter/material.dart';

class SelectPayment extends StatefulWidget {
  final int? selectedPayment;
  final Function(Map<String, dynamic>) onSelected;
  final BuildContext context;
  const SelectPayment({
    super.key,
    required this.selectedPayment,
    required this.onSelected,
    required this.context,
  });

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  List<Map<String, dynamic>> payments = [
    {'value': 0, 'name': '支付宝'},
    {'value': 1, 'name': '微信'},
    {'value': 2, 'name': '银行卡'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    final context = widget.context;
    return AlertDialog(
      title: Text('支付方式'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              payments.map((Map<String, dynamic> payment) {
                final isSelected = payment['value'] == widget.selectedPayment;
                return InkWell(
                  onTap: () {
                    setState(() {
                      widget.onSelected(payment);
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
                          payment['name'],
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
