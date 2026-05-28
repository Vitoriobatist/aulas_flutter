// lib/models/entrega.dart

class Entrega {
  int? id;
  String codigo;
  String destinatario;
  String endereco;
  String status;
  double latitude;
  double longitude;
  String dataHoraAtualizacao;

  // Status possíveis conforme a atividade
  static const List<String> statusOpcoes = [
    'Pendente',
    'Saiu para entrega',
    'Em transporte',
    'Entregue',
  ];

  Entrega({
    this.id,
    required this.codigo,
    required this.destinatario,
    required this.endereco,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.dataHoraAtualizacao,
  });

  // Converte objeto para Map (para salvar no SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'destinatario': destinatario,
      'endereco': endereco,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'dataHoraAtualizacao': dataHoraAtualizacao,
    };
  }

  // Cria objeto a partir de Map (ao ler do SQLite)
  factory Entrega.fromMap(Map<String, dynamic> map) {
    return Entrega(
      id: _toInt(map['id']),
      codigo: map['codigo']?.toString() ?? '',
      destinatario: map['destinatario']?.toString() ?? '',
      endereco: map['endereco']?.toString() ?? '',
      status: map['status']?.toString() ?? statusOpcoes.first,
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
      dataHoraAtualizacao: map['dataHoraAtualizacao']?.toString() ?? '',
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  // Cria cópia com campos atualizados
  Entrega copyWith({
    int? id,
    String? codigo,
    String? destinatario,
    String? endereco,
    String? status,
    double? latitude,
    double? longitude,
    String? dataHoraAtualizacao,
  }) {
    return Entrega(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      destinatario: destinatario ?? this.destinatario,
      endereco: endereco ?? this.endereco,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dataHoraAtualizacao: dataHoraAtualizacao ?? this.dataHoraAtualizacao,
    );
  }
}
