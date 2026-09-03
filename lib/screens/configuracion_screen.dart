import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/opcion_menu_card.dart';
import '../services/storage_service.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      children: [
        Text(
          "Configuración",
          style: AppTextStyles.screenTitle.copyWith(color: AppColors.primary),
        ),

        const SizedBox(height: 24),

        Text("Cuenta", style: AppTextStyles.sectionTitle),
        const SizedBox(height: 10),

        OpcionMenuCard(
          icon: Icons.person_outline,
          titulo: "Mi usuario",
          subtitulo: "Nombre, correo y contraseña",
          onTap: () => Navigator.pushNamed(context, "/formulario_usuario"),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return const Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Esta sección permite administrar y mantener actualizada la información del usuario, incluyendo datos como su nombre, correo electrónico, contraseña y estado dentro del sistema. Desde esta sección se puede modificar la información necesaria para gestionar correctamente el acceso y los datos de la cuenta.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 24),

        Text("Negocio", style: AppTextStyles.sectionTitle),
        const SizedBox(height: 10),

        OpcionMenuCard(
          icon: Icons.storefront_outlined,
          titulo: "Datos de la empresa",
          subtitulo: "Nombre, razón social, RTN, contacto y logo",
          onTap: () => Navigator.pushNamed(context, "/formulario_empresa"),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return const Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Esta sección permite administrar y mantener actualizada la información general de la empresa. Aquí se pueden consultar y modificar datos importantes como el nombre comercial, razón social, RTN, dirección, número de teléfono y correo electrónico. Esta información es utilizada dentro del sistema para identificar correctamente a la empresa y es necesaria para la generación de facturas.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          },
        ),
        OpcionMenuCard(
          icon: Icons.receipt_long_outlined,
          titulo: "Datos fiscales (CAI)",
          subtitulo: "Autorización, rango de facturación y vigencia",
          onTap: () =>
              Navigator.pushNamed(context, "/formulario_datos_fiscales"),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return const Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Este apartado permite administrar y mantener actualizada la información fiscal de la empresa. Aquí se pueden consultar y modificar datos importantes como vigencia del CAI (Código de Autorización de Impresión), rango autorizado y otros datos relacionados. Esta información es utilizada dentro del sistema para garantizar el cumplimiento de las obligaciones fiscales y la generación de facturas.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 24),

        Text("Aplicación", style: AppTextStyles.sectionTitle),
        const SizedBox(height: 10),

        OpcionMenuCard(
          icon: Icons.logout,
          titulo: "Cerrar sesión",
          colorIcono: AppColors.error,
          mostrarFlecha: false,
          onTap: ()  async {
              await StorageService().deleteToken();

              if (!context.mounted) return;

            Navigator.pushNamedAndRemoveUntil(
              context,
              "/login",
              (route) => false,
            );
          },
          onLongPress: () {},
        ),
      ],
    );
  }
}
