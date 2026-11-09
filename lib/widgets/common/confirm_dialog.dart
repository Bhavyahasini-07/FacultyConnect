import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'secondary_button.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;
  final bool requireReasonInput;
  final String reasonHint;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
    this.icon,
    this.requireReasonInput = false,
    this.reasonHint = 'Enter reason...',
  });

  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
    bool requireReasonInput = false,
    String reasonHint = 'Enter reason...',
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        icon: icon,
        requireReasonInput: requireReasonInput,
        reasonHint: reasonHint,
      ),
    );
  }

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 6,
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (widget.confirmColor ?? AppColors.primaryRoyalBlue).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon ?? Icons.help_outline_rounded,
                    color: widget.confirmColor ?? AppColors.primaryRoyalBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              widget.message,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            if (widget.requireReasonInput) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                maxLines: 2,
                style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
                decoration: InputDecoration(
                  hintText: widget.reasonHint,
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.mutedText),
                ),
              ),
            ],
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: widget.cancelText,
                    height: 46,
                    onPressed: () => Navigator.of(context).pop({'confirmed': false}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.confirmColor ?? AppColors.primaryRoyalBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop({
                          'confirmed': true,
                          'reason': _reasonController.text.trim(),
                        });
                      },
                      child: Text(
                        widget.confirmText,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
