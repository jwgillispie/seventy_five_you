import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/themes.dart';


class CustomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  const CustomNavBar({
    super.key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      decoration: navBarDecoration,
      height: navBarConfig.navBarHeight,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navBarConfig.items.length,
              (index) => Expanded(
                child: NavBarItem(
                  item: navBarConfig.items[index],
                  isSelected: navBarConfig.selectedIndex == index,
                  onTap: () => navBarConfig.onItemSelected(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final ItemConfig item;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected 
              ? (Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1))
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? item.activeForegroundColor
                    : item.inactiveForegroundColor,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
            if (item.title != null) ...[
              const SizedBox(height: 4),
              DefaultTextStyle(
                style: item.textStyle.apply(
                  color: isSelected
                      ? item.activeForegroundColor
                      : item.inactiveForegroundColor,
                ),
                child: Text(
                  item.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
// // Separate widget for nav bar items
// class NavBarItem extends StatelessWidget {
//   final ItemConfig item;
//   final bool isSelected;

//   const NavBarItem({
//     super.key,
//     required this.item,
//     required this.isSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: IconTheme(
//             data: IconThemeData(
//               size: item.iconSize,
//               color: isSelected
//                   ? item.activeForegroundColor
//                   : item.inactiveForegroundColor,
//             ),
//             child: isSelected ? item.icon : item.inactiveIcon,
//           ),
//         ),
//         if (item.title != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 15.0),
//             child: Material(
//               type: MaterialType.transparency,
//               child: FittedBox(
//                 child: Text(
//                   item.title!,
//                   style: item.textStyle.apply(
//                     color: isSelected
//                         ? item.activeForegroundColor
//                         : item.inactiveForegroundColor,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }