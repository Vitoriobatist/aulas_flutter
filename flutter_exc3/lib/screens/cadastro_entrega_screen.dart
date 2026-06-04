import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../database/firebase_service.dart';
import '../database/location_service.dart';
import '../models/entrega.dart';
import '../theme/theme.dart';

class CadastroEntregaScreen extends StatefulWidget {
  final Entrega? entrega;
  const CadastroEntregaScreen({super.key, this.entrega});

  @override
  State<CadastroEntregaScreen> createState() => _CadastroEntregaScreenState();
}

class _CadastroEntregaScreenState extends State<CadastroEntregaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firebase = FirebaseService();

  late final TextEditingController _codigoCtrl;
  late final TextEditingController _destinatarioCtrl;
  late final TextEditingController _enderecoCtrl;

  String _statusSelecionado = Entrega.statusOpcoes.first;
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _gpsCarregando = false;
  bool _salvando = false;
  bool _dropdownAberto = false;

  bool get _edicao => widget.entrega != null;
  bool get _temGps => _latitude != 0.0 || _longitude != 0.0;

  @override
  void initState() {
    super.initState();
    final e = widget.entrega;
    _codigoCtrl = TextEditingController(text: e?.codigo ?? '');
    _destinatarioCtrl = TextEditingController(text: e?.destinatario ?? '');
    _enderecoCtrl = TextEditingController(text: e?.endereco ?? '');
    _statusSelecionado = e?.status ?? Entrega.statusOpcoes.first;
    _latitude = e?.latitude ?? 0.0;
    _longitude = e?.longitude ?? 0.0;
    if (!_edicao) _capturarGPS();
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _destinatarioCtrl.dispose();
    _enderecoCtrl.dispose();
    super.dispose();
  }

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
          SnackBar(content: Text('Erro ao obter GPS: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _gpsCarregando = false);
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    final agora = DateTime.now();
    final dataHora =
        '${agora.day.toString().padLeft(2, '0')}/'
        '${agora.month.toString().padLeft(2, '0')}/'
        '${agora.year} '
        '${agora.hour.toString().padLeft(2, '0')}:'
        '${agora.minute.toString().padLeft(2, '0')}';

    try {
      if (_edicao) {
        await _firebase.atualizarEntrega(widget.entrega!.copyWith(
          codigo: _codigoCtrl.text.trim(),
          destinatario: _destinatarioCtrl.text.trim(),
          endereco: _enderecoCtrl.text.trim(),
          status: _statusSelecionado,
          latitude: _latitude,
          longitude: _longitude,
          dataHoraAtualizacao: dataHora,
        ));
      } else {
        await _firebase.inserirEntrega(Entrega(
          codigo: _codigoCtrl.text.trim(),
          destinatario: _destinatarioCtrl.text.trim(),
          endereco: _enderecoCtrl.text.trim(),
          status: _statusSelecionado,
          latitude: _latitude,
          longitude: _longitude,
          dataHoraAtualizacao: dataHora,
        ));
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  _edicao ? 'Entrega atualizada!' : 'Entrega cadastrada!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_dropdownAberto) setState(() => _dropdownAberto = false);
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SectionHeader(
                          label: 'Dados da Entrega',
                          icon: AppIcons.package),
                      const SizedBox(height: 14),
                      _buildInput(
                        controller: _codigoCtrl,
                        hint: 'Código da Entrega',
                        icon: AppIcons.code,
                        validator: (v) =>
                            v!.isEmpty ? 'Informe o código' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildInput(
                        controller: _destinatarioCtrl,
                        hint: 'Nome do Destinatário',
                        icon: AppIcons.person,
                        validator: (v) =>
                            v!.isEmpty ? 'Informe o destinatário' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildInput(
                        controller: _enderecoCtrl,
                        hint: 'Endereço',
                        icon: AppIcons.location,
                        maxLines: 2,
                        validator: (v) =>
                            v!.isEmpty ? 'Informe o endereço' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildStatusDropdown(),
                      const SizedBox(height: 22),
                      _SectionHeader(
                          label: 'Localização',
                          icon: AppIcons.myLocation),
                      const SizedBox(height: 14),
                      _buildGpsCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBotaoSalvar(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: AppDecorations.backButton,
                child: const Icon(AppIcons.back, size: 18, color: Colors.white),
              ),
            ),
          ),
          Text(
            _edicao ? 'Editar Entrega' : 'Nova Entrega',
            style: AppTextStyles.appBarTitle,
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: AppTextStyles.bodyMedium,
      decoration: AppDecorations.inputDecoration(
        hint: hint,
        prefixIcon: Icon(icon, size: 18, color: AppColors.textDisabled),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    final cor = AppColors.statusColor(_statusSelecionado);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => setState(() => _dropdownAberto = !_dropdownAberto),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(
                  _dropdownAberto
                      ? AppDecorations.radiusMedium
                      : AppDecorations.radiusMedium),
              border: Border.all(
                color: _dropdownAberto
                    ? AppColors.primary
                    : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(AppIcons.delivery,
                    size: 18, color: AppColors.textDisabled),
                const SizedBox(width: 12),
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: cor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_statusSelecionado,
                      style: AppTextStyles.bodyMedium),
                ),
                Icon(
                  _dropdownAberto
                      ? AppIcons.expandLess
                      : AppIcons.expandMore,
                  size: 18,
                  color: AppColors.textDisabled,
                ),
              ],
            ),
          ),
        ),
        if (_dropdownAberto)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: AppDecorations.dropdownMenu,
            child: Column(
              children: Entrega.statusOpcoes.map((status) {
                final c = AppColors.statusColor(status);
                final selecionado = status == _statusSelecionado;
                return InkWell(
                  onTap: () => setState(() {
                    _statusSelecionado = status;
                    _dropdownAberto = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: selecionado
                          ? AppColors.primaryBg
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                          AppDecorations.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: c, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Text(status, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildGpsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.gpsCard(hasGps: _temGps),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _temGps ? AppIcons.gpsFixed : AppIcons.gpsOff,
                size: 18,
                color: _temGps ? AppColors.primary : AppColors.textDisabled,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _temGps ? 'GPS capturado' : 'GPS não capturado',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _temGps
                        ? AppColors.primary
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _gpsCarregando ? null : _capturarGPS,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _temGps
                        ? AppColors.primary.withValues(alpha: 0.07)
                        : AppColors.dividerLight,
                    borderRadius:
                        BorderRadius.circular(AppDecorations.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_gpsCarregando)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary),
                        )
                      else
                        const Icon(AppIcons.refresh,
                            size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        _gpsCarregando ? 'Capturando...' : 'Atualizar',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_temGps) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _CoordBox(
                        label: 'LATITUDE',
                        valor: _latitude.toStringAsFixed(6))),
                const SizedBox(width: 8),
                Expanded(
                    child: _CoordBox(
                        label: 'LONGITUDE',
                        valor: _longitude.toStringAsFixed(6))),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBotaoSalvar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      color: AppColors.background,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppDecorations.buttonShadow,
        ),
        child: ElevatedButton.icon(
          onPressed: _salvando ? null : _salvar,
          icon: _salvando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Icon(
                  _edicao ? AppIcons.save : AppIcons.addCircle,
                  size: 18,
                ),
          label: Text(
            _salvando
                ? 'Salvando...'
                : (_edicao ? 'Salvar Alterações' : 'Cadastrar Entrega'),
          ),
        ),
      ),
    );
  }
}

// ─── Auxiliares ───────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.sectionTitle),
        const SizedBox(width: 10),
        const Expanded(
            child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }
}

class _CoordBox extends StatelessWidget {
  final String label;
  final String valor;
  const _CoordBox({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: AppDecorations.coordBox,
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(valor,
              style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
