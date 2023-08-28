import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavMenu> navMenus;
  final Function(int) onSelectedMenu;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.navMenus,
    required this.onSelectedMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 1,
            color: Colors.black26.withOpacity(0.3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navMenus
            .map((e) => InkWell(
                  onTap: () => onSelectedMenu(navMenus.indexOf(e)),
                  child: SizedBox.fromSize(
                    size: Size(
                        MediaQuery.of(context).size.width / navMenus.length,
                        64),
                    child: _BottomNavItem(
                      menu: e,
                      selected: currentIndex == navMenus.indexOf(e),
                      index: navMenus.indexOf(e),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final NavMenu menu;
  final bool selected;
  final int index;

  const _BottomNavItem({
    required this.menu,
    required this.index,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return _normalMenu(context);
  }

  Widget _normalMenu(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/${menu.icon}.png',
          width: 20,
          height: 20,
          color: selected
              ? const Color(0xffffa400)
              : Theme.of(context).iconTheme.color,
        ),
        const SizedBox(height: 2),
        Text(
          menu.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected
                ? const Color(0xffffa400)
                : Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}

class NavMenu {
  final String label;
  final String icon;

  NavMenu({required this.label, required this.icon});
}
