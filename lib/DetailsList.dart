import 'package:flutter/material.dart';

class Detailslist extends StatelessWidget {
  List<TextEditingController> details = [];
  Detailslist(this.details, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;
    double height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: width,
            height: height * 0.1,
            child: Center(
              child: Text(
                'List of Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: width * 1,
            height: height * 0.6,
            child: Card(
              child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${details[index].text}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
