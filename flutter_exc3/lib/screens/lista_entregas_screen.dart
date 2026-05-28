// lib/screens/lista_entregas_screen.dart

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/entrega.dart';
import 'cadastro_entrega_screen.dart';

class ListaEntregasScreen extends StatefulWidget {
  const ListaEntregasScreen({super.key});

  @override
  State<ListaEntregasScreen> createState() => _ListaEntregasScreenState();
}

class _ListaEntregasScreenState extends State<ListaEntregasScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Entrega> _entregas = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarEntregas();
  }

  Future<void> _carregarEntregas() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await _db.listarEntregas();
      if (!mounted) return;
      setState(() {
        _entregas = lista;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = 'Erro ao carregar entregas: $e';
        _carregando = false;
      });
    }
  }

  Future<void> _deletarEntrega(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir entrega'),
        content: const Text('Deseja realmente excluir esta entrega?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _db.deletarEntrega(id);
      _carregarEntregas();
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'Entregue':
        return Colors.green;
      case 'Em transporte':
        return Colors.blue;
      case 'Saiu para entrega':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar lista',
            onPressed: _carregarEntregas,
          ),
        ],
      ),

      // Botão para adicionar nova entrega
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CadastroEntregaScreen(),
            ),
          );
          _carregarEntregas(); // Recarrega ao voltar
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Entrega'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _erro != null
              ? _buildErro()
              : _entregas.isEmpty
                  ? _buildVazio()
                  : _buildLista(),
    );
  }

  Widget _buildErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _erro!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _carregarEntregas,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma entrega cadastrada',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque em "Nova Entrega" para começar',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildLista() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _entregas.length,
      itemBuilder: (context, index) {
        final e = _entregas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho: código + status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '# ${e.codigo}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _corStatus(e.status).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _corStatus(e.status)),
                      ),
                      child: Text(
                        e.status,
                        style: TextStyle(
                          color: _corStatus(e.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Destinatário
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(e.destinatario, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),

                // Endereço
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        e.endereco,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // GPS
                Row(
                  children: [
                    const Icon(Icons.my_location, size: 16, color: Colors.teal),
                    const SizedBox(width: 6),
                    Text(
                      'Lat: ${e.latitude.toStringAsFixed(5)} | '
                      'Lon: ${e.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(fontSize: 12, color: Colors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Data/hora
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      e.dataHoraAtualizacao,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const Divider(height: 16),

                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Editar
                    TextButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CadastroEntregaScreen(entrega: e),
                          ),
                        );
                        _carregarEntregas();
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(foregroundColor: Colors.teal),
                    ),
                    const SizedBox(width: 8),
                    // Excluir
                    TextButton.icon(
                      onPressed: () => _deletarEntrega(e.id!),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Excluir'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
