import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Este servicio se encarga de manejar las notificaciones locales en la aplicación.
// Proporciona métodos para inicializar el servicio, solicitar permisos y mostrar notificaciones.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings: initializationSettings);

    await _solicitarPermisoAndroid();
  }

  static Future<void> _solicitarPermisoAndroid() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> mostrarNotificacion({
    required String titulo,
    required String mensaje,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'inventario_facil',
      'Inventario Fácil',
      channelDescription:
          'Notificaciones de operaciones realizadas en Inventario Fácil',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const detalles = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _notifications.show(
      id: id,
      title: titulo,
      body: mensaje,
      notificationDetails: detalles,
    );
  }
}
