// lib/database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_initializer.dart';
import '../models/entrega.dart';

class DatabaseHelper {
  // Singleton: garante que só existe uma instância do banco
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Constantes do banco
  static const String _dbName = 'entregas.db';
  static const int _dbVersion = 2;
  static const String _tabela = 'entregas';

  // Retorna o banco (cria se ainda não existe)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Cria a tabela na primeira execução
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tabela (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo           TEXT    NOT NULL,
        destinatario     TEXT    NOT NULL,
        endereco         TEXT    NOT NULL,
        status           TEXT    NOT NULL,
        latitude         REAL    NOT NULL,
        longitude        REAL    NOT NULL,
        dataHoraAtualizacao TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final colunas = await db.rawQuery('PRAGMA table_info($_tabela)');
    final nomesColunas = colunas.map((coluna) => coluna['name']).toSet();

    if (!nomesColunas.contains('latitude')) {
      await db.execute(
          'ALTER TABLE $_tabela ADD COLUMN latitude REAL NOT NULL DEFAULT 0');
    }
    if (!nomesColunas.contains('longitude')) {
      await db.execute(
          'ALTER TABLE $_tabela ADD COLUMN longitude REAL NOT NULL DEFAULT 0');
    }
    if (!nomesColunas.contains('dataHoraAtualizacao')) {
      await db.execute(
        "ALTER TABLE $_tabela ADD COLUMN dataHoraAtualizacao TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  // ─── CRUD ───────────────────────────────────────────────

  /// INSERT — insere nova entrega
  Future<int> inserirEntrega(Entrega entrega) async {
    final db = await database;
    return await db.insert(
      _tabela,
      entrega.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// SELECT ALL — lista todas as entregas (mais recentes primeiro)
  Future<List<Entrega>> listarEntregas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      orderBy: 'id DESC',
    );
    return maps.map((map) => Entrega.fromMap(map)).toList();
  }

  /// SELECT BY ID — busca uma entrega pelo id
  Future<Entrega?> buscarEntrega(int id) async {
    final db = await database;
    final maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Entrega.fromMap(maps.first);
  }

  /// UPDATE — atualiza entrega existente
  Future<int> atualizarEntrega(Entrega entrega) async {
    final db = await database;
    return await db.update(
      _tabela,
      entrega.toMap(),
      where: 'id = ?',
      whereArgs: [entrega.id],
    );
  }

  /// DELETE — remove entrega
  Future<int> deletarEntrega(int id) async {
    final db = await database;
    return await db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Fecha o banco (boas práticas)
  Future<void> fecharBanco() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
