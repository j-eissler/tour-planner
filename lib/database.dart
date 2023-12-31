import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tour_planner/waypoint_model.dart';

class TourPlannerDatabase {
  static final TourPlannerDatabase _instance = TourPlannerDatabase._();

  factory TourPlannerDatabase() {
    return _instance;
  }

  /// This named constructor  will be called exactly once by the static assignment above.
  TourPlannerDatabase._() {
    // Do initialization here
  }

  Future<Database> _getDb() async {
    String path = join(await getDatabasesPath(), 'tour_planner.db');
    final database = openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE waypoints(id INTEGER PRIMARY KEY, address TEXT, city TEXT, lat REAL, long REAL)');
      },
    );
    return database;
  }

  Future<int> addWaypoint(Waypoint waypoint) async {
    final database = await _getDb();

    final id = database.insert('waypoints', waypoint.toMap());
    return id;
  }

  Future<List<Waypoint>> getAllWaypoints() async {
    final db = await _getDb();
    var results = await db.query('waypoints');

    if (results.isNotEmpty) {
      return List.generate(results.length, (i) {
        return Waypoint(
          id: results[i]['id'] as int,
          address: results[i]['address'] as String,
          city: results[i]['city'] as String,
          lat: results[i]['lat'] as double?,
          long: results[i]['long'] as double?,
        );
      });
    }

    return [];
  }

  Future<Waypoint> getWaypoint(int id) async {
    final db = await _getDb();
    var result = await db.query('waypoints', where: 'id = ?', whereArgs: [id]);
    return Waypoint(
      id: result[0]['id'] as int,
      address: result[0]['address'] as String,
      city: result[0]['city'] as String,
      lat: result[0]['lat'] as double?,
      long: result[0]['long'] as double?,
    );
  }

  Future<int> deleteWaypoint(int? id) async {
    if(id == null) return 0;

    final db = await _getDb();

    return db.delete('waypoints', where: 'id = ?', whereArgs: [id]);
  }
}
