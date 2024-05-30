import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tdd/src/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:tdd/src/authentication/presentation/widgets/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();

  void getUsers() {
    context.read<AuthenticationCubit>().getUsers();
  }

  @override
  void initState() {
    super.initState();

    getUsers();
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUsers
              ? const LoadingColumn(
                  message: 'Fetching users',
                )
              : state is CreatingUser?
                  ? const LoadingColumn(
                      message: 'Creating user',
                    )
                  : state is UsersLoaded
                      ? Center(
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];

                              return ListTile(
                                leading: Image.network(
                                  user.avatar,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.network(
                                          'https://gravatar.com/avatar/826e2856a9384082d5a63aa2e59ed1eb?s=200&d=robohash&r=x'),
                                ),
                                // leading: CircleAvatar(
                                //   backgroundImage: NetworkImage(user.avatar),
                                //   onBackgroundImageError: (_, __) =>
                                //       const Image(
                                //     image: NetworkImage(
                                //         'https://gravatar.com/avatar/826e2856a9384082d5a63aa2e59ed1eb?s=200&d=robohash&r=x'),
                                //   ),
                                // ),
                                title: Text(user.name),
                                subtitle: Text(user.createdAt),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AddUserDialog(
                  nameController: nameController,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}
