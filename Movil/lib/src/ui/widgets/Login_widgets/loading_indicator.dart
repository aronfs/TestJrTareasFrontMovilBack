// loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/authorization/auth_bloc.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authBloc.isLoading,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: CircularProgressIndicator(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}