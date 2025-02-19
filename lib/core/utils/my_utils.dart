import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/core/common/widgets/settings_list_container.dart';

class MyUtils {
  // show snackbar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }

  // show confirmation dialog
  static void showConfirmationDialog({
    required BuildContext context,
    String? title,
    required String message,
    required Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // title
                title == null
                    ? const SizedBox.shrink()
                    : Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 4),
                // message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Confirm',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onConfirm();
                          Navigator.pop(context);
                        },
                      ),
                      Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.5),
                        indent: 16,
                        endIndent: 16,
                        height: 0,
                      ),
                      ListTile(
                        title: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // show image picker sheet
  static void showImagePicker({
    required BuildContext context,

    // gallery
    required Function onPickImageFromGallery,

    // camera
    Function? onPickImageFromCamera,

    // remove image
    bool showRemoveButton = false,
    Function? onRemoveImage,
  }) {
    showCustomModalBottomSheet(
      context: context,
      expand: false,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Text(
                'Choose Image Source',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SettingsListContainer(
              tiles: [
                MySettingsTile(
                  title: 'Pick Image from Gallery',
                  leading:
                      const Icon(CupertinoIcons.photo_on_rectangle, size: 20),
                  onTap: () {
                    onPickImageFromGallery();
                    Navigator.pop(context);
                  },
                ),
                Visibility(
                  visible: onPickImageFromCamera != null,
                  child: MySettingsTile(
                    title: 'Take Photo from Camera',
                    leading: const Icon(CupertinoIcons.camera,
                        size: 20, color: Colors.blue),
                    leadingBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                    onTap: () {
                      if (onPickImageFromCamera != null) {
                        onPickImageFromCamera();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
                if (showRemoveButton)
                  MySettingsTile(
                    title: 'Remove Image',
                    leading: const Icon(
                      CupertinoIcons.trash,
                      size: 20,
                      color: Colors.red,
                    ),
                    leadingBackgroundColor: Colors.red.withValues(alpha: 0.1),
                    onTap: () {
                      if (onRemoveImage != null) {
                        onRemoveImage();
                      }
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ],
        );
      },
      containerWidget: (context, animation, child) => Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                top: false,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
