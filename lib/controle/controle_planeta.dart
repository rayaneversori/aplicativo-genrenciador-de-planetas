import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelo/planeta.dart';

class ControlePlaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(
      caminho,
      version: 2,
      onCreate: (db, version) async {
        await _criarBD(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE historico_planetas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              tamanho REAL,
              distancia REAL,
              apelido TEXT
            );
          ''');
        }
      },
    );
  }

  Future<void> _criarBD(Database bd) async {
    await bd.execute('''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL NOT NULL,
        distancia REAL NOT NULL,
        apelido TEXT
      );
    ''');

    await bd.execute('''
      CREATE TABLE historico_planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL,
        distancia REAL,
        apelido TEXT
      );
    ''');
  }

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert(
      'planetas',
      planeta.toMap(),
    );
  }

  Future<int> salvarNoHistorico(Planeta planeta) async {
    final db = await bd;
    return await db.insert(
      'historico_planetas',
      planeta.toMap(),
    );
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  Future<List<Planeta>> lerHistorico() async {
    final db = await bd;
    final resultado = await db.query('historico_planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    
    final planeta = (await db.query('planetas', where: 'id = ?', whereArgs: [id]))
        .map((item) => Planeta.fromMap(item))
        .firstOrNull;

    if (planeta != null) {
      await salvarNoHistorico(planeta);
    }

    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}