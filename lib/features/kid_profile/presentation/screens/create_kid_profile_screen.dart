import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../providers/kid_profile_providers.dart';

/// Create kid profile screen with photo upload
class CreateKidProfileScreen extends ConsumerStatefulWidget {
  const CreateKidProfileScreen({super.key});

  @override
  ConsumerState<CreateKidProfileScreen> createState() =>
      _CreateKidProfileScreenState();
}

class _CreateKidProfileScreenState
    extends ConsumerState<CreateKidProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _imagePicker = ImagePicker();

  File? _selectedPhoto;
  String? _ageBucket;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedPhoto = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _onAgeChanged(String value) {
    final age = int.tryParse(value);
    if (age != null && age >= AppConstants.minAge && age <= AppConstants.maxAge) {
      setState(() {
        _ageBucket = AppConstants.getAgeBucket(age);
      });
    } else {
      setState(() {
        _ageBucket = null;
      });
    }
  }

  Future<void> _handleCreateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(kidProfileControllerProvider.notifier)
        .createKidProfile(
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          photo: _selectedPhoto,
        );

    if (!mounted) return;

    if (success) {
      // Navigate to home screen after creating profile
      context.go(AppRoutes.home);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(kidProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Kid Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo picker
              Center(
                child: GestureDetector(
                  onTap: controllerState.isLoading ? null : _pickPhoto,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _ageBucket != null
                          ? AppColors.getAgeBucketColor(_ageBucket!)
                                  .withOpacity(0.2)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: _ageBucket != null
                            ? AppColors.getAgeBucketColor(_ageBucket!)
                            : AppColors.textLight,
                        width: 2,
                      ),
                    ),
                    child: _selectedPhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(58),
                            child: Image.file(
                              _selectedPhoto!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: _ageBucket != null
                                    ? AppColors.getAgeBucketColor(_ageBucket!)
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: _ageBucket != null
                                      ? AppColors.getAgeBucketColor(_ageBucket!)
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Optional - Add a photo of your child',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter child\'s name',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: ValidationUtils.validateName,
                enabled: !controllerState.isLoading,
              ),
              const SizedBox(height: 16),

              // Age field
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter age (${AppConstants.minAge}-${AppConstants.maxAge})',
                  prefixIcon: const Icon(Icons.cake_outlined),
                  suffixIcon: _ageBucket != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.getAgeBucketColor(_ageBucket!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _ageBucket!.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: _onAgeChanged,
                validator: ValidationUtils.validateAge,
                enabled: !controllerState.isLoading,
              ),
              const SizedBox(height: 24),

              // Age bucket info
              if (_ageBucket != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        AppColors.getAgeBucketColor(_ageBucket!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.getAgeBucketColor(_ageBucket!),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.getAgeBucketColor(_ageBucket!),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getAgeBucketTitle(_ageBucket!),
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.getAgeBucketColor(_ageBucket!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getAgeBucketDescription(_ageBucket!),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),

              // Error message
              if (controllerState.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controllerState.error!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Create button
              ElevatedButton(
                onPressed: controllerState.isLoading
                    ? null
                    : _handleCreateProfile,
                child: controllerState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAgeBucketTitle(String ageBucket) {
    switch (ageBucket.toLowerCase()) {
      case 'sprout':
        return 'Sprout (Ages 3-5)';
      case 'explorer':
        return 'Explorer (Ages 6-8)';
      case 'visionary':
        return 'Visionary (Ages 9-12)';
      default:
        return ageBucket;
    }
  }

  String _getAgeBucketDescription(String ageBucket) {
    switch (ageBucket.toLowerCase()) {
      case 'sprout':
        return 'Short, simple stories perfect for early learners. Large text and colorful illustrations.';
      case 'explorer':
        return 'Engaging stories with simple plots and moral lessons. Great for early readers.';
      case 'visionary':
        return 'Complex adventures with chapter-style plots. Perfect for independent readers.';
      default:
        return '';
    }
  }
}
