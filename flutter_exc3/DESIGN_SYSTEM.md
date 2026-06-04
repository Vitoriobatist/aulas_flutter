# Ultra Delivery — Design System

> Documento de referência visual para o app **Ultra Delivery** (Flutter + Firebase).  
> Use este arquivo como base para criar mockups, protótipos ou novas telas.

---

## Índice

1. [Identidade Visual](#1-identidade-visual)
2. [Paleta de Cores](#2-paleta-de-cores)
3. [Tipografia](#3-tipografia)
4. [Espaçamento e Raios de Borda](#4-espaçamento-e-raios-de-borda)
5. [Sombras](#5-sombras)
6. [Componentes](#6-componentes)
7. [Telas](#7-telas)
8. [Estados Especiais](#8-estados-especiais)
9. [Estrutura de Arquivos](#9-estrutura-de-arquivos)

---

## 1. Identidade Visual

| Elemento | Valor |
|---|---|
| Nome do app | Ultra Delivery |
| Tagline | Controle de Entregas |
| Família tipográfica | Roboto (padrão Material 3) |
| Estilo | Moderno, limpo, confiável — azul como cor dominante |
| Plataforma-alvo | Android (Firebase) |

**Logo:** caixa de entrega em isometria com linhas de velocidade, em dois tons de azul (navy `#0D47A1` + electric `#2979FF`).

---

## 2. Paleta de Cores

### 2.1 Cores de Marca

| Token | Hex | Uso |
|---|---|---|
| `primary` | `#1565C0` | Botões, ícones ativos, bordas focadas, FAB |
| `primaryDark` | `#0D47A1` | AppBar (início do gradiente), texto de destaque |
| `primaryLight` | `#1976D2` | AppBar (fim do gradiente) |
| `accent` | `#2979FF` | Destaques, links |

### 2.2 Gradientes

| Token | Cores | Direção | Uso |
|---|---|---|---|
| `gradientAppBar` | `#0D47A1` → `#1976D2` | topLeft → bottomRight | AppBar de todas as telas |
| `gradientCard` | `#1565C0` → `#42A5F5` | topLeft → bottomRight | Painel de resumo de estatísticas |

### 2.3 Superfícies

| Token | Hex | Uso |
|---|---|---|
| `background` | `#F0F4F8` | Scaffold de todas as telas |
| `surface` | `#FFFFFF` | Cards, inputs, dropdowns |
| `surfaceBlue` | `#E3F2FD` | Card GPS com sinal ativo, empty state icon |

### 2.4 Cores de Status de Entrega

| Status | Token | Hex | Ícone |
|---|---|---|---|
| Pendente | `statusPendente` | `#757575` | `hourglass_empty_outlined` |
| Saiu para entrega | `statusSaiu` | `#E65100` | `directions_bike_outlined` |
| Em transporte | `statusTransporte` | `#1565C0` | `local_shipping_outlined` |
| Entregue | `statusEntregue` | `#2E7D32` | `check_circle_outline` |

### 2.5 Feedback / Sistema

| Token | Hex | Uso |
|---|---|---|
| `error` | `#D32F2F` | Erros de validação, snackbar de falha, botão Excluir |
| `success` | `#2E7D32` | Confirmações (compartilha cor com Entregue) |
| `warning` | `#E65100` | Firebase não configurado, avisos |

### 2.6 Texto

| Token | Hex | Uso |
|---|---|---|
| `textPrimary` | `#0D47A1` | Títulos, código da entrega (`#ENT-001`) |
| `textSecondary` | `#546E7A` | Hora de atualização, rótulos secundários |
| `textDisabled` | `#B0BEC5` | Placeholder, texto de empty state |
| `divider` | `#CFD8DC` | Divisores, bordas de input desabilitado |

---

## 3. Tipografia

Fonte base: **Roboto** (Material 3 padrão).

### 3.1 Escala

| Token | Tamanho | Peso | Cor padrão | Uso |
|---|---|---|---|---|
| `headlineLarge` | 22 sp | 700 | `textPrimary` | Títulos de página |
| `headlineMedium` | 18 sp | 700 | `textPrimary` | Subtítulos importantes, empty state |
| `headlineSmall` | 15 sp | 700 | `textPrimary` | Código da entrega no card (`# ENT-001`) |
| `bodyLarge` | 15 sp | 400 | `black87` | Texto de destinatário |
| `bodyMedium` | 13 sp | 400 | `black87` | Informações de card, labels de botão |
| `bodySmall` | 11 sp | 400 | `textSecondary` | Textos auxiliares |
| `labelLarge` | 16 sp | 600 | `primary` | Botão primário |
| `labelMedium` | 13 sp | 600 | `primary` | Botões de ação (Editar / Excluir) |
| `labelSmall` | 11 sp | 700 | *(dinâmica)* | Badge de status do card |
| `appBarTitle` | 18 sp | 700 | `white` | Título na AppBar |
| `statValue` | 20 sp | 700 | `white` | Números no painel de resumo |
| `statLabel` | 11 sp | 400 | `white70` | Rótulos no painel de resumo |
| `sectionTitle` | 14 sp | 700 | `primary` | Cabeçalho de seção no formulário |

---

## 4. Espaçamento e Raios de Borda

### 4.1 Raios (Border Radius)

| Token | Valor | Uso |
|---|---|---|
| `radiusSmall` | 8 dp | Botões de ação (Editar/Excluir), diálogo de excluir |
| `radiusMedium` | 12 dp | Inputs, dropdown, card GPS, botão salvar |
| `radiusLarge` | 14 dp | Cards de entrega, painel de resumo, diálogo |
| `radiusPill` | 20 dp | Badge de status |

### 4.2 Espaçamentos Frequentes

| Elemento | Valor |
|---|---|
| Padding lateral das listas | 16 dp |
| Padding interno dos cards | 14 dp (lados/topo), 10 dp (base) |
| Padding da lista (base, para o FAB) | 88 dp |
| Padding do formulário | 20 dp (all) |
| Espaço entre campos do formulário | 14 dp |
| Espaço entre seções do formulário | 24 dp |
| Margem do painel de resumo | 16 dp lados, 16 dp topo, 4 dp base |
| Altura da AppBar | 64 dp |
| Altura do botão salvar | 52 dp |
| Barra lateral colorida no card | 5 dp largura |

---

## 5. Sombras

| Token | Blur | Offset | Cor | Uso |
|---|---|---|---|---|
| `cardShadow` | 10 dp | (0, 3) | `black 6%` | Cards de entrega |
| `summaryCardShadow` | 12 dp | (0, 4) | `primary 30%` | Painel de resumo |
| `buttonShadow` | 8 dp | (0, 3) | `primary 40%` | FAB, botão salvar |
| `emptyStateIcon shadow` | 20 dp | (0, 6) | `primary 15%` | Círculo do empty state |

---

## 6. Componentes

### 6.1 AppBar

```
┌─────────────────────────────────────────────┐
│  [ícone delivery]  Ultra Delivery           │  ← height: 64 dp
│  Gradiente: #0D47A1 → #1976D2 (topLeft→BR)  │
└─────────────────────────────────────────────┘
```

- Gradiente sempre visível via `flexibleSpace`
- `backgroundColor: transparent` + `elevation: 0`
- Ícone e título em `white`
- Tela de cadastro: tem botão voltar (`arrow_back_ios_new_rounded`) + título centralizado

---

### 6.2 Painel de Resumo (Summary Card)

```
┌──────────────────────────────────────────────┐
│  📦 Total  │  ✔ Entregues  │  ⏳ Pendentes  │
│    12      │      8        │       4         │  ← gradiente azul
└──────────────────────────────────────────────┘
```

- Gradiente `#1565C0` → `#42A5F5`
- Border radius: 14 dp
- Padding: 20 dp horizontal, 14 dp vertical
- Divisores verticais brancos com opacidade 30%
- Texto branco: valor em 20 sp bold, rótulo em 11 sp white70

---

### 6.3 Card de Entrega

```
┌─┬────────────────────────────────────────────┐
│▌│  # ENT-001          [● Em transporte]       │
│▌│                                             │
│▌│  👤 João Silva                              │
│▌│  📍 Rua das Flores, 123, SP                 │
│▌│  🎯 Lat: -23.55050  Lon: -46.63330          │
│▌│  🕐 03/06/2026 14:30                        │
│▌│  ─────────────────────────────────────────  │
│▌│                    [Editar]  [Excluir]       │
└─┴────────────────────────────────────────────┘
  ↑ barra lateral 5dp
  cor = cor do status
```

- Fundo: `white`
- Border radius: 14 dp
- Sombra: `cardShadow`
- **Barra lateral** (5 dp): cor do status, arredondada nos cantos esquerdo
- **Badge de status**: pill com cor do status a 10% de opacidade + borda 40%
- Ícone de cada info row: 15 dp, cor contextual
- Texto info row: 13 sp

---

### 6.4 Botões de Ação no Card

```
[ ✏ Editar ]   [ 🗑 Excluir ]
```

- Estilo: `OutlinedButton.icon`
- Padding: 14 dp horizontal, 6 dp vertical
- Border radius: 8 dp
- Editar: cor `primary (#1565C0)`
- Excluir: cor `error (#D32F2F)`
- Borda: cor com 50% opacidade
- Texto: 13 sp

---

### 6.5 FAB (Floating Action Button)

```
         [+ Nova Entrega]
```

- Estilo: `FloatingActionButton.extended`
- Background: `primary (#1565C0)`
- Foreground: `white`
- Texto: 600 weight
- Elevation: 4
- Border radius: 16 dp

---

### 6.6 Campos de Formulário (Input)

```
┌─────────────────────────────────────────┐
│ [ícone]  Label                          │
│          Hint text...                   │
└─────────────────────────────────────────┘
```

- Fundo: `white` (filled)
- Border radius: 12 dp
- Borda normal: `divider (#CFD8DC)`
- Borda focada: `primary (#1565C0)` — 1.8 dp
- Borda de erro: `error (#D32F2F)`
- Padding: 16 dp horizontal, 14 dp vertical
- Ícone prefix: 20 dp, cor `primary`

---

### 6.7 Card GPS

```
┌──────────────────────────────────────────┐
│  📡 GPS capturado          [↺ Atualizar] │
│                                          │
│  ┌─────────────────┬───────────────────┐ │
│  │   Latitude       │   Longitude       │ │
│  │  -23.550505      │  -46.633309       │ │
│  └─────────────────┴───────────────────┘ │
└──────────────────────────────────────────┘
```

- Com GPS: fundo `surfaceBlue (#E3F2FD)`, borda `primary 35%`
- Sem GPS: fundo `grey.50`, borda `divider`
- Border radius: 12 dp
- Inner box de coordenadas: `white`, radius 8 dp, borda `primary 20%`

---

### 6.8 Snackbar

- Background: `primary (#1565C0)`
- Texto: `white`
- Floating behavior
- Border radius: 10 dp
- Erro: background `error (#D32F2F)`

---

### 6.9 Diálogo de Confirmação (Excluir)

```
┌────────────────────────────┐
│  Excluir entrega           │
│                            │
│  Remover a entrega #001?   │
│                            │
│      [Cancelar] [Excluir]  │
└────────────────────────────┘
```

- Border radius: 14 dp
- Cancelar: `TextButton` (primary)
- Excluir: `ElevatedButton` background `error`, foreground `white`, radius 8 dp

---

## 7. Telas

### 7.1 Lista de Entregas (`ListaEntregasScreen`)

**Rota:** tela inicial do app

```
┌────────────────────────────────────────────┐
│ APPBAR: [📦] Ultra Delivery                │  ← gradiente navy→blue
├────────────────────────────────────────────┤
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │  📦 12  │  ✔ 8   │  ⏳ 4            │  │  ← Summary Card (gradiente)
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │▌ # ENT-001    [● Em transporte]      │  │
│  │▌ 👤 João Silva                       │  │
│  │▌ 📍 Rua das Flores, 123              │  │
│  │▌ 🎯 Lat: -23.55050  Lon: -46.63330  │  │
│  │▌ 🕐 03/06/2026 14:30                 │  │
│  │▌ ─────────────────────────────────── │  │
│  │▌              [Editar]  [Excluir]    │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │▌ # ENT-002    [✔ Entregue]           │  │
│  │  ...                                 │  │
│  └──────────────────────────────────────┘  │
│                                            │
│                      ╔══════════════════╗  │
│                      ║  + Nova Entrega  ║  │  ← FAB
│                      ╚══════════════════╝  │
└────────────────────────────────────────────┘
```

**Comportamentos:**
- `StreamBuilder` no Firebase Realtime Database — lista em tempo real
- Scroll vertical com padding inferior de 88 dp (espaço do FAB)
- Barra lateral do card muda de cor conforme o status
- Tap em "Editar" → `CadastroEntregaScreen` com entrega preenchida
- Tap em "Excluir" → diálogo de confirmação → deleta no Firebase

---

### 7.2 Cadastro / Edição de Entrega (`CadastroEntregaScreen`)

**Rota:** empurrada via `Navigator.push`  
**Parâmetro opcional:** `entrega` (se informado, modo edição)

```
┌────────────────────────────────────────────┐
│ APPBAR: [←] Nova Entrega / Editar Entrega  │  ← gradiente, centralizado
├────────────────────────────────────────────┤
│                                            │
│  📦 Dados da Entrega ──────────────────    │  ← Section header
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │ [QR] Código da Entrega               │  │
│  │      Ex: ENT-2024-001                │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │ [👤] Nome do Destinatário            │  │
│  │      Ex: João Silva                  │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │ [📍] Endereço                        │  │
│  │      Rua, número, bairro, cidade     │  │  ← maxLines: 2
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │ [🚚] Status        ▾                 │  │
│  │      Pendente                        │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  🎯 Localização ───────────────────────    │  ← Section header
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │  📡 GPS capturado    [↺ Atualizar]   │  │
│  │  ┌────────────┬─────────────────┐    │  │
│  │  │ Latitude   │ Longitude       │    │  │
│  │  │ -23.550505 │ -46.633309      │    │  │
│  │  └────────────┴─────────────────┘    │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │        [💾] Cadastrar Entrega        │  │  ← 52 dp altura
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

**Comportamentos:**
- No modo criação: GPS é capturado automaticamente ao abrir (`initState`)
- Botão "Atualizar" chama `LocationService.obterPosicaoAtual()` novamente
- Validação de formulário em todos os campos antes de salvar
- Loading spinner no botão enquanto salva (`_salvando = true`)
- Botão muda texto/ícone: criação → "Cadastrar Entrega" / edição → "Salvar Alterações"

**Dropdown de Status:**

| Opção | Cor no badge |
|---|---|
| Pendente | `#757575` |
| Saiu para entrega | `#E65100` |
| Em transporte | `#1565C0` |
| Entregue | `#2E7D32` |

---

## 8. Estados Especiais

### 8.1 Loading (aguardando Firebase)

```
        ┌──────────┐
        │    ⟳     │  ← CircularProgressIndicator
        │          │      cor: primary (#1565C0)
        └──────────┘
```

### 8.2 Empty State (lista vazia)

```
          ╭──────────╮
          │    📦    │  ← círculo surfaceBlue, sombra blue 15%
          ╰──────────╯
      Nenhuma entrega cadastrada    ← headlineMedium / textPrimary
   Toque em "Nova Entrega" para começar  ← bodyMedium / textDisabled
```

### 8.3 Erro — Firebase não configurado

```
          📱  ← ícone laranja (warning)
   Firebase não configurado para esta plataforma.
   Execute o app no Android.
```

### 8.4 Erro genérico

```
          ⚠  ← ícone vermelho (error)
   Erro ao carregar entregas:
   [mensagem técnica]
```

### 8.5 GPS não capturado

```
┌──────────────────────────────────────┐
│  📡 GPS não capturado  [↺ Atualizar] │  ← fundo grey.50
└──────────────────────────────────────┘
```

---

## 9. Estrutura de Arquivos

```
lib/
├── main.dart                        ← EntregasApp + AppTheme.light
│
├── theme/
│   ├── theme.dart                   ← barrel export (import único)
│   ├── app_colors.dart              ← AppColors (todas as cores)
│   ├── app_text_styles.dart         ← AppTextStyles (tipografia)
│   ├── app_decorations.dart         ← AppDecorations (BoxDecoration, InputDecoration, raios, sombras)
│   ├── app_icons.dart               ← AppIcons (ícones centralizados)
│   └── app_theme.dart               ← AppTheme.light (ThemeData Material 3)
│
├── models/
│   └── entrega.dart                 ← modelo de dados (Entrega)
│
├── screens/
│   ├── lista_entregas_screen.dart   ← tela principal (lista + resumo)
│   └── cadastro_entrega_screen.dart ← tela de criação / edição
│
└── database/
    ├── firebase_service.dart        ← CRUD Firebase Realtime Database
    └── location_service.dart        ← GPS via Geolocator
```

**Como usar o design system em qualquer tela nova:**

```dart
import '../theme/theme.dart';

// Cores
color: AppColors.primary
color: AppColors.statusColor(entrega.status)

// Tipografia
style: AppTextStyles.headlineMedium
style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)

// Decorações
decoration: AppDecorations.deliveryCard
decoration: AppDecorations.inputDecoration(label: '...', hint: '...', prefixIcon: ...)

// Ícones
icon: Icon(AppIcons.delivery)
icon: Icon(AppIcons.statusIcon(entrega.status))
```

---

*Gerado em 03/06/2026 — Ultra Delivery v1.0*
