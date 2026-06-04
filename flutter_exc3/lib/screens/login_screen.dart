import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'lista_entregas_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Usuários cadastrados no app
class _Usuario {
  final String email;
  final String senha;
  final String nome;
  const _Usuario(this.email, this.senha, this.nome);
}

const _usuarios = [
  _Usuario('vitorio@vitorio', 'vitorio', 'Vitório'),
];

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _senhaVisivel = false;
  bool _carregando = false;
  bool _emailFocused = false;
  bool _senhaFocused = false;
  String? _erroLogin;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _carregando = true;
      _erroLogin = null;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final email = _emailCtrl.text.trim();
    final senha = _senhaCtrl.text;

    final usuario = _usuarios.where(
      (u) => u.email == email && u.senha == senha,
    ).firstOrNull;

    if (!mounted) return;

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ListaEntregasScreen(nomeUsuario: usuario.nome, emailUsuario: usuario.email),
        ),
      );
    } else {
      setState(() {
        _carregando = false;
        _erroLogin = 'E-mail ou senha incorretos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: Image.asset(
                      'assets/logo_full.png',
                      width: MediaQuery.of(context).size.width * 0.85,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Campo e-mail
                _FocusInput(
                  onFocusChange: (v) => setState(() => _emailFocused = v),
                  child: TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.bodyMedium,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe o e-mail' : null,
                    decoration: AppDecorations.inputDecoration(
                      hint: 'E-mail',
                      prefixIcon: Icon(
                        AppIcons.mail,
                        size: 18,
                        color: _emailFocused
                            ? AppColors.primary
                            : AppColors.textDisabled,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Campo senha
                _FocusInput(
                  onFocusChange: (v) => setState(() => _senhaFocused = v),
                  child: TextFormField(
                    controller: _senhaCtrl,
                    obscureText: !_senhaVisivel,
                    style: AppTextStyles.bodyMedium,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe a senha' : null,
                    decoration: AppDecorations.inputDecoration(
                      hint: 'Senha',
                      prefixIcon: Icon(
                        AppIcons.lock,
                        size: 18,
                        color: _senhaFocused
                            ? AppColors.primary
                            : AppColors.textDisabled,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => _senhaVisivel = !_senhaVisivel),
                        child: Icon(
                          _senhaVisivel
                              ? AppIcons.visibility
                              : AppIcons.visibilityOff,
                          size: 18,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Esqueci a senha
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Recuperação de senha em breve')),
                      );
                    },
                    child: Text(
                      'Esqueci a senha',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Mensagem de erro de login
                if (_erroLogin != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 16, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _erroLogin!,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Botão Entrar
                _AnimatedButton(
                  onTap: _carregando ? null : _entrar,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppDecorations.buttonShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_carregando)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          Text('Entrar', style: AppTextStyles.labelLarge),
                          const SizedBox(width: 8),
                          const Icon(AppIcons.forward,
                              size: 18, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Divisor "ou"
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou',
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),
                const SizedBox(height: 20),

                // Botão Google
                _AnimatedButton(
                  onTap: () {},
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.divider, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google "G" SVG simplificado como texto estilizado
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.textDisabled, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Continuar com Google',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Cadastre-se
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Não tem conta? ',
                      style: AppTextStyles.caption.copyWith(fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Cadastre-se',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar: detecta foco para mudar cor do ícone
class _FocusInput extends StatefulWidget {
  final Widget child;
  final ValueChanged<bool> onFocusChange;
  const _FocusInput(
      {required this.child, required this.onFocusChange});

  @override
  State<_FocusInput> createState() => _FocusInputState();
}

class _FocusInputState extends State<_FocusInput> {
  final _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _node.addListener(() => widget.onFocusChange(_node.hasFocus));
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(focusNode: _node, child: widget.child);
  }
}

// Widget auxiliar: escala ao pressionar
class _AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _AnimatedButton({required this.child, this.onTap});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1, end: 0.98).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
