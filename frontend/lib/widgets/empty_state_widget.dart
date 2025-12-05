import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/design_system/app_colors.dart';
import '../core/design_system/app_animations.dart';
import '../core/theme/app_theme_constants.dart';

/// Reusable empty state widget
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? actionRoute;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.actionRoute,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final iconColor = AppColors.getTextTertiary(brightness);

    return AppAnimations.fadeIn(
      duration: AppAnimations.medium,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppThemeConstants.spacing32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: iconColor,
              ),
              SizedBox(height: AppThemeConstants.spacing16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.getTextSecondary(brightness),
                    ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                SizedBox(height: AppThemeConstants.spacing8),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null) ...[
                SizedBox(height: AppThemeConstants.spacing24),
                ElevatedButton.icon(
                  onPressed: () {
                    if (onAction != null) {
                      onAction!();
                    } else if (actionRoute != null) {
                      context.push(actionRoute!);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable error state widget
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final errorColor = brightness == Brightness.light
        ? AppColors.errorLight
        : AppColors.errorDark;

    return AppAnimations.fadeIn(
      duration: AppAnimations.medium,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppThemeConstants.spacing32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon ?? Icons.error_outline,
                size: 64,
                color: errorColor.withOpacity(0.7),
              ),
              SizedBox(height: AppThemeConstants.spacing16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppThemeConstants.spacing8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                SizedBox(height: AppThemeConstants.spacing24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


