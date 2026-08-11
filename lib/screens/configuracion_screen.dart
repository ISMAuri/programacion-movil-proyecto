import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'formulario_datos_fiscales_screen.dart';
import 'formulario_usuario_screen.dart';
import 'formulario_empresa_screen.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        children: [
          Text(
            "Configuración",
            style: AppTextStyles.screenTitle.copyWith(color: AppColors.primary),
          ),

          const SizedBox(height: 24),

          Text("Cuenta", style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),

          _SettingsGroup(
            items: [
              _SettingsItemData(
                icon: Icons.person_outline,
                titulo: "Mi usuario",
                subtitulo: "Nombre, correo y contraseña",
                onTap: () => _irA(context, const FormularioUsuarioScreen()),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text("Negocio", style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),

          _SettingsGroup(
            items: [
              _SettingsItemData(
                icon: Icons.storefront_outlined,
                titulo: "Datos de la empresa",
                subtitulo: "Nombre, razón social, RTN, contacto y logo",
                onTap: () => _irA(context, const FormularioEmpresaScreen()),
              ),
              _SettingsItemData(
                icon: Icons.receipt_long_outlined,
                titulo: "Datos fiscales (CAI)",
                subtitulo: "Autorización, rango de facturación y vigencia",
                onTap: () =>
                    _irA(context, const FormularioDatosFiscalesScreen()),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text("Aplicación", style: AppTextStyles.sectionTitle),
          const SizedBox(height: 10),

          _SettingsGroup(
            items: [
              _SettingsItemData(
                icon: Icons.logout,
                titulo: "Cerrar sesión",
                subtitulo: null,
                colorIcono: AppColors.error,
                onTap: () {
                  // Cerrar sesión del usuario actual
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _irA(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

// ---------------------------------------------------------------------------
// Widgets de soporte
// ---------------------------------------------------------------------------

class _SettingsItemData {
  final IconData icon;
  final String titulo;
  final String? subtitulo;
  final Color? colorIcono;
  final VoidCallback onTap;

  const _SettingsItemData({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.colorIcono,
  });
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.items});

  final List<_SettingsItemData> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SettingsTile(data: items[i]),
            if (i != items.length - 1)
              Divider(height: 1, color: AppColors.border, indent: 56),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.data});

  final _SettingsItemData data;

  @override
  Widget build(BuildContext context) {
    final color = data.colorIcono ?? AppColors.primary;

    return ListTile(
      onTap: data.onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(data.icon, color: color, size: 20),
      ),
      title: Text(data.titulo, style: AppTextStyles.cardTitle),
      subtitle: data.subtitulo != null
          ? Text(data.subtitulo!, style: AppTextStyles.subtitle)
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.disabled),
    );
  }
}
