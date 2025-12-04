import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/api_service.dart';
import '../../../../services/dice_service.dart';
import '../../../../core/theme/app_theme.dart';

class DiceRollerPage extends StatefulWidget {
  const DiceRollerPage({super.key});

  @override
  State<DiceRollerPage> createState() => _DiceRollerPageState();
}

class _DiceRollerPageState extends State<DiceRollerPage> {
  final TextEditingController _diceNotationController = TextEditingController(text: '1d20');
  final TextEditingController _modifierController = TextEditingController(text: '0');
  DiceRollResult? _lastResult;
  bool _isLoading = false;
  String? _error;

  late DiceService _diceService;

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    _diceService = DiceService(apiService);
  }

  Future<void> _rollDice() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _lastResult = null;
    });

    try {
      final notation = _diceNotationController.text.trim();
      if (notation.isEmpty) {
        throw Exception('Inserisci una notazione valida (es. 1d20, 2d6+3)');
      }

      final result = await _diceService.rollDice(notation);
      setState(() {
        _lastResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _rollAbilityCheck() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _lastResult = null;
    });

    try {
      final modifier = int.tryParse(_modifierController.text) ?? 0;
      final result = await _diceService.rollAbilityCheck(modifier);
      setState(() {
        _lastResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _rollSavingThrow() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _lastResult = null;
    });

    try {
      final modifier = int.tryParse(_modifierController.text) ?? 0;
      final result = await _diceService.rollSavingThrow(modifier);
      setState(() {
        _lastResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _diceNotationController.dispose();
    _modifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiri di Dadi'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sezione Tiro Personalizzato
              Card(
                color: AppTheme.secondaryDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tiro Personalizzato',
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _diceNotationController,
                          decoration: InputDecoration(
                            labelText: 'Notazione Dadi',
                            hintText: 'es. 1d20, 2d6+3, 4d6',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppTheme.accentGold),
                            ),
                            filled: true,
                            fillColor: AppTheme.secondaryDark,
                          ),
                          style: textTheme.bodyLarge,
                        ),
                      const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _rollDice,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGold,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Tira i Dadi'),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Sezione Prove e Tiri Salvezza
              Card(
                color: AppTheme.secondaryDark,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prove e Tiri Salvezza',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _modifierController,
                        decoration: InputDecoration(
                          labelText: 'Modificatore',
                          hintText: 'es. +5, -2, 0',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppTheme.accentGold),
                          ),
                          filled: true,
                          fillColor: AppTheme.secondaryDark,
                        ),
                        keyboardType: TextInputType.number,
                        style: textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _rollAbilityCheck,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentGold,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Prova Caratteristica'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _rollSavingThrow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentGold,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Tiro Salvezza'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Risultato
              if (_error != null)
                Card(
                  color: Colors.red.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Errore',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (_error!.contains('Impossibile connettersi') || _error!.contains('404')) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Per risolvere:\n1. Avvia il backend: cd backend && python run.py\n2. Installa le librerie: pip install -r requirements.txt',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              
              if (_lastResult != null)
                Card(
                  color: AppTheme.secondaryDark,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Risultato',
                          style: textTheme.titleLarge?.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _lastResult!.notation,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            color: AppTheme.accentGold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.accentGold,
                              width: 3,
                            ),
                          ),
                          child: Text(
                            '${_lastResult!.total}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGold,
                            ),
                          ),
                        ),
                        if (_lastResult!.rolls.length > 1) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Tiri: ${_lastResult!.rolls.join(", ")}',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                        if (_lastResult!.details != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _lastResult!.details!,
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

