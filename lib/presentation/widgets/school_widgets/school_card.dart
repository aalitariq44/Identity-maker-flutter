import 'package:fluent_ui/fluent_ui.dart';
import 'dart:io';
import '../../../data/models/school.dart';

class SchoolCard extends StatelessWidget {
  final School school;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SchoolCard({
    super.key,
    required this.school,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and actions row
            Row(
              children: [
                // School logo
                _buildLogo(),
                const Spacer(),
                // Actions menu
                _buildActionsMenu(context),
              ],
            ),
            const SizedBox(height: 12),

            // School names
            Text(
              school.nameArabic,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              school.nameEnglish,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Address
            Row(
              children: [
                const Icon(
                  FluentIcons.location,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    school.address,
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

            // Phone
            Row(
              children: [
                const Icon(
                  FluentIcons.phone,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Text(
                  school.phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Principal
            Row(
              children: [
                const Icon(
                  FluentIcons.contact,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'المدير: ${school.principal}',
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

  Widget _buildLogo() {
    if (school.logoPath != null && school.logoPath!.isNotEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: FileImage(File(school.logoPath!)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          FluentIcons.education,
          color: Color(0xFF1976D2),
          size: 20,
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
}
