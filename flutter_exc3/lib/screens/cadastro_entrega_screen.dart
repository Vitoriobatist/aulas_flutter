// lib/screens/cadastro_entrega_screen.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../database/database_helper.dart';
import '../database/location_service.dart';
import '../models/entrega.dart';

class CadastroEntregaScreen extends StatefulWidget {
  // Se passarmos uma entrega, é edição. Caso contrário, é cadastro novo.
  final Entrega? entrega;

  const CadastroEntregaScreen({super.key, this.entrega});

  @override
  State<CadastroEntregaScreen> createState() => _CadastroEntregaScreenState();
}

class _CadastroEntregaScreenState extends State<CadastroEntregaScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _db = DatabaseHelper();

  // Controllers dos campos de texto
  late TextEditingController _codigoCtrl;
  late TextEditingController _destinatarioCtrl;
  late TextEditingController _enderecoCtrl;

  // Estado interno
  String _statusSelecionado = Entrega.statusOpcoes.first;
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _gpsCarregando = false;
  bool _salvando = false;

  bool get _edicao => widget.entrega != null;

  @override
  void initState() {
    super.initState();

    // Preenche os campos se for edição
    final e = widget.entrega;
    _codigoCtrl = TextEditingController(text: e?.codigo ?? '');
    _destinatarioCtrl = TextEditingController(text: e?.destinatario ?? '');
    _enderecoCtrl = TextEditingController(text: e?.endereco ?? '');
    _statusSelecionado = e?.status ?? Entrega.statusOpcoes.first;
    _latitude = e?.latitude ?? 0.0;
    _longitude = e?.longitude ?? 0.0;

    // Em novo cadastro, já tenta capturar GPS automaticamente
    if (!_edicao) {
      _capturarGPS();
    }
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _destinatarioCtrl.dispose();
    _enderecoCtrl.dispose();
    super.dispose();
  }

  // Obtém a localização atual via GPS
  Future<void> _capturarGPS() async {
    setState(() => _gpsCarregando = true);
    try {
      final Position pos = await LocationService.obterPosicaoAtual();
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao obter GPS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _gpsCarregando = false);
    }
  }

  // Salva ou atualiza a entrega
  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    // Data/hora atual
    final agora = DateTime.now();
    final dataHora = '${agora.day.toString().padLeft(2, '0')}/'
        '${agora.month.toString().padLeft(2, '0')}/'
        '${agora.year} '
        '${agora.hour.toString().padLeft(2, '0')}:'
        '${agora.minute.toString().padLeft(2, '0')}';

    try {
      if (_edicao) {
        // Atualiza entrega existente
        final atualizada = widget.entrega!.copyWith(
          codigo: _codigoCtrl.text.trim(),
          destinatario: _destinatarioCtrl.text.trim(),
          endereco: _enderecoCtrl.text.trim(),
          status: _statusSelecionado,
          latitude: _latitude,
          longitude: _longitude,
          dataHoraAtualizacao: dataHora,
        );
        await _db.atualizarEntrega(atualizada);
      } else {
        // Insere nova entrega
        final nova = Entrega(
          codigo: _codigoCtrl.text.trim(),
          destinatario: _destinatarioCtrl.text.trim(),
          endereco: _enderecoCtrl.text.trim(),
          status: _statusSelecionado,
          latitude: _latitude,
          longitude: _longitude,
          dataHoraAtualizacao: dataHora,
        );
        await _db.inserirEntrega(nova);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(_edicao ? 'Entrega atualizada!' : 'Entrega cadastrada!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_edicao ? 'Editar Entrega' : 'Nova Entrega'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Código da entrega ──────────────────────────
              _buildCampo(
                controller: _codigoCtrl,
                label: 'Código da Entrega',
                hint: 'Ex: ENT-2024-001',
                icone: Icons.qr_code,
                validar: (v) => v!.isEmpty ? 'Informe o código' : null,
              ),
              const SizedBox(height: 14),

              // ── Destinatário ───────────────────────────────
              _buildCampo(
                controller: _destinatarioCtrl,
                label: 'Nome do Destinatário',
                hint: 'Ex: João Silva',
                icone: Icons.person_outline,
                validar: (v) => v!.isEmpty ? 'Informe o destinatário' : null,
              ),
              const SizedBox(height: 14),

              // ── Endereço ───────────────────────────────────
              _buildCampo(
                controller: _enderecoCtrl,
                label: 'Endereço',
                hint: 'Rua, número, bairro, cidade',
                icone: Icons.location_on_outlined,
                maxLines: 2,
                validar: (v) => v!.isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 14),

              // ── Status ─────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _statusSelecionado,
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: const Icon(Icons.local_shipping_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: Entrega.statusOpcoes
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _statusSelecionado = v!),
              ),
              const SizedBox(height: 20),

              // ── Localização GPS ────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.my_location, color: Colors.teal),
                        const SizedBox(width: 8),
                        const Text(
                          'Localização GPS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const Spacer(),
                        // Botão para recapturar GPS
                        TextButton.icon(
                          onPressed: _gpsCarregando ? null : _capturarGPS,
                          icon: _gpsCarregando
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.teal,
                                  ),
                                )
                              : const Icon(Icons.refresh, size: 18),
                          label: Text(
                              _gpsCarregando ? 'Capturando...' : 'Atualizar'),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _latitude == 0.0 && _longitude == 0.0
                          ? 'Localização não capturada'
                          : 'Latitude: ${_latitude.toStringAsFixed(6)}\n'
                              'Longitude: ${_longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        color:
                            _latitude == 0.0 ? Colors.grey : Colors.teal[800],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Botão Salvar ───────────────────────────────
              ElevatedButton.icon(
                onPressed: _salvando ? null : _salvar,
                icon: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _salvando
                      ? 'Salvando...'
                      : (_edicao ? 'Salvar Alterações' : 'Cadastrar Entrega'),
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para campos de texto padronizados
  Widget _buildCampo({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icone,
    int maxLines = 1,
    String? Function(String?)? validar,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validar,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
