import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  EventCategory _selectedCategory = EventCategory.sport;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final String _selectedLocation = 'Cairo , Egypt';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initialDate = _selectedDate.isBefore(today) ? today : _selectedDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _handleCreateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    final eventDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final event = EventModel(
      id: 'event_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      dateTime: eventDateTime,
      location: _selectedLocation,
      imagePath: _selectedCategory.bannerPath,
    );

    final success = await context.read<AppEventsProvider>().createEvent(event);
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
        title: Text(l10n.createEvent, style: AppStyle.bold20),
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
                  onCategoryChanged: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.title,
                  style: AppStyle.medium16.copyWith(
                    color: isDark ? AppColor.white : AppColor.textBaseDark,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Event Title',
                  controller: _titleController,
                  prefixIcon: SvgPicture.asset(
                    AppImages.icEditNote,
                    width: 22,
                    height: 22,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      isDark ? AppColor.white : AppColor.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.description,
                  style: AppStyle.medium16.copyWith(
                    color: isDark ? AppColor.white : AppColor.textBaseDark,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Event Description',
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter event description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.icCalendar,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        isDark ? AppColor.white : AppColor.textBaseDark,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.eventDate,
                      style: AppStyle.medium16.copyWith(
                        color: isDark ? AppColor.white : AppColor.textBaseDark,
                      ),
                    ),
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
                    SvgPicture.asset(
                      AppImages.icClock,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        isDark ? AppColor.white : AppColor.textBaseDark,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.eventTime,
                      style: AppStyle.medium16.copyWith(
                        color: isDark ? AppColor.white : AppColor.textBaseDark,
                      ),
                    ),
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
                const SizedBox(height: 8),
                Text(
                  l10n.location,
                  style: AppStyle.medium16.copyWith(
                    color: isDark ? AppColor.white : AppColor.textBaseDark,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Location chooser trigger
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.cardDark : AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.primary, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            AppImages.icCompass,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                                AppColor.white, BlendMode.srcIn),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedLocation,
                            style: AppStyle.bold16
                                .copyWith(color: AppColor.primary),
                          ),
                        ),
                        SvgPicture.asset(
                          AppImages.icArrowRight,
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                              AppColor.primary, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  title: l10n.addEvent,
                  onPressed: _handleCreateEvent,
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
