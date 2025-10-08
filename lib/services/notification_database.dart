import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:intl/intl.dart';

import '../model/notification_model.dart';

class NotificationDatabase {
  static final NotificationDatabase _instance = NotificationDatabase._internal();
  static Database? _database;

  factory NotificationDatabase() => _instance;

  NotificationDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for desktop support
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      databaseFactory = databaseFactoryFfi;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'notifications.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        postKind TEXT,
        postCode TEXT,
        status TEXT,
        reason TEXT,
        date TEXT NOT NULL,
        isRead INTEGER NOT NULL DEFAULT 0,
        data TEXT
      )
    ''');
    
    // Insert default notifications if the table is empty
    await _insertDefaultNotifications(db);
  }

  Future<int> insertNotification(NotificationModel notification) async {
    final db = await database;
    return await db.insert('notifications', notification.toMap());
  }

  Future<List<NotificationModel>> getNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return NotificationModel.fromMap(maps[i]);
    });
  }

  Future<int> updateNotification(NotificationModel notification) async {
    final db = await database;
    return await db.update(
      'notifications',
      notification.toMap(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  Future<int> deleteNotification(int id) async {
    final db = await database;
    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  Future<void> markAllNotificationsAsRead() async {
    final db = await database;
    await db.rawUpdate('UPDATE notifications SET isRead = ?', [1]);
  }
  
  Future<void> _insertDefaultNotifications(Database db) async {
    // Check if notifications already exist
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM notifications')
    ) ?? 0;
    
    if (count == 0) {
      // Insert default notifications
      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      
      final defaultNotifications = [
        {
          'title': 'Qars Spin Update',
          'postKind': 'Car for Sale',
          'postCode': '6G4TNR',
          'status': 'Rejected',
          'reason': 'الرجاء إضافة صور حقيقية للسيارة\nإضافة 4 صور على الأقل\nنشر الاعلان ثم طلب تصوير 360',
          'date': formatter.format(now.subtract(Duration(days: 2))),
          'isRead': 0,
        },
        {
          'title': 'Qars Spin Update for Post 3H7PLQ',
          'postKind': 'Car for Rent',
          'postCode': '3H7PLQ',
          'status': 'Approved',
          'reason': 'تمت الموافقة على الإعلان',
          'date': formatter.format(now.subtract(Duration(days: 1))),
          'isRead': 0,
        },
      ];
      
      for (var notification in defaultNotifications) {
        await db.insert('notifications', notification);
      }
    }
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
