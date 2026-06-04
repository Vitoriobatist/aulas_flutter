import 'package:flutter/material.dart';
import '../database/firebase_service.dart';
import '../models/entrega.dart';
import '../theme/theme.dart';
import 'cadastro_entrega_screen.dart';
import 'login_screen.dart';

class ListaEntregasScreen extends StatefulWidget {
  final String nomeUsuario;
  final String emailUsuario;

  const ListaEntregasScreen({
    super.key,
    this.nomeUsuario = 'Entregador',
    this.emailUsuario = 'usuario@email.com',
  });

  @override
  State<ListaEntregasScreen> createState() => _ListaEntregasScreenState();
}

class _ListaEntregasScreenState extends State<ListaEntregasScreen> {
  bool _menuAberto = false;
  final _menuKey = GlobalKey();

  void _toggleMenu() => setState(() => _menuAberto = !_menuAberto);

  void _sair() {
    setState(() => _menuAberto = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _deletarEntrega(Entrega entrega) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.radiusLarge)),
        title: Text('Excluir entrega',
            style: AppTextStyles.headlineSmall
                .copyWith(color: AppColors.textPrimary)),
        content: Text('Remover a entrega #${entrega.codigo}?',
            style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar',
                style: AppTextStyles.labelMedium),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: Size.zero,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await FirebaseService().deletarEntrega(entrega.firebaseKey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_menuAberto) setState(() => _menuAberto = false);
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: StreamBuilder<List<Entrega>>(
                stream: FirebaseService().streamEntregas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _buildErro(snapshot.error.toString());
                  }
                  final entregas = snapshot.data ?? [];
                  if (entregas.isEmpty) return _buildEmptyState();

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    children: [
                      _SummaryBar(entregas: entregas),
                      const SizedBox(height: 20),
                      _buildListHeader(),
                      const SizedBox(height: 10),
                      ...entregas.map((e) => _DeliveryCard(
                            entrega: e,
                            onEditar: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CadastroEntregaScreen(entrega: e)),
                            ),
                            onExcluir: () => _deletarEntrega(e),
                          )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
            bottom: BorderSide(color: AppColors.dividerLight, width: 1)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Row(
            children: [
              Image.asset('assets/icon.png', width: 28, height: 28),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ultra Delivery', style: AppTextStyles.appBarBrand),
                  Text('Controle de entregas',
                      style: AppTextStyles.appBarSubtitle),
                ],
              ),
            ],
          ),
          // Avatar + menu
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                key: _menuKey,
                onTap: _toggleMenu,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration:
                      AppDecorations.userAvatar(active: _menuAberto),
                  child: Icon(
                    AppIcons.person,
                    size: 18,
                    color: _menuAberto ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
              if (_menuAberto) _buildUserMenu(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      constraints: const BoxConstraints(minWidth: 160),
      decoration: AppDecorations.dropdownMenu,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Info do usuário
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColors.dividerLight)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(AppIcons.person,
                      size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.nomeUsuario,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                    Text(widget.emailUsuario,
                        style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          // Sair
          InkWell(
            onTap: _sair,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppDecorations.radiusMedium),
              bottomRight: Radius.circular(AppDecorations.radiusMedium),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(AppIcons.logout, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Text('Sair',
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Entregas recentes',
            style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted, fontWeight: FontWeight.w700)),
        Text('Ver tudo',
            style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppDecorations.fabShadow,
      ),
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CadastroEntregaScreen()),
        ),
        icon: const Icon(AppIcons.add, size: 18),
        label: Text('Nova Entrega', style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(AppIcons.delivery,
                size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text('Nenhuma entrega', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text('Toque em "Nova Entrega" para começar',
              style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildErro(String erro) {
    final naoConfig = erro.contains('not been configured');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              naoConfig ? AppIcons.phone : AppIcons.error,
              size: 64,
              color: naoConfig ? AppColors.statusSaiu : AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              naoConfig
                  ? 'Firebase não configurado.\nExecute o app no Android.'
                  : 'Erro ao carregar entregas:\n$erro',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: naoConfig ? AppColors.statusSaiu : AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SummaryBar ──────────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  final List<Entrega> entregas;
  const _SummaryBar({required this.entregas});

  @override
  Widget build(BuildContext context) {
    final total = entregas.length;
    final entregues = entregas.where((e) => e.status == 'Entregue').length;
    final transporte =
        entregas.where((e) => e.status == 'Em transporte').length;
    final pendentes = entregas.where((e) => e.status == 'Pendente').length;

    final items = [
      (total, 'TOTAL', AppIcons.package, AppColors.primary),
      (entregues, 'ENTREGAS', AppIcons.checkCircle, AppColors.statusEntregue),
      (transporte, 'TRÂNSITO', AppIcons.delivery, AppColors.statusSaiu),
      (pendentes, 'PENDENTES', AppIcons.hourglass, AppColors.statusPendente),
    ];

    return Row(
      children: items
          .map((item) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: item == items.first ? 0 : 4,
                      right: item == items.last ? 0 : 4),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 6),
                  decoration: AppDecorations.summaryItemCard,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.$3, size: 16, color: item.$4),
                      const SizedBox(height: 6),
                      Text(item.$1.toString(),
                          style: AppTextStyles.statValue),
                      const SizedBox(height: 2),
                      Text(item.$2, style: AppTextStyles.statLabel),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// ─── DeliveryCard ─────────────────────────────────────────────────────────────

class _DeliveryCard extends StatefulWidget {
  final Entrega entrega;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  const _DeliveryCard({
    required this.entrega,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  State<_DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<_DeliveryCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.entrega;
    final cor = AppColors.statusColor(e.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: AppDecorations.deliveryCard,
      child: Column(
        children: [
          // Linha principal (sempre visível)
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            borderRadius: BorderRadius.circular(AppDecorations.radiusLarge),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  // Ícone de status
                  Container(
                    width: 40,
                    height: 40,
                    decoration: AppDecorations.statusIconContainer(cor),
                    child: Icon(AppIcons.statusIcon(e.status),
                        size: 20, color: cor),
                  ),
                  const SizedBox(width: 12),
                  // Informações
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('#${e.codigo}',
                                style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    fontSize: 14)),
                            _StatusBadge(status: e.status, cor: cor),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(e.destinatario,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted)),
                        const SizedBox(height: 2),
                        Text(e.endereco,
                            style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                color: AppColors.textDisabled),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Chevron
                  AnimatedRotation(
                    turns: _expandido ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      AppIcons.expandMore,
                      size: 20,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Painel expandido
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeInOut,
            crossFadeState: _expandido
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildExpanded(e, cor),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(Entrega e, Color cor) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.dividerLight)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        children: [
          _InfoRow(AppIcons.person, e.destinatario, AppColors.textMuted),
          const SizedBox(height: 8),
          _InfoRow(AppIcons.location, e.endereco, AppColors.textMuted),
          const SizedBox(height: 8),
          _InfoRow(
            AppIcons.myLocation,
            'Lat: ${e.latitude.toStringAsFixed(5)}  '
                'Lon: ${e.longitude.toStringAsFixed(5)}',
            AppColors.primary,
          ),
          const SizedBox(height: 8),
          _InfoRow(AppIcons.clock, e.dataHoraAtualizacao, AppColors.textMuted),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(
                label: 'Editar',
                icon: AppIcons.edit,
                color: AppColors.primary,
                onTap: widget.onEditar,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                label: 'Excluir',
                icon: AppIcons.delete,
                color: AppColors.error,
                onTap: widget.onExcluir,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Badge de status
class _StatusBadge extends StatelessWidget {
  final String status;
  final Color cor;
  const _StatusBadge({required this.status, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: AppDecorations.statusBadge(cor),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(color: cor),
      ),
    );
  }
}

// Linha de informação
class _InfoRow extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color cor;
  const _InfoRow(this.icone, this.texto, this.cor);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 15, color: AppColors.textDisabled),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: AppTextStyles.bodySmall.copyWith(color: cor),
          ),
        ),
      ],
    );
  }
}

// Botão de ação (Editar / Excluir)
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(
            color: color.withValues(alpha: 0.19), width: 1.5),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDecorations.radiusSmall)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: AppTextStyles.labelMedium
            .copyWith(color: color, fontSize: 12),
      ),
    );
  }
}
