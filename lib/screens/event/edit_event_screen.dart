import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/event_model.dart';
import '../../providers/app_events_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';
import 'widgets/category_chip_selector.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel? event;

  const EditEventScreen({super.key, this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late EventCategory _selectedCategory;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedLocation;
  late EventModel _targetEvent;

  @override
  void initState() {
    super.initState();
    _targetEvent = widget.event ??
        EventModel(
          id: '',
          title: '',
          description: '',
          category: EventCategory.sport,
          dateTime: DateTime.now(),
          location: 'Cairo , Egypt',
          imagePath: AppImages.sportBanner,
        );

    _titleController = TextEditingController(text: _targetEvent.title);
    _descriptionController =
        TextEditingController(text: _targetEvent.description);
    _selectedCategory = _targetEvent.category;
    _selectedDate = _targetEvent.dateTime;
    _selectedTime = TimeOfDay.fromDateTime(_targetEvent.dateTime);
    _selectedLocation = _targetEvent.location;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.event == null) {
      final routeArg = ModalRoute.of(context)?.settings.arguments;
      if (routeArg is EventModel) {
        _targetEvent = routeArg;
        _titleController.text = _targetEvent.title;
        _descriptionController.text = _targetEvent.description;
        _selectedCategory = _targetEvent.category;
        _selectedDate = _targetEvent.dateTime;
        _selectedTime = TimeOfDay.fromDateTime(_targetEvent.dateTime);
        _selectedLocation = _targetEvent.location;
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = _targetEvent.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      location: _selectedLocation,
      imagePath: _selectedCategory.bannerPath,
    );

    final success =
        await context.read<AppEventsProvider>().updateEvent(updated);
    if (mounted && success) {
      Navigator.maybePop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.editEvent, style: AppStyle.bold20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    _selectedCategory.bannerPath,
                    height: 203,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                CategoryChipSelector(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (cat) =>
                      setState(() => _selectedCategory = cat),
                ),
                const SizedBox(height: 16),
                Text(l10n.title, style: AppStyle.medium16),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: l10n.title,
                  controller: _titleController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter title'
                      : null,
                ),
                const SizedBox(height: 16),
                Text(l10n.description, style: AppStyle.medium16),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: l10n.description,
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter description'
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(l10n.eventDate, style: AppStyle.medium16),
                    const Spacer(),
                    TextButton(
                      onPressed: _pickDate,
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                        style:
                            AppStyle.bold16.copyWith(color: AppColor.primary),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(l10n.eventTime, style: AppStyle.medium16),
                    const Spacer(),
                    TextButton(
                      onPressed: _pickTime,
                      child: Text(
                        _selectedTime.format(context),
                        style:
                            AppStyle.bold16.copyWith(color: AppColor.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  title: l10n.updateEvent,
                  onPressed: _handleUpdate,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
