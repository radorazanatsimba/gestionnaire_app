import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  ///  Retourne une instance unique de la base de données (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_data.db');
    return _database!;
  }

  /// 🔧 Initialisation de la base de données
  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom_utilisateur TEXT UNIQUE NOT NULL,
        mail_utilisateur TEXT UNIQUE NOT NULL,
        mot_de_passe TEXT UNIQUE NOT NULL,
        code_gestionnaire TEXT UNIQUE NOT NULL,
        statut TEXT UNIQUE NOT NULL,
        date_creation DATE
      )
    ''');
  }

  /// 🧱 Mise à jour de la base en cas de nouvelle version
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Exemple : ajouter une colonne
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE utilisateurs ADD COLUMN age INTEGER');
    }
  }

  /// ➕ Insérer un enregistrement
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// 🔍 Récupérer tous les enregistrements
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  /// 🔎 Récupérer par id
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// ✏️ Mettre à jour un enregistrement
  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  /// ❌ Supprimer un enregistrement
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /// 🧹 Fermer la connexion
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
