import 'package:flutter/material.dart';

Future<bool?> showAddedDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // 바깥 터치로 닫기 막기
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '나의 레시피',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에 추가되었습니다.'),
                ],
              ),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '나의 레시피로 이동하시겠습니까?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // 취소
            },
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // 확인
            },
            child: const Text('확인', style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}
