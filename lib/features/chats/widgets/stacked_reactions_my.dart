import 'package:acc/theme/palette.dart';
import 'package:flutter/material.dart';

class StackedReactions extends StatelessWidget {
  const StackedReactions({
    super.key,
    required this.reactions,
    this.isMyMessage = false,
    this.size = 17.0,
    this.stackedValue = 4.0,
  });

  // List of reactions
  final List<Map<String, dynamic>> reactions;

  final bool isMyMessage;
  // Size of the reaction icon/text
  final double size;

  // Value used to calculate the horizontal offset of each reaction
  final double stackedValue;

  // Text direction (LTR or RTL)
  // final TextDirection direction;

  @override
  Widget build(BuildContext context) {
    // Limit the number of displayed reactions to 5 for performance
    final reactionsToShow =
        reactions.length > 5 ? reactions.sublist(0, 5) : reactions;

    // Calculate the remaining number of reactions (if any)
    final remaining = reactions.length - reactionsToShow.length;

    // Helper function to create a reaction widget with proper styling
    Widget createReactionWidget(String reaction, int index) {
      final leftOffset = size - stackedValue;

      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 25.0 * index),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0)
            .copyWith(right: 4),
        decoration: BoxDecoration(
          border: Border.all(width: 0.6, color: Palette.backgroundColor),
          color: Palette.darkGreyColor2,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Text(
              reaction.trim(),
              style: TextStyle(fontSize: size),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Build the list of reaction widgets using the helper function
    final reactionWidgets = reactionsToShow.asMap().entries.map((entry) {
      final index = entry.key;
      final reaction = entry.value;
      return createReactionWidget(reaction['reaction'] as String, index);
    }).toList();

    return reactions.isEmpty
        ? const SizedBox.shrink()
        : Row(
            children: [
              Stack(
                // Efficiently display reactions based on direction
                children: !isMyMessage
                    ? reactionWidgets.reversed.toList()
                    : reactionWidgets,
              ),
              // Show remaining count only if there are more than 5 reactions
              if (remaining > 0)
                Container(
                  // margin: const EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                    color: Palette.orangeColor,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    boxShadow: [],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          '+$remaining',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}
