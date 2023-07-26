import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(
              text: 'Surah',
            ),
            Tab(
              text: 'Index',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // Surah Tab
              Center(
                child: Text(
                  'Surah Content',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              // Index Tab
              Center(
                child: Text(
                  'Index Content',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
