import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionCard extends StatelessWidget {
  final String option;
  final int index;
  final VoidCallback onTap;
  final Color backgroundColor;
  final bool isSelected;

  const OptionCard({
    super.key,
    required this.option,
    required this.index,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.indigo : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.indigo.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.indigo : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
