import 'package:basketball_statistics/app/database/script.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() {
  late Database db;
  late ImpDaoPlayer dao;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    deleteDatabase(inMemoryDatabasePath);
    db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) {
      createTables.forEach(db.execute);
    });
    dao = ImpDaoPlayer();
  });

  test('insert and get player by team', () async {
    var player = DTOPlayer(
        name: 'Player 1',
        position: 'Guard',
        rebounds: 2,
        assists: 5,
        tShirtNumber: 10,
        teamId: 1);
    await dao.insertPlayer(player);

    var players = await dao.getPlayersByTeam(1);

    expect(players.length, 6);
    expect(players.first.name, 'Player 1');
    expect(players.first.position, 'Guard');
  });

  tearDownAll(() async {
    await db.close();
  });
}
