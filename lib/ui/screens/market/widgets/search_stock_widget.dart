import 'package:flutter/material.dart';

class SearchStockWidget extends StatelessWidget {
  const SearchStockWidget({super.key, required this.onTap});
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: SizedBox(
              height: kTextTabBarHeight,
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .color!
                    .withOpacity(0.05),
                child: Row(
                  children: [
                    //a bit of space
                    const SizedBox(
                      width: 10,
                    ),
                    // search icon
                    Icon(
                      Icons.search,
                      color: Theme.of(context).textTheme.headlineMedium!.color,
                    ),
                    // space again
                    const SizedBox(
                      width: 10,
                    ),
                    // search text
                    Text(
                      'Search',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .color),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
