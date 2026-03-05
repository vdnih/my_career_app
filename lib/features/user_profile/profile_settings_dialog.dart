import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_profile.dart';

class ProfileSettingsDialog extends ConsumerStatefulWidget {
  const ProfileSettingsDialog({super.key});

  @override
  ConsumerState<ProfileSettingsDialog> createState() =>
      _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends ConsumerState<ProfileSettingsDialog> {
  late TextEditingController _nameController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileNotifierProvider);
    _nameController = TextEditingController(text: profile.name);
    _selectedDate = profile.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('プロフィール設定'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'お名前',
                hintText: '例: 田中 太郎',
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('生年月日'),
              subtitle: Text(
                _selectedDate == null
                    ? '未設定'
                    : '${_selectedDate!.year}年${_selectedDate!.month}月${_selectedDate!.day}日',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () {
            final notifier = ref.read(userProfileNotifierProvider.notifier);
            notifier.updateName(_nameController.text);
            if (_selectedDate != null) {
              notifier.updateBirthDate(_selectedDate!);
            }
            Navigator.pop(context);
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
