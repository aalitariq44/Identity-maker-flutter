import 'package:fluent_ui/fluent_ui.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        border: Border.all(color: const Color(0xFFE57373)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(FluentIcons.error, color: Color(0xFFE57373)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFE57373)),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            Button(onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: onDismiss,
            ),
          ],
        ],
      ),
    );
  }
}
