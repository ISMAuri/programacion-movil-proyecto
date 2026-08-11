import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/cliente_card.dart';
import 'formulario_clientes_screen.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: const [
          ClienteCard(
            nombreCliente: "Ana Gómez",
            rtn: "0801-1990-12345",
            direccion: "Col. Palmira, Tegucigalpa",
            telefono: "9988-7766",
            correo: "ana.gomez@email.com",
            fechaRegistro: "12/01/2025",
          ),
          ClienteCard(
            nombreCliente: "Distribuidora El Sol S.A.",
            rtn: "0801-2015-67890",
            direccion: "Blvd. Morazán, Tegucigalpa",
            telefono: "2234-5566",
            correo: "contacto@elsol.hn",
            fechaRegistro: "03/06/2025",
          ),
          ClienteCard(
            nombreCliente: "Roberto Suazo",
            rtn: "0501-1985-54321",
            direccion: "Barrio Los Andes, Comayagua",
            telefono: "9911-2233",
            correo: "r.suazo@email.com",
            fechaRegistro: "20/03/2026",
          ),
          ClienteCard(
            nombreCliente: "Mini Market La Esquina",
            rtn: "0801-2020-11223",
            direccion: "Col. Kennedy, Tegucigalpa",
            telefono: "2245-9900",
            correo: "laesquina@market.hn",
            fechaRegistro: "15/07/2026",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioClienteScreen(),
            ),
          );
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}