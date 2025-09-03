import 'package:fluent_ui/fluent_ui.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../data/models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StudentCard({
    super.key,
    required this.student,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: Print student data
    print(
      'StudentCard - Student ID: ${student.id}, Name: "${student.name}", Name length: ${student.name.length}, Is empty: ${student.name.isEmpty}',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo and actions row
            Row(
              children: [
                // Student photo
                _buildPhoto(),
                const Spacer(),
                // Actions menu
                _buildActionsMenu(context),
              ],
            ),
            const SizedBox(height: 12),

            // Student name
            Text(
              student.name.isNotEmpty ? student.name : 'اسم الطالب غير محدد',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Black divider line
            Container(
              height: 1,
              color: Colors.black,
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
            const SizedBox(height: 4),

            // Grade
            Row(
              children: [
                const Icon(
                  FluentIcons.education,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'الصف: ${student.grade}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Birth date
            Row(
              children: [
                const Icon(
                  FluentIcons.calendar,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _formatDate(student.birthDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // School info (if available)
            Row(
              children: [
                const Icon(
                  FluentIcons.education,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'المدرسة: ${student.schoolId}', // This would be school name in real implementation
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (student.photoPath != null && student.photoPath!.isNotEmpty) {
      ImageProvider imageProvider;
      if (kIsWeb && student.photoPath!.startsWith('data:image')) {
        final base64Data = student.photoPath!.split(',')[1];
        final bytes = base64Decode(base64Data);
        imageProvider = MemoryImage(bytes);
      } else if (kIsWeb &&
          (student.photoPath!.startsWith('http') ||
              student.photoPath!.startsWith('https'))) {
        imageProvider = NetworkImage(student.photoPath!);
      } else if (!kIsWeb) {
        imageProvider = FileImage(File(student.photoPath!));
      } else {
        // غير مدعوم
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(
            FluentIcons.contact,
            color: Color(0xFF1976D2),
            size: 24,
          ),
        );
      }
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      );
    } else {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Icon(
          FluentIcons.contact,
          color: Color(0xFF1976D2),
          size: 24,
        ),
      );
    }
  }

  Widget _buildActionsMenu(BuildContext context) {
    return DropDownButton(
      leading: const Icon(FluentIcons.more),
      items: [
        MenuFlyoutItem(
          leading: const Icon(FluentIcons.edit),
          text: const Text('تعديل'),
          onPressed: onEdit,
        ),
        MenuFlyoutItem(
          leading: const Icon(FluentIcons.delete),
          text: const Text('حذف'),
          onPressed: onDelete,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
