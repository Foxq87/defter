import 'package:flutter/cupertino.dart';
import '../../theme/palette.dart';

class NotAvailable extends StatelessWidget {
  const NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.35,
            color: Palette.noteIconColor,
          ),
        ),
      ),
      child: const Center(
        child: Row(
          children: [
            Icon(
              CupertinoIcons.alarm,
              size: 40,
              color: Palette.orangeColor,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'bu özellik şu anda aktif değil, sonraki sürümleri bekleyin',
                style: TextStyle(
                    fontSize: 18, fontFamily: 'JetBrainsMonoExtraBold'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
