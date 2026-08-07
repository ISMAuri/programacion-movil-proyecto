import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificaciones = true;
  bool _modoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Configuración", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 4),
            Text(
              "Administra tu cuenta y las preferencias de la app.",
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 20),

            // Perfil del usuario
            _buildPerfilCard(),

            const SizedBox(height: 24),
            Text("Cuenta", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            _buildSectionCard(
              children: [
                _buildOpcion(
                  icon: Icons.person_outline,
                  color: AppColors.primary,
                  title: "Editar perfil",
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOpcion(
                  icon: Icons.lock_outline,
                  color: AppColors.primary,
                  title: "Cambiar contraseña",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text("Preferencias", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            _buildSectionCard(
              children: [
                _buildSwitch(
                  icon: Icons.notifications_outlined,
                  color: AppColors.warning,
                  title: "Notificaciones",
                  value: _notificaciones,
                  onChanged: (val) => setState(() => _notificaciones = val),
                ),
                _buildDivider(),
                _buildSwitch(
                  icon: Icons.dark_mode_outlined,
                  color: AppColors.secondary,
                  title: "Modo oscuro",
                  value: _modoOscuro,
                  onChanged: (val) => setState(() => _modoOscuro = val),
                ),
                _buildDivider(),
                _buildOpcion(
                  icon: Icons.language_outlined,
                  color: AppColors.secondary,
                  title: "Idioma",
                  trailingText: "Español",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text("Inventario", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            _buildSectionCard(
              children: [
                _buildOpcion(
                  icon: Icons.category_outlined,
                  color: AppColors.success,
                  title: "Categorías de productos",
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOpcion(
                  icon: Icons.warning_amber_outlined,
                  color: AppColors.warning,
                  title: "Umbral de stock bajo",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text("Soporte", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            _buildSectionCard(
              children: [
                _buildOpcion(
                  icon: Icons.help_outline,
                  color: AppColors.primary,
                  title: "Ayuda y soporte",
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOpcion(
                  icon: Icons.info_outline,
                  color: AppColors.primary,
                  title: "Acerca de",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.logout, color: AppColors.error),
                label: Text(
                  "Cerrar sesión",
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Usuario", style: AppTextStyles.sectionTitle),
                const SizedBox(height: 2),
                Text("usuario@correo.com", style: AppTextStyles.subtitle),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOpcion({
    required IconData icon,
    required Color color,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.subtitle.copyWith(color: Colors.black87)),
      trailing: trailingText != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(trailingText, style: AppTextStyles.subtitle),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 20),
              ],
            )
          : const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildSwitch({
    required IconData icon,
    required Color color,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.subtitle.copyWith(color: Colors.black87)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200);
  }
}