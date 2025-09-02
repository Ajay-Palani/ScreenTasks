import 'package:flutter/material.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:ivf/Api/api_methods.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivf/Bloc/dashboard_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ivf/Utils/common.dart';

class Dashboard extends StatefulWidget {
  final String token;

  Dashboard(this.token, {super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userName = "";
  String dob = "";
  String email = "";
  String city = "";
  String country = "";

  List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
  ];

  DateTime? selectedDate;
  List<dynamic> availableSlots = [];
  bool isLoadingSlots = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    try {
      final response = await ApiMethods().getData();
      final user = response['data']['user'];
      setState(() {
        userName = "${user['firstName']} ${user['lastName']}";
        dob = user['dateOfBirth'] ?? '';
        email = user['email'] ?? '';
        city = user['city'] ?? '';
        country = user['country'] ?? '';
      });
    } catch (e) {
      print("Error fetching user");
    }
  }

  void getSlots(DateTime date) async {
    setState(() {
      isLoadingSlots = true;
      availableSlots = [];
    });

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response =
          await ApiMethods().getTimeSlots(widget.token, formattedDate);
      final slots = response['data']['availableSlots'];
      setState(() {
        availableSlots = slots;
      });
    } catch (e) {
      print("Error fetching slots");
      setState(() {
        availableSlots = [];
      });
    } finally {
      setState(() {
        isLoadingSlots = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;
    double height = MediaQuery.of(context).size.height * 1;
    return BlocProvider(
      create: (context) =>
          DashboardBloc()..add(FetchDashboardEvent(widget.token)),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Shimmer.fromColors(
                child: Container(
                  width: width * 1,
                  height: height * 0.4,
                  child: Card(),
                ),
                baseColor: AppColors.bgColor,
                highlightColor: Colors.grey);
          }
          if (state is DashboardSuccess) {
            return Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: AppBar(
                title: Text('Dashboard',
                    style: TextStyle(color: AppColors.purple)),
                centerTitle: true,
                backgroundColor: AppColors.bgColor,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProfileRow("Name", userName),
                    buildProfileRow("DoB", dob),
                    buildProfileRow("Email", email),
                    buildProfileRow("City", city),
                    buildProfileRow("Country", country),
                    SizedBox(height: 30),
                    Text("Select a Date",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: dates.map((date) {
                        final isSelected = selectedDate != null &&
                            DateFormat('yyyy-MM-dd').format(selectedDate!) ==
                                DateFormat('yyyy-MM-dd').format(date);
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.pinkAccent
                                : Colors.grey[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDate = date;
                            });
                            getSlots(date);
                          },
                          child: Column(
                            children: [
                              Text(DateFormat('EEE').format(date),
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black)),
                              Text(DateFormat('dd MMM').format(date),
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    if (isLoadingSlots)
                      Center(child: CircularProgressIndicator()),
                    if (!isLoadingSlots && selectedDate != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Slots on ${DateFormat('dd MMM yyyy').format(selectedDate!)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          (availableSlots.isEmpty)
                              ? Center(
                                  child: Text('No slots available'),
                                )
                              : Center(
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: availableSlots.map((slot) {
                                      final startTime = slot['startTime'];
                                      final endTime = slot['endTime'];
                                      final isBooked = slot['isBooked'];
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isBooked
                                              ? Colors.grey
                                              : Colors.pinkAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.all(8),
                                        ),
                                        onPressed: isBooked
                                            ? null
                                            : () => showSlotDialog(
                                                startTime, endTime),
                                        child: Text('$startTime - $endTime',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      );
                                    }).toList(),
                                  ),
                                )
                        ],
                      ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text('No data'),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildProfileRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonPack().regularText(
              text: title,
              fontWeight: FontWeight.w500,
              fontsize: 20,
              color: AppColors.headText),
          CommonPack().regularText(
              text: value,
              fontWeight: FontWeight.w500,
              fontsize: 20,
              color: AppColors.headText),
        ],
      ),
    );
  }

  void showSlotDialog(String startTime, String endTime) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Appointment'),
        content: Text(
            'Name: $userName\nDate: ${DateFormat('dd MMM yyyy').format(selectedDate!)}\nTime: $startTime - $endTime'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Appointment confirmed on ${DateFormat('dd MMM yyyy').format(selectedDate!)} at $startTime')));
            },
            child: Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
}
