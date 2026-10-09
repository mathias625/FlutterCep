import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/pessoa.dart';
import '../root/file.dart';
import '../style/colors.dart';
import 'cadastro.dart';
import 'splash.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ArquivoService arquivoService = ArquivoService();
  List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final dados = await arquivoService.carregarPessoas();
    if (!mounted) return;
    setState(() {
      pessoas = dados;
    });
  }

  Future<void> adicionarPessoa() async {
    final novaPessoa = await Navigator.push<Pessoa>(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );

    if (novaPessoa != null) {
      setState(() {
        pessoas.add(novaPessoa);
      });
      await arquivoService.salvarPessoas(pessoas);
    }
  }

  Future<void> excluirPessoa(int index) async {
    setState(() {
      pessoas.removeAt(index);
    });
    await arquivoService.salvarPessoas(pessoas);
  }

  void encerrarApp() {
    SystemNavigator.pop();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas Cadastradas'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentMode, _) {
              final isDark = currentMode == ThemeMode.dark;
              return Row(
                children: [
                  const Text(
                    'Tema escuro',
                    style: TextStyle(fontSize: 12),
                  ),
                  Switch(
                    value: isDark,
                    activeThumbColor: AppColors.azulClaro,
                    onChanged: (bool value) {
                      themeNotifier.value =
                          value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.navyBlue,
              ),
              accountName: const Text(
                'Menu Principal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/icone.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.splitscreen),
              title: const Text('Splash'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Splash()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.redAccent,
              ),
              title: const Text('Sair'),
              onTap: encerrarApp,
            ),
          ],
        ),
      ),
      body: pessoas.isEmpty
          ? const Center(
              child: Text('Nenhuma pessoa cadastrada.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                final p = pessoas[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(
                      p.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${p.rua}, ${p.numero} ${p.complemento.isNotEmpty ? '(${p.complemento})' : ''}\n${p.bairro} - ${p.cidade}/${p.estado}\nCEP: ${p.cep}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => excluirPessoa(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionarPessoa,
        child: const Icon(Icons.add),
      ),
    );
  }
}

