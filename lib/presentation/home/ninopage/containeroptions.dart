import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class GridDashboard extends StatelessWidget {
  Items item1 = Items(
      title: "Calendar",
      img: "assets/calendar.png");

  Items item2 = Items(
    title: "Groceries",

    img: "assets/food.png",
  );
  
  Items item4 = Items(
    title: "Activity",

    img: "assets/festival.png",
  );
  Items item5 = Items(
    title: "To do",

    img: "assets/todo.png",
  );
  

  GridDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2,  item4, item5];
  
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: const EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    data.img,
                    width: 42,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  
                  const SizedBox(
                    height: 14,
                  ),
                  
                ],
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;

  String img;
  Items({required this.title, required this.img});
}