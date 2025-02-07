import 'package:flutter/material.dart';

class LDefault extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final BottomNavigationBar? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final IconButton? iconButton;

  const LDefault({
    required this.child,
    this.title,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    super.key,
    this.iconButton,
  });

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title!,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: iconButton != null ? [iconButton!] : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
