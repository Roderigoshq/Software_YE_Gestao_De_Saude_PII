import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/custom_tab.dart';

class NavigationDestination {
  final Icon icon;
  final String label;

  NavigationDestination({required this.icon, required this.label});
}

class NavigationBar extends StatelessWidget {
  final List<NavigationDestination> destinations;

  NavigationBar({required this.destinations});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: destinations
            .map((destination) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                      },
                      icon: destination.icon,
                    ),
                    Text(
                      destination.label,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}