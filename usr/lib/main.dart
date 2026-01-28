import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CryptoWalletApp());
}

class CryptoWalletApp extends StatelessWidget {
  const CryptoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WalletGeneratorScreen(),
      },
    );
  }
}

class WalletGeneratorScreen extends StatefulWidget {
  const WalletGeneratorScreen({super.key});

  @override
  State<WalletGeneratorScreen> createState() => _WalletGeneratorScreenState();
}

class _WalletGeneratorScreenState extends State<WalletGeneratorScreen> {
  String? _privateKey;
  String? _publicAddress;
  bool _isGenerating = false;

  // Simulates secure key generation
  void _generateWallet() async {
    setState(() {
      _isGenerating = true;
      _privateKey = null;
      _publicAddress = null;
    });

    // Simulate computational delay for generation
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // In a real app, use 'bip39' and 'web3dart' or similar packages.
      // This is a simulation to demonstrate the concept.
      _privateKey = _generateRandomHex(64); 
      _publicAddress = '0x${_generateRandomHex(40)}';
      _isGenerating = false;
    });
  }

  String _generateRandomHex(int length) {
    const chars = '0123456789abcdef';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Wallet Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cryptographic Security',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'It is mathematically impossible to reverse a public address to find a private key using current technology. This is the "Discrete Logarithm Problem" that secures all cryptocurrencies.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Instead of "brute forcing" (which would take longer than the age of the universe), wallets work by generating a random private key first, then deriving the public address from it.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateWallet,
                icon: _isGenerating 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                    : const Icon(Icons.security),
                label: Text(_isGenerating ? 'Generating Entropy...' : 'Generate New Secure Wallet'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_privateKey != null) ...[
              _buildKeyDisplay('Private Key (Keep Secret)', _privateKey!, isSecret: true),
              const SizedBox(height: 16),
              const Icon(Icons.arrow_downward, color: Colors.grey),
              const SizedBox(height: 16),
              _buildKeyDisplay('Public Address (Shareable)', _publicAddress!, isSecret: false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKeyDisplay(String label, String value, {required bool isSecret}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSecret ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSecret ? Colors.red.shade200 : Colors.green.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isSecret ? Icons.lock : Icons.public, size: 16, color: Colors.black54),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            value,
            style: TextStyle(
              fontFamily: 'Courier',
              color: isSecret ? Colors.red.shade900 : Colors.green.shade900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
