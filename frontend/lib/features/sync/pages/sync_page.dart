import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/sync/local_sync_service.dart';
import '../../../core/accessibility/accessibility_helper.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_widget.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LocalSyncService _syncService = LocalSyncService();
  SyncPackage? _generatedPackage;
  bool _isGenerating = false;
  ConflictResolutionMode _conflictMode = ConflictResolutionMode.lastUpdated;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _generateQrCode() async {
    setState(() => _isGenerating = true);
    try {
      final package = await _syncService.generateSyncPackage();
      setState(() {
        _generatedPackage = package;
        _isGenerating = false;
      });
      AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.mediumImpact);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _scanQrCode() async {
    // This will be handled by the scanner widget
  }

  Future<void> _applyScannedData(String qrData) async {
    try {
      final package = await _syncService.parseSyncPackage(qrData);
      final result = await _syncService.applySyncPackage(package, mode: _conflictMode);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.success
                  ? 'Sync completed! ${result.syncedFiles} files synced'
                  : 'Sync failed: ${result.error}',
            ),
            backgroundColor: result.success ? Colors.green : Colors.red,
          ),
        );
      }

      if (result.success) {
        AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.heavyImpact);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error applying sync: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Sync'),
        backgroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Generate QR', icon: Icon(Icons.qr_code)),
            Tab(text: 'Scan QR', icon: Icon(Icons.qr_code_scanner)),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradientFromContext(context),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildGenerateTab(),
            _buildScanTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: AppTheme.getSecondaryBackgroundFromContext(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 64,
                    color: AppTheme.getAccentGoldFromContext(context),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Generate QR Code for Sync',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a QR code to share your data with another device',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getTextSecondaryFromContext(context),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Semantics(
            label: 'Generate QR code button',
            hint: 'Tap to generate a QR code for data synchronization',
            button: true,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateQrCode,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.qr_code),
              label: Text(_isGenerating ? 'Generating...' : 'Generate QR Code'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.getAccentGoldFromContext(context),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          if (_generatedPackage != null) ...[
            const SizedBox(height: 24),
            Card(
              color: AppTheme.getSecondaryBackgroundFromContext(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'QR Code',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: _syncService.generateQrCode(_generatedPackage!, size: 250),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Version: ${_generatedPackage!.version}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Entity Types: ${_generatedPackage!.entityTypes.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Data Size: ${(_generatedPackage!.dataSize / 1024).toStringAsFixed(2)} KB',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScanTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: AppTheme.getSecondaryBackgroundFromContext(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: AppTheme.getAccentGoldFromContext(context),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scan QR Code to Sync',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scan a QR code from another device to import data',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getTextSecondaryFromContext(context),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<ConflictResolutionMode>(
            value: _conflictMode,
            decoration: InputDecoration(
              labelText: 'Conflict Resolution',
              filled: true,
              fillColor: AppTheme.getSecondaryBackgroundFromContext(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: ConflictResolutionMode.lastUpdated,
                child: Text('Use Most Recent'),
              ),
              DropdownMenuItem(
                value: ConflictResolutionMode.overwrite,
                child: Text('Overwrite Local'),
              ),
              DropdownMenuItem(
                value: ConflictResolutionMode.skip,
                child: Text('Skip Conflicts'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _conflictMode = value);
                AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.selectionClick);
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.getAccentGoldFromContext(context),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      _applyScannedData(barcode.rawValue!);
                      break;
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

