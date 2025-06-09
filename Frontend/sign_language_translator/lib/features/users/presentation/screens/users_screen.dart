import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_language_translator/features/users/presentation/provider/users_provider.dart';
import 'package:sign_language_translator/shared/widgets/app_drawer.dart';
import 'package:sign_language_translator/shared/widgets/platform_button.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: SuperScaffold(
        appBar: buildUsersSuperAppBar(colorScheme, context),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: context.read<UsersProvider>().fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Consumer<UsersProvider>(builder: (context, provider, _) {
                return ListView.builder(
                  itemCount: provider.users.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final user = provider.users[index];

                    return PlatformButton(
                      onPressed: () => _showOptionsDialog(context, user),
                      backgroundColor: colorScheme.primary,
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                      physicalModel: true,
                      leading: IconButton(
                          onPressed: () => _showEditDialog(context, user),
                          icon: Icon(Icons.edit, color: colorScheme.onPrimary)),
                      trailing: IconButton(
                          onPressed: () => _showDeleteDialog(context, user['id_usuario']),
                          icon: const Icon(Icons.delete, color: Colors.red)),
                      title: Text(
                        user['nombre'],
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                      subtitle: Text(
                        user['correo'],
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    );
                  },
                );
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  SuperAppBar buildUsersSuperAppBar(ColorScheme colorScheme, BuildContext context) {
    return SuperAppBar(
      height: kToolbarHeight + 10,
      backgroundColor: colorScheme.surface.withOpacity(0.5),
      leading: Builder(
        builder: (BuildContext context) {
          return PlatformButton(
            tooltip: "Menú",
            margin: const EdgeInsets.only(left: 5.0),
            borderRadius: BorderRadius.circular(50.0),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: Icon(Icons.menu, color: colorScheme.onSurface),
          );
        },
      ),
      title: Text(
        "Usuarios",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: colorScheme.onSurface),
      ),
      
      // Titulo cuando este expandido
      largeTitle: SuperLargeTitle(
        enabled: true,
        height: 75,
        textStyle: TextStyle(
          inherit: false,
          fontFamily: '.SF Pro Display',
          fontSize: 34.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.41,
          color: colorScheme.onSurface,
          overflow: TextOverflow.ellipsis,
        ),
        largeTitle: "Usuarios",
      ),

      // Deshabilita la barra de busqueda
      searchBar: SuperSearchBar(enabled: false),
    );
  }

  void _showOptionsDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Opciones'),
        content: const Text('Elige una opción:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showEditDialog(context, user);
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showDeleteDialog(context, user['id_usuario']);
            },
            child: const Text('Eliminar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<UsersProvider>().deleteUser(id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> user) {
    final TextEditingController nombreController = TextEditingController(text: user['nombre']);
    final TextEditingController apellidoController = TextEditingController(text: user['apellido']);
    final TextEditingController correoController = TextEditingController(text: user['correo']);
    final TextEditingController rolController = TextEditingController(text: user['rol']);
    final TextEditingController imagenController = TextEditingController(text: user['imagen']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: rolController,
                decoration: const InputDecoration(labelText: 'Rol (admin o user)'),
              ),
              TextField(
                controller: imagenController,
                decoration: const InputDecoration(labelText: 'Imagen'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final updatedUser = {
                'id_usuario': user['id_usuario'],
                'nombre': nombreController.text,
                'apellido': apellidoController.text,
                'correo': correoController.text,
                'rol': rolController.text,
                'imagen': imagenController.text,
              };

              context.read<UsersProvider>().updateUser(user['id_usuario'], updatedUser);
              Navigator.of(ctx).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController apellidoController = TextEditingController();
    final TextEditingController correoController = TextEditingController();
    final TextEditingController contraseniaController = TextEditingController();
    final TextEditingController rolController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: contraseniaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              TextField(
                controller: rolController,
                decoration: const InputDecoration(labelText: 'Rol (admin o user)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final newUser = {
                'nombre': nombreController.text,
                'apellido': apellidoController.text,
                'correo': correoController.text,
                'contrasenia': contraseniaController.text,
                'rol': rolController.text,
              };

              context.read<UsersProvider>().addUser(newUser);
              Navigator.of(ctx).pop();
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
