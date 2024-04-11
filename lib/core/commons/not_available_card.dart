import 'package:flutter/cupertino.dart';
import '../../theme/palette.dart';

class NotAvailable extends StatelessWidget {
  const NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1.0,
          color: Palette.postIconColor,
        ),
      ),
      child: const Center(
        child: Row(
          children: [
            Icon(
              CupertinoIcons.alarm,
              size: 40,
              color: Palette.themeColor,
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
