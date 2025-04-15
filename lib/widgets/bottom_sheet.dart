import 'package:flutter/material.dart';

import 'buttons.dart';

class CustomBottomSheet extends StatefulWidget {
  final List<String> bankList;
  final Function(String) onSelected;
  final String title;

  const CustomBottomSheet({
    super.key,
    required this.bankList,
    required this.onSelected,
    required this.title,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  String? selectedBank;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SizedBox(
        height: screenHeight * 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.bankList.length,
                  itemBuilder: (context, index) {
                    final bank = widget.bankList[index];
                    final isSelected = bank == selectedBank;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: ListTile(
                        title: Text(
                          bank,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedBank = bank;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Buttons(
                iconData: Icons.check,
                text: 'Confirm',
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                borderColor: Theme.of(context).primaryColor,
                isFilled: true,
                onTap: selectedBank == null
                    ? null
                    : () {
                        widget.onSelected(selectedBank!);
                        Navigator.pop(context);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
