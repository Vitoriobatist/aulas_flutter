const pptxgen = require("C:/Users/vit/AppData/Roaming/npm/node_modules/pptxgenjs");
let pres = new pptxgen();
pres.layout = "LAYOUT_16x9";
pres.title = "Ultra Delivery — Projeto Flutter";

// ── Paleta ────────────────────────────────────────────────
const C = {
  primary:   "2563EB", primaryDk: "1D4ED8", primaryLt: "3B82F6",
  primaryBg: "EFF6FF", dark:      "0F172A", medium:    "1E293B",
  surface:   "FFFFFF", bgLight:   "F4F6FA", text:      "0F172A",
  muted:     "64748B", disabled:  "94A3B8", divider:   "E2E8F0",
  divLt:     "F1F5F9", green:     "16A34A", orange:    "F97316",
  red:       "EF4444", purple:    "7C3AED", fire:      "F57C00",
};

// Fresh shadow objects (PptxGenJS mutates in-place)
const sh  = () => ({ type:"outer", blur:10, offset:3, angle:135, color:"000000", opacity:0.10 });
const shS = () => ({ type:"outer", blur:5,  offset:2, angle:135, color:"000000", opacity:0.07 });

// Barra superior colorida
function topBar(s, color) {
  s.addShape(pres.shapes.RECTANGLE, { x:0,y:0,w:10,h:0.07, fill:{color}, line:{color} });
}

// Título de seção
function sectionTitle(s, label, title) {
  s.addText(label.toUpperCase(), {
    x:0.55, y:0.22, w:9, h:0.28,
    fontSize:9, bold:true, color:C.primary, charSpacing:3,
    fontFace:"Calibri", margin:0
  });
  s.addText(title, {
    x:0.55, y:0.48, w:9, h:0.6,
    fontSize:28, bold:true, color:C.dark, fontFace:"Calibri", margin:0
  });
}

// Card branco com sombra
function card(s, x, y, w, h) {
  s.addShape(pres.shapes.RECTANGLE, {
    x,y,w,h, fill:{color:C.surface}, line:{color:C.divLt}, shadow:shS()
  });
}

// ── Mockup de celular ────────────────────────────────────
// px = left X da moldura, py = top Y da moldura
// retorna { sx, sy } = X e Y do início da tela interna
function phone(s, px, py) {
  const pw=2.1, ph=4.1;
  // Corpo
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x:px, y:py, w:pw, h:ph,
    fill:{color:C.medium}, rectRadius:0.2,
    line:{color:"334155", width:2}, shadow:sh()
  });
  // Tela
  const sx=px+0.12, sy=py+0.38, sw=pw-0.24, sh2=ph-0.66;
  s.addShape(pres.shapes.RECTANGLE, {
    x:sx, y:sy, w:sw, h:sh2,
    fill:{color:C.bgLight}, line:{color:C.bgLight}
  });
  // Notch
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x:px+(pw/2)-0.22, y:py+0.1, w:0.44, h:0.16,
    fill:{color:"334155"}, rectRadius:0.06, line:{color:"334155"}
  });
  return { sx, sy, sw, sh:sh2 };
}

// ═══════════════════════════════════════════════════════════
// SLIDE 1 — CAPA
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.dark };

  // Listras azuis decorativas
  s.addShape(pres.shapes.RECTANGLE, {x:0,y:0,w:0.08,h:5.625, fill:{color:C.primary}, line:{color:C.primary}});
  s.addShape(pres.shapes.RECTANGLE, {x:0.14,y:0,w:0.03,h:5.625, fill:{color:C.primaryDk}, line:{color:C.primaryDk}});

  // Texto
  s.addText("ULTRA", {
    x:0.55, y:0.75, w:5.5, h:1.05,
    fontSize:60, bold:true, color:C.surface, fontFace:"Calibri", margin:0, align:"left"
  });
  s.addText("DELIVERY", {
    x:0.55, y:1.72, w:5.8, h:1.05,
    fontSize:60, bold:true, color:C.primary, fontFace:"Calibri", margin:0, align:"left"
  });
  s.addText("Documentação do Projeto Flutter", {
    x:0.55, y:2.88, w:5.5, h:0.4,
    fontSize:15, color:"64748B", fontFace:"Calibri", align:"left", margin:0
  });

  // Linha divisória
  s.addShape(pres.shapes.RECTANGLE, {x:0.55,y:3.38,w:2.2,h:0.04, fill:{color:C.primary}, line:{color:C.primary}});

  // Pills de tecnologia
  ["Flutter","Firebase","GPS","Material 3"].forEach((t,i) => {
    const x = 0.55 + i*1.32;
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, {
      x, y:3.58, w:1.22, h:0.32,
      fill:{color:"1A2744"}, rectRadius:0.08, line:{color:"2D3F66"}
    });
    s.addText(t, {x, y:3.58, w:1.22, h:0.32,
      fontSize:10, color:"94A3B8", fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
  });

  s.addText("Desenvolvimento Mobile  ·  2026", {
    x:0.55, y:5.15, w:5, h:0.28,
    fontSize:10, color:"334155", fontFace:"Calibri", align:"left", margin:0
  });

  // ── Mockup direita ───────────────────────────────────────
  const {sx,sy,sw} = phone(s, 7.0, 0.55);
  // AppBar
  s.addShape(pres.shapes.RECTANGLE, {x:sx,y:sy,w:sw,h:0.48, fill:{color:C.primary}, line:{color:C.primary}});
  s.addText("📦  Ultra Delivery", {x:sx,y:sy,w:sw,h:0.48,
    fontSize:8, bold:true, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });
  // Summary card
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.05,y:sy+0.56,w:sw-0.1,h:0.45,
    fill:{color:C.primary}, line:{color:C.primary}, shadow:shS()
  });
  ["12","8","4"].forEach((n,i) => {
    s.addText(n, {x:sx+0.05+i*0.56,y:sy+0.56,w:0.56,h:0.45,
      fontSize:11, bold:true, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
  });
  // Cards
  [C.primary, C.green, C.orange, C.muted].forEach((cor,i) => {
    s.addShape(pres.shapes.RECTANGLE, {x:sx+0.05,y:sy+1.1+i*0.45,w:sw-0.1,h:0.38,
      fill:{color:C.surface}, line:{color:C.divLt}, shadow:shS()
    });
    s.addShape(pres.shapes.RECTANGLE, {x:sx+0.05,y:sy+1.1+i*0.45,w:0.05,h:0.38,
      fill:{color:cor}, line:{color:cor}
    });
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 2 — TECNOLOGIAS
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.surface };
  topBar(s, C.primary);
  sectionTitle(s, "Sobre o Projeto", "Stack de Tecnologias");

  const techs = [
    { name:"Flutter",    sub:"Desenvolvimento UI",      cor:C.primary, icon:"🎯", desc:"Framework Google para criar apps nativos Android a partir de código Dart." },
    { name:"Firebase",   sub:"Realtime Database",       cor:C.fire,    icon:"🔥", desc:"Banco de dados NoSQL em tempo real. Sincroniza entregas instantaneamente." },
    { name:"Geolocator", sub:"GPS & Localização",       cor:C.green,   icon:"📍", desc:"Captura latitude e longitude do dispositivo para registrar a localização." },
    { name:"Material 3", sub:"Design System Google",    cor:C.purple,  icon:"🎨", desc:"Componentes visuais modernos com Plus Jakarta Sans e nova paleta de cores." },
  ];

  techs.forEach((t,i) => {
    const x = 0.4 + i*2.38;
    // Card
    s.addShape(pres.shapes.RECTANGLE, {x,y:1.4,w:2.15,h:3.7,
      fill:{color:C.surface}, line:{color:C.divider}, shadow:shS()
    });
    // Topo colorido
    s.addShape(pres.shapes.RECTANGLE, {x,y:1.4,w:2.15,h:0.07, fill:{color:t.cor}, line:{color:t.cor}});
    // Círculo ícone
    s.addShape(pres.shapes.OVAL, {x:x+0.57,y:1.6,w:1.0,h:1.0,
      fill:{color:t.cor, transparency:88}, line:{color:t.cor, transparency:65}
    });
    s.addText(t.icon, {x:x+0.57,y:1.6,w:1.0,h:1.0,
      fontSize:28, align:"center", valign:"middle", margin:0
    });
    // Nome
    s.addText(t.name, {x,y:2.72,w:2.15,h:0.4,
      fontSize:16, bold:true, color:C.dark, fontFace:"Calibri", align:"center", margin:0
    });
    // Sub
    s.addText(t.sub, {x,y:3.08,w:2.15,h:0.28,
      fontSize:11, color:t.cor, fontFace:"Calibri", align:"center", margin:0
    });
    // Desc
    s.addText(t.desc, {x:x+0.12,y:3.42,w:1.9,h:1.35,
      fontSize:10, color:C.muted, fontFace:"Calibri", align:"center", wrap:true, margin:0
    });
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 3 — DESIGN SYSTEM
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.surface };
  topBar(s, C.primary);
  sectionTitle(s, "Design System", "Cores & Tipografia");

  // ── CORES (esquerda) ─────────────────────────────────────
  s.addText("PALETA DE CORES", {x:0.5,y:1.35,w:4.5,h:0.28,
    fontSize:9, bold:true, color:C.primary, charSpacing:2, fontFace:"Calibri", margin:0
  });

  const cores = [
    { label:"Primary",      hex:"#2563EB", cor:C.primary },
    { label:"Primary Dark", hex:"#1D4ED8", cor:C.primaryDk },
    { label:"Background",   hex:"#F4F6FA", cor:"F4F6FA" },
    { label:"Surface",      hex:"#FFFFFF", cor:C.surface },
    { label:"Text Primary", hex:"#0F172A", cor:C.dark },
    { label:"Text Muted",   hex:"#64748B", cor:C.muted },
    { label:"Status ✓",     hex:"#16A34A", cor:C.green },
    { label:"Status ⚡",    hex:"#F97316", cor:C.orange },
    { label:"Error",        hex:"#EF4444", cor:C.red },
  ];

  cores.forEach((c,i) => {
    const row = Math.floor(i/3), col = i%3;
    const x = 0.5 + col*1.55, y = 1.72 + row*1.05;
    // Swatch
    s.addShape(pres.shapes.RECTANGLE, {x,y,w:1.4,h:0.55,
      fill:{color:c.cor}, line:{color:C.divider}, shadow:shS()
    });
    if(c.cor === C.surface) {
      s.addShape(pres.shapes.RECTANGLE, {x,y,w:1.4,h:0.55,
        fill:{color:C.surface}, line:{color:C.divider}
      });
    }
    // Nome
    s.addText(c.label, {x,y:y+0.57,w:1.4,h:0.25,
      fontSize:9, bold:true, color:C.dark, fontFace:"Calibri", align:"center", margin:0
    });
    // Hex
    s.addText(c.hex, {x,y:y+0.79,w:1.4,h:0.2,
      fontSize:8, color:C.muted, fontFace:"Calibri", align:"center", margin:0
    });
  });

  // Divisor vertical
  s.addShape(pres.shapes.RECTANGLE, {x:5.2,y:1.25,w:0.015,h:4.0,
    fill:{color:C.divider}, line:{color:C.divider}
  });

  // ── TIPOGRAFIA (direita) ─────────────────────────────────
  s.addText("TIPOGRAFIA", {x:5.5,y:1.35,w:4.2,h:0.28,
    fontSize:9, bold:true, color:C.primary, charSpacing:2, fontFace:"Calibri", margin:0
  });
  s.addText("Plus Jakarta Sans", {x:5.5,y:1.7,w:4.2,h:0.4,
    fontSize:18, bold:true, color:C.dark, fontFace:"Calibri", margin:0
  });
  s.addText("via google_fonts package", {x:5.5,y:2.07,w:4.2,h:0.28,
    fontSize:11, color:C.muted, fontFace:"Calibri", margin:0
  });

  // Escala tipográfica
  const tipos = [
    { ex:"Headline Large",  sz:18, w:800, note:"22sp / w800" },
    { ex:"Headline Medium", sz:15, w:700, note:"17sp / w700" },
    { ex:"Body Medium",     sz:12, w:500, note:"13sp / w500" },
    { ex:"Label Small",     sz:10, w:700, note:"10sp / w700" },
    { ex:"Caption",         sz:9,  w:600, note:"10sp / w600" },
  ];
  tipos.forEach((t,i) => {
    const y = 2.48 + i*0.55;
    s.addText(t.ex, {x:5.5,y,w:2.8,h:0.4,
      fontSize:t.sz, bold:t.w>=700, color:C.dark, fontFace:"Calibri", margin:0, valign:"middle"
    });
    s.addShape(pres.shapes.RECTANGLE, {x:8.45,y:y+0.05,w:1.0,h:0.28,
      fill:{color:C.primaryBg}, line:{color:C.divider}
    });
    s.addText(t.note, {x:8.45,y:y+0.05,w:1.0,h:0.28,
      fontSize:8, color:C.primary, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 4 — TELA LOGIN
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.bgLight };
  topBar(s, C.primary);
  sectionTitle(s, "Tela 1 de 3", "Login");

  // ── Mockup (esquerda) ─────────────────────────────────────
  const {sx,sy,sw,sh:sh2} = phone(s, 0.55, 0.55);

  // Fundo branco
  s.addShape(pres.shapes.RECTANGLE, {x:sx,y:sy,w:sw,h:sh2,
    fill:{color:C.surface}, line:{color:C.surface}
  });

  // Logo
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.12,y:sy+0.25,w:sw-0.24,h:0.45,
    fill:{color:C.primaryBg}, line:{color:C.divider}
  });
  s.addText("ultra delivery", {x:sx+0.12,y:sy+0.25,w:sw-0.24,h:0.45,
    fontSize:10, bold:true, color:C.primary, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });

  // Campo e-mail
  [["✉ E-mail", sy+0.85], ["🔒 Senha", sy+1.25]].forEach(([lbl,y]) => {
    s.addShape(pres.shapes.RECTANGLE, {x:sx+0.08,y,w:sw-0.16,h:0.32,
      fill:{color:C.surface}, line:{color:C.divider}
    });
    s.addText(lbl, {x:sx+0.1,y,w:sw-0.2,h:0.32,
      fontSize:8, color:C.disabled, fontFace:"Calibri", valign:"middle", margin:0
    });
  });

  // Botão Entrar
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.08,y:sy+1.72,w:sw-0.16,h:0.34,
    fill:{color:C.primary}, line:{color:C.primary}
  });
  s.addText("Entrar →", {x:sx+0.08,y:sy+1.72,w:sw-0.16,h:0.34,
    fontSize:9, bold:true, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });

  // Divisor "ou"
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.08,y:sy+2.18,w:0.5,h:0.015, fill:{color:C.divider}, line:{color:C.divider}});
  s.addText("ou", {x:sx+0.57,y:sy+2.1,w:0.35,h:0.2, fontSize:7, color:C.disabled, fontFace:"Calibri", align:"center", margin:0});
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.91,y:sy+2.18,w:0.5,h:0.015, fill:{color:C.divider}, line:{color:C.divider}});

  // Botão Google
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.08,y:sy+2.3,w:sw-0.16,h:0.32,
    fill:{color:C.bgLight}, line:{color:C.divider}
  });
  s.addText("G  Continuar com Google", {x:sx+0.08,y:sy+2.3,w:sw-0.16,h:0.32,
    fontSize:7, color:C.muted, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });

  // ── Features (direita) ───────────────────────────────────
  s.addText("Funcionalidades", {x:3.1,y:1.3,w:6.5,h:0.4,
    fontSize:18, bold:true, color:C.dark, fontFace:"Calibri", margin:0
  });

  const feats = [
    { icon:"✉", cor:C.primary, title:"Autenticação por e-mail",   desc:"Validação de credenciais com e-mail e senha." },
    { icon:"👁", cor:C.purple,  title:"Toggle de visibilidade",    desc:"Botão para mostrar/ocultar a senha digitada." },
    { icon:"🔑", cor:C.green,   title:"Usuário cadastrado",        desc:'Login: vitorio@vitorio · Senha: vitorio' },
    { icon:"🌐", cor:C.fire,    title:"Botão \"Continuar com Google\"",   desc:"Pronto para integração com Firebase Auth." },
    { icon:"⚠", cor:C.red,     title:"Mensagem de erro inline",   desc:"Banner vermelho ao errar e-mail ou senha." },
  ];

  feats.forEach((f,i) => {
    const y = 1.85 + i*0.7;
    // Círculo ícone
    s.addShape(pres.shapes.OVAL, {x:3.1,y:y+0.02,w:0.44,h:0.44,
      fill:{color:f.cor, transparency:88}, line:{color:f.cor, transparency:70}
    });
    s.addText(f.icon, {x:3.1,y:y+0.02,w:0.44,h:0.44,
      fontSize:14, align:"center", valign:"middle", margin:0
    });
    // Título
    s.addText(f.title, {x:3.68,y,w:5.8,h:0.28,
      fontSize:13, bold:true, color:C.dark, fontFace:"Calibri", margin:0
    });
    // Desc
    s.addText(f.desc, {x:3.68,y:y+0.28,w:5.8,h:0.28,
      fontSize:11, color:C.muted, fontFace:"Calibri", margin:0
    });
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 5 — LISTA DE ENTREGAS
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.bgLight };
  topBar(s, C.primary);
  sectionTitle(s, "Tela 2 de 3", "Lista de Entregas");

  const {sx,sy,sw,sh:sh2} = phone(s, 0.55, 0.55);

  // Header
  s.addShape(pres.shapes.RECTANGLE, {x:sx,y:sy,w:sw,h:0.45,
    fill:{color:C.surface}, line:{color:C.divLt}
  });
  s.addText("📦 Ultra Delivery", {x:sx,y:sy,w:sw*0.7,h:0.45,
    fontSize:7, bold:true, color:C.dark, fontFace:"Calibri", valign:"middle", margin:4
  });
  // Avatar
  s.addShape(pres.shapes.OVAL, {x:sx+sw-0.36,y:sy+0.06,w:0.28,h:0.28,
    fill:{color:C.primaryBg}, line:{color:C.divider}
  });

  // SummaryBar
  [C.primary, C.green, C.orange, C.muted].forEach((cor,i) => {
    const bx = sx + i*0.45;
    s.addShape(pres.shapes.RECTANGLE, {x:bx,y:sy+0.5,w:0.42,h:0.52,
      fill:{color:C.surface}, line:{color:C.divLt}
    });
    s.addShape(pres.shapes.OVAL, {x:bx+0.14,y:sy+0.55,w:0.14,h:0.14,
      fill:{color:cor, transparency:88}, line:{color:cor, transparency:70}
    });
    s.addText(["12","8","3","4"][i], {x:bx,y:sy+0.68,w:0.42,h:0.2,
      fontSize:9, bold:true, color:C.dark, fontFace:"Calibri", align:"center", margin:0
    });
  });

  // Header lista
  s.addText("Entregas recentes", {x:sx,y:sy+1.1,w:sw*0.7,h:0.2,
    fontSize:7, bold:true, color:C.muted, fontFace:"Calibri", margin:2
  });

  // Cards
  [
    { cod:"#ENT-001", status:"Em transporte", cor:C.primary  },
    { cod:"#ENT-002", status:"Entregue",      cor:C.green    },
    { cod:"#ENT-003", status:"Pendente",      cor:C.muted    },
  ].forEach((item,i) => {
    const cy = sy+1.35+i*0.62;
    s.addShape(pres.shapes.RECTANGLE, {x:sx,y:cy,w:sw,h:0.56,
      fill:{color:C.surface}, line:{color:C.divLt}
    });
    s.addShape(pres.shapes.RECTANGLE, {x:sx,y:cy,w:0.05,h:0.56,
      fill:{color:item.cor}, line:{color:item.cor}
    });
    // Ícone status
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, {x:sx+0.1,y:cy+0.08,w:0.38,h:0.38,
      fill:{color:item.cor, transparency:92}, rectRadius:0.06, line:{color:item.cor, transparency:80}
    });
    s.addText(["🚚","✓","⏳"][i], {x:sx+0.1,y:cy+0.08,w:0.38,h:0.38,
      fontSize:10, align:"center", valign:"middle", margin:0
    });
    // Código
    s.addText(item.cod, {x:sx+0.55,y:cy+0.05,w:0.9,h:0.22,
      fontSize:8, bold:true, color:C.dark, fontFace:"Calibri", margin:0
    });
    // Badge
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, {x:sx+0.55,y:cy+0.28,w:0.82,h:0.18,
      fill:{color:item.cor, transparency:92}, rectRadius:0.05, line:{color:item.cor, transparency:80}
    });
    s.addText(item.status, {x:sx+0.55,y:cy+0.28,w:0.82,h:0.18,
      fontSize:5.5, bold:true, color:item.cor, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
    // Chevron
    s.addText("›", {x:sx+sw-0.22,y:cy+0.14,w:0.18,h:0.28,
      fontSize:14, color:C.disabled, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
  });

  // FAB
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, {x:sx+sw-0.8,y:sy+sh2-0.44,w:0.75,h:0.32,
    fill:{color:C.primary}, rectRadius:0.12, line:{color:C.primary}, shadow:shS()
  });
  s.addText("+ Nova", {x:sx+sw-0.8,y:sy+sh2-0.44,w:0.75,h:0.32,
    fontSize:7, bold:true, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });

  // ── Features ─────────────────────────────────────────────
  s.addText("Funcionalidades", {x:3.1,y:1.3,w:6.5,h:0.4,
    fontSize:18, bold:true, color:C.dark, fontFace:"Calibri", margin:0
  });

  const feats = [
    { icon:"📊", cor:C.primary, title:"SummaryBar — 4 métricas",     desc:"Total, Entregues, Em trânsito e Pendentes em cards." },
    { icon:"🃏", cor:C.green,   title:"Cards expansíveis",           desc:"Tap no card abre detalhes com AnimatedCrossFade." },
    { icon:"🔴", cor:C.orange,  title:"Status por cor",              desc:"Barra lateral e badge coloridos por status." },
    { icon:"👤", cor:C.purple,  title:"UserMenu dropdown",           desc:"Exibe nome, e-mail e opção de sair." },
    { icon:"⚡", cor:C.fire,    title:"Sincronização em tempo real", desc:"StreamBuilder escuta o Firebase Realtime DB." },
  ];

  feats.forEach((f,i) => {
    const y = 1.85 + i*0.7;
    s.addShape(pres.shapes.OVAL, {x:3.1,y:y+0.02,w:0.44,h:0.44,
      fill:{color:f.cor, transparency:88}, line:{color:f.cor, transparency:70}
    });
    s.addText(f.icon, {x:3.1,y:y+0.02,w:0.44,h:0.44,
      fontSize:14, align:"center", valign:"middle", margin:0
    });
    s.addText(f.title, {x:3.68,y,w:5.9,h:0.28,
      fontSize:13, bold:true, color:C.dark, fontFace:"Calibri", margin:0
    });
    s.addText(f.desc, {x:3.68,y:y+0.28,w:5.9,h:0.28,
      fontSize:11, color:C.muted, fontFace:"Calibri", margin:0
    });
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 6 — TELA CADASTRO
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.bgLight };
  topBar(s, C.primary);
  sectionTitle(s, "Tela 3 de 3", "Cadastro / Edição de Entrega");

  const {sx,sy,sw,sh:sh2} = phone(s, 0.55, 0.55);

  // Header azul
  s.addShape(pres.shapes.RECTANGLE, {x:sx,y:sy,w:sw,h:0.48,
    fill:{color:C.primary}, line:{color:C.primary}
  });
  // Botão voltar circular
  s.addShape(pres.shapes.OVAL, {x:sx+0.08,y:sy+0.1,w:0.28,h:0.28,
    fill:{color:"FFFFFF", transparency:85}, line:{color:"FFFFFF", transparency:70}
  });
  s.addText("←", {x:sx+0.08,y:sy+0.1,w:0.28,h:0.28,
    fontSize:10, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });
  s.addText("Nova Entrega", {x:sx,y:sy+0.05,w:sw,h:0.38,
    fontSize:8, bold:true, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });

  // Section: Dados
  s.addText("DADOS DA ENTREGA", {x:sx+0.08,y:sy+0.58,w:sw-0.16,h:0.2,
    fontSize:6.5, bold:true, color:C.primary, charSpacing:1, fontFace:"Calibri", margin:0
  });

  // Campos
  [["✦ Código","QR"],["✦ Destinatário",""],["✦ Endereço",""],["✦ Status ▾",""]].forEach(([lbl],i) => {
    const fy = sy+0.83+i*0.4;
    s.addShape(pres.shapes.RECTANGLE, {x:sx+0.08,y:fy,w:sw-0.16,h:0.32,
      fill:{color:C.surface}, line:{color:C.divider}
    });
    s.addText(lbl, {x:sx+0.1,y:fy,w:sw-0.2,h:0.32,
      fontSize:7.5, color:C.disabled, fontFace:"Calibri", valign:"middle", margin:0
    });
  });

  // Section: Localização
  s.addText("LOCALIZAÇÃO", {x:sx+0.08,y:sy+2.48,w:sw-0.16,h:0.2,
    fontSize:6.5, bold:true, color:C.primary, charSpacing:1, fontFace:"Calibri", margin:0
  });

  // GPS Card
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.08,y:sy+2.73,w:sw-0.16,h:0.58,
    fill:{color:C.primaryBg}, line:{color:C.divider}
  });
  s.addText("📡 GPS capturado", {x:sx+0.1,y:sy+2.77,w:sw*0.6,h:0.2,
    fontSize:7, bold:true, color:C.primary, fontFace:"Calibri", margin:0
  });
  // Grid de coordenadas
  [["LAT", "-23.550505"], ["LON", "-46.633309"]].forEach(([lbl,val],i) => {
    const bx = sx+0.1+i*0.85;
    s.addShape(pres.shapes.RECTANGLE, {x:bx,y:sy+3.03,w:0.78,h:0.22,
      fill:{color:C.surface}, line:{color:C.divider}
    });
    s.addText(`${lbl}: ${val}`, {x:bx,y:sy+3.03,w:0.78,h:0.22,
      fontSize:5.5, color:C.dark, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
  });

  // Botão salvar (fixo na base)
  s.addShape(pres.shapes.RECTANGLE, {x:sx,y:sy+sh2-0.44,w:sw,h:0.44,
    fill:{color:C.bgLight}, line:{color:C.bgLight}
  });
  s.addShape(pres.shapes.RECTANGLE, {x:sx+0.08,y:sy+sh2-0.4,w:sw-0.16,h:0.32,
    fill:{color:C.primary}, line:{color:C.primary}
  });
  s.addText("💾 Cadastrar Entrega", {x:sx+0.08,y:sy+sh2-0.4,w:sw-0.16,h:0.32,
    fontSize:7, bold:true, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
  });

  // ── Features ─────────────────────────────────────────────
  s.addText("Funcionalidades", {x:3.1,y:1.3,w:6.5,h:0.4,
    fontSize:18, bold:true, color:C.dark, fontFace:"Calibri", margin:0
  });

  const feats = [
    { icon:"📝", cor:C.primary, title:"Formulário validado",        desc:"Todos os campos obrigatórios com validação inline." },
    { icon:"🚦", cor:C.orange,  title:"Dropdown de status customizado", desc:"Dot colorido + nome do status em cada opção." },
    { icon:"📍", cor:C.green,   title:"GPS automático",             desc:"Captura localização ao abrir a tela de criação." },
    { icon:"✏️", cor:C.purple,  title:"Modo edição",                desc:"Recebe Entrega como parâmetro e pré-preenche." },
    { icon:"⬇️", cor:C.dark,    title:"Botão salvar fixo na base",  desc:"Fora do scroll, sempre acessível com sombra." },
  ];

  feats.forEach((f,i) => {
    const y = 1.85 + i*0.7;
    s.addShape(pres.shapes.OVAL, {x:3.1,y:y+0.02,w:0.44,h:0.44,
      fill:{color:f.cor, transparency:88}, line:{color:f.cor, transparency:70}
    });
    s.addText(f.icon, {x:3.1,y:y+0.02,w:0.44,h:0.44,
      fontSize:14, align:"center", valign:"middle", margin:0
    });
    s.addText(f.title, {x:3.68,y,w:5.9,h:0.28,
      fontSize:13, bold:true, color:C.dark, fontFace:"Calibri", margin:0
    });
    s.addText(f.desc, {x:3.68,y:y+0.28,w:5.9,h:0.28,
      fontSize:11, color:C.muted, fontFace:"Calibri", margin:0
    });
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 7 — FIREBASE
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.surface };
  topBar(s, C.fire);
  sectionTitle(s, "Backend", "Firebase Realtime Database");

  // ── Nó JSON ──────────────────────────────────────────────
  card(s, 0.5, 1.35, 4.5, 3.85);
  s.addShape(pres.shapes.RECTANGLE, {x:0.5,y:1.35,w:4.5,h:0.42,
    fill:{color:C.medium}, line:{color:C.medium}
  });
  s.addText("🔥  entregas-unifenas-default-rtdb", {x:0.5,y:1.35,w:4.5,h:0.42,
    fontSize:9, color:C.surface, fontFace:"Calibri", valign:"middle", margin:8
  });

  const linhas = [
    { ind:0, txt:'entregas/', col:C.orange    },
    { ind:1, txt:'-OKx8a3… /', col:C.primaryLt },
    { ind:2, txt:'codigo: "ENT-001"',  col:C.green  },
    { ind:2, txt:'destinatario: "João Silva"', col:C.green },
    { ind:2, txt:'endereco: "Rua das Flores, 123"', col:C.green },
    { ind:2, txt:'status: "Em transporte"', col:C.orange },
    { ind:2, txt:'latitude: -23.550505', col:C.muted },
    { ind:2, txt:'longitude: -46.633309', col:C.muted },
    { ind:2, txt:'dataHoraAtualizacao: "03/06/2026"', col:C.muted },
  ];
  linhas.forEach((l,i) => {
    s.addText(l.txt, {x:0.65+l.ind*0.28, y:1.87+i*0.32, w:4.2, h:0.28,
      fontSize:9.5, color:l.col, fontFace:"Consolas", margin:0
    });
  });

  // ── Operações CRUD ────────────────────────────────────────
  s.addText("Operações CRUD", {x:5.35,y:1.3,w:4.2,h:0.38,
    fontSize:17, bold:true, color:C.dark, fontFace:"Calibri", margin:0
  });

  const ops = [
    { op:"CREATE", method:"push().set()",     cor:C.green,   desc:"Nova entrega com chave auto-gerada" },
    { op:"READ",   method:"onValue (stream)", cor:C.primary, desc:"Stream em tempo real para a lista" },
    { op:"UPDATE", method:"update()",         cor:C.orange,  desc:"Edição de campos por firebaseKey" },
    { op:"DELETE", method:"remove()",         cor:C.red,     desc:"Exclusão pelo firebaseKey" },
  ];

  ops.forEach((o,i) => {
    const y = 1.82 + i*0.88;
    // Card
    s.addShape(pres.shapes.RECTANGLE, {x:5.35,y,w:4.2,h:0.72,
      fill:{color:C.surface}, line:{color:C.divider}, shadow:shS()
    });
    s.addShape(pres.shapes.RECTANGLE, {x:5.35,y,w:0.06,h:0.72,
      fill:{color:o.cor}, line:{color:o.cor}
    });
    // Badge
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, {x:5.5,y:y+0.12,w:0.7,h:0.24,
      fill:{color:o.cor, transparency:88}, rectRadius:0.06, line:{color:o.cor, transparency:70}
    });
    s.addText(o.op, {x:5.5,y:y+0.12,w:0.7,h:0.24,
      fontSize:8, bold:true, color:o.cor, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
    // Método
    s.addText(o.method, {x:6.3,y:y+0.1,w:3.1,h:0.28,
      fontSize:11, bold:true, color:C.dark, fontFace:"Consolas", margin:0
    });
    // Desc
    s.addText(o.desc, {x:6.3,y:y+0.38,w:3.1,h:0.24,
      fontSize:10, color:C.muted, fontFace:"Calibri", margin:0
    });
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 8 — AUTENTICAÇÃO & NAVEGAÇÃO
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.surface };
  topBar(s, C.primary);
  sectionTitle(s, "Autenticação", "Login & Fluxo de Navegação");

  // ── Fluxo de navegação ────────────────────────────────────
  const telas = [
    { nome:"LoginScreen",    cor:C.primary, y:2.1 },
    { nome:"ListaEntregas\nScreen",  cor:C.green,   y:2.1 },
    { nome:"Cadastro\nEntregaScreen", cor:C.orange, y:2.1 },
  ];

  telas.forEach((t,i) => {
    const x = 1.2 + i*3.0;
    // Tela card
    s.addShape(pres.shapes.RECTANGLE, {x,y:t.y,w:2.2,h:1.2,
      fill:{color:C.surface}, line:{color:t.cor}, shadow:shS()
    });
    s.addShape(pres.shapes.RECTANGLE, {x,y:t.y,w:2.2,h:0.38,
      fill:{color:t.cor}, line:{color:t.cor}
    });
    s.addText(t.nome, {x,y:t.y,w:2.2,h:0.38,
      fontSize:9, bold:true, color:C.surface, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
    s.addText("Tela "+(i+1), {x,y:t.y+0.45,w:2.2,h:0.65,
      fontSize:24, bold:true, color:t.cor, fontFace:"Calibri", align:"center", valign:"middle", margin:0
    });
    // Setas
    if(i<2) {
      s.addShape(pres.shapes.RECTANGLE, {x:x+2.2,y:t.y+0.55,w:0.6,h:0.04,
        fill:{color:C.divider}, line:{color:C.divider}
      });
      s.addText("→", {x:x+2.2,y:t.y+0.4,w:0.6,h:0.35,
        fontSize:16, color:C.disabled, fontFace:"Calibri", align:"center", valign:"middle", margin:0
      });
    }
  });

  // Seta "Sair" Tela 2 → Tela 1
  s.addShape(pres.shapes.RECTANGLE, {x:2.3,y:3.5,w:0.04,h:0.6,
    fill:{color:C.red, transparency:40}, line:{color:C.red, transparency:40}
  });
  s.addShape(pres.shapes.RECTANGLE, {x:1.5,y:4.1,w:0.84,h:0.04,
    fill:{color:C.red, transparency:40}, line:{color:C.red, transparency:40}
  });
  s.addText("Sair", {x:1.5,y:4.15,w:0.84,h:0.28,
    fontSize:9, color:C.red, fontFace:"Calibri", align:"center", margin:0
  });

  // ── Credenciais ───────────────────────────────────────────
  card(s, 0.5, 4.6, 9.0, 0.75);
  s.addText("👤  Usuário cadastrado:", {x:0.7,y:4.67,w:2.5,h:0.3,
    fontSize:12, bold:true, color:C.dark, fontFace:"Calibri", margin:0
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, {x:3.3,y:4.72,w:2.2,h:0.3,
    fill:{color:C.primaryBg}, rectRadius:0.06, line:{color:C.divider}
  });
  s.addText("vitorio@vitorio", {x:3.3,y:4.72,w:2.2,h:0.3,
    fontSize:11, color:C.primary, fontFace:"Consolas", align:"center", valign:"middle", margin:0
  });
  s.addText("senha:", {x:5.7,y:4.72,w:0.75,h:0.3,
    fontSize:11, color:C.muted, fontFace:"Calibri", valign:"middle", margin:0
  });
  s.addShape(pres.shapes.ROUNDED_RECTANGLE, {x:6.45,y:4.72,w:1.4,h:0.3,
    fill:{color:C.primaryBg}, rectRadius:0.06, line:{color:C.divider}
  });
  s.addText("vitorio", {x:6.45,y:4.72,w:1.4,h:0.3,
    fontSize:11, color:C.primary, fontFace:"Consolas", align:"center", valign:"middle", margin:0
  });
  s.addText("(hardcoded)", {x:8.05,y:4.72,w:1.2,h:0.3,
    fontSize:9, color:C.disabled, fontFace:"Calibri", valign:"middle", margin:0
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 9 — ARQUITETURA DO PROJETO
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.surface };
  topBar(s, C.primary);
  sectionTitle(s, "Estrutura", "Arquitetura do Projeto");

  const pastas = [
    { label:"lib/",          cor:C.primary, x:0.5,  y:1.38, w:9.0, h:0.34, indent:0 },
    { label:"main.dart — EntregasApp + AppTheme.light + LoginScreen como home",         cor:C.muted, x:1.0,y:1.82,w:8.5,h:0.28, indent:1 },
    { label:"theme/",        cor:C.purple,  x:1.0,  y:2.18, w:8.5, h:0.28, indent:1 },
    { label:"app_colors.dart · app_text_styles.dart · app_decorations.dart · app_icons.dart · app_theme.dart · theme.dart (barrel)", cor:C.muted, x:1.5,y:2.46,w:8.0,h:0.28, indent:2 },
    { label:"models/",       cor:C.green,   x:1.0,  y:2.82, w:8.5, h:0.28, indent:1 },
    { label:"entrega.dart — Classe Entrega + toJson / fromJson / fromMap / copyWith", cor:C.muted, x:1.5,y:3.1,w:8.0,h:0.28, indent:2 },
    { label:"screens/",      cor:C.orange,  x:1.0,  y:3.46, w:8.5, h:0.28, indent:1 },
    { label:"login_screen.dart · lista_entregas_screen.dart · cadastro_entrega_screen.dart", cor:C.muted, x:1.5,y:3.74,w:8.0,h:0.28, indent:2 },
    { label:"database/",     cor:C.fire,    x:1.0,  y:4.1,  w:8.5, h:0.28, indent:1 },
    { label:"firebase_service.dart (CRUD) · location_service.dart (GPS) · database_helper.dart", cor:C.muted, x:1.5,y:4.38,w:8.0,h:0.28, indent:2 },
  ];

  pastas.forEach(p => {
    if(p.indent === 0) {
      s.addShape(pres.shapes.RECTANGLE, {x:p.x,y:p.y,w:p.w,h:p.h,
        fill:{color:p.cor}, line:{color:p.cor}
      });
      s.addText(p.label, {x:p.x+0.12,y:p.y,w:p.w-0.15,h:p.h,
        fontSize:12, bold:true, color:C.surface, fontFace:"Calibri", valign:"middle", margin:0
      });
    } else if(p.indent === 1) {
      s.addShape(pres.shapes.RECTANGLE, {x:p.x,y:p.y,w:0.04,h:p.h,
        fill:{color:p.cor}, line:{color:p.cor}
      });
      s.addText(p.label, {x:p.x+0.12,y:p.y,w:p.w-0.15,h:p.h,
        fontSize:11, bold:true, color:p.cor, fontFace:"Calibri", valign:"middle", margin:0
      });
    } else {
      s.addText("• "+p.label, {x:p.x+0.12,y:p.y,w:p.w-0.15,h:p.h,
        fontSize:9.5, color:C.muted, fontFace:"Consolas", valign:"middle", margin:0
      });
    }
  });
}

// ═══════════════════════════════════════════════════════════
// SLIDE 10 — CONCLUSÃO
// ═══════════════════════════════════════════════════════════
{
  let s = pres.addSlide();
  s.background = { color: C.dark };

  s.addShape(pres.shapes.RECTANGLE, {x:0,y:0,w:0.08,h:5.625, fill:{color:C.primary}, line:{color:C.primary}});
  s.addShape(pres.shapes.RECTANGLE, {x:0.14,y:0,w:0.03,h:5.625, fill:{color:C.primaryDk}, line:{color:C.primaryDk}});

  s.addText("CONCLUSÃO", {x:0.55,y:0.55,w:5,h:0.3,
    fontSize:10, bold:true, color:C.primary, charSpacing:3, fontFace:"Calibri", margin:0
  });
  s.addText("O que foi construído", {x:0.55,y:0.88,w:9,h:0.7,
    fontSize:36, bold:true, color:C.surface, fontFace:"Calibri", margin:0
  });
  s.addShape(pres.shapes.RECTANGLE, {x:0.55,y:1.65,w:1.8,h:0.04, fill:{color:C.primary}, line:{color:C.primary}});

  const items = [
    { ico:"🔐", txt:"Login com validação de credenciais hardcoded e banner de erro inline" },
    { ico:"📋", txt:"Lista de entregas em tempo real (Firebase StreamBuilder) com cards expansíveis" },
    { ico:"📝", txt:"Formulário de cadastro/edição com GPS automático e dropdown customizado" },
    { ico:"🔥", txt:"Firebase Realtime Database (CRUD completo) — projeto entregas-unifenas" },
    { ico:"🎨", txt:"Design System completo: Plus Jakarta Sans, 30+ tokens de cor e tipografia" },
    { ico:"📐", txt:"Material 3 com AppTheme centralizado e todos os componentes estilizados" },
  ];

  items.forEach((item,i) => {
    const y = 1.88 + i*0.56;
    s.addText(item.ico, {x:0.55,y,w:0.45,h:0.45,
      fontSize:18, align:"center", valign:"middle", margin:0
    });
    s.addText(item.txt, {x:1.1,y:y+0.06,w:8.4,h:0.38,
      fontSize:12.5, color:"CBD5E1", fontFace:"Calibri", valign:"middle", margin:0
    });
  });

  // Rodapé
  s.addText("Ultra Delivery  ·  Flutter + Firebase  ·  2026", {
    x:0.55, y:5.2, w:9, h:0.25,
    fontSize:10, color:"334155", fontFace:"Calibri", align:"left", margin:0
  });
}

// ── Gerar arquivo ─────────────────────────────────────────
pres.writeFile({ fileName: "C:/Users/vit/Desktop/Ultra_Delivery_Slides.pptx" })
  .then(() => console.log("✅  Ultra_Delivery_Slides.pptx salvo na Área de Trabalho"))
  .catch(e => console.error("❌", e));
