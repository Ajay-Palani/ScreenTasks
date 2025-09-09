import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:ivf/Utils/common.dart';
import 'package:ivf/Bloc/dashboard_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? userName;
  DateTime? selectedDate;

  List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(FetchDashboardEvent(context)),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          // Main Dashboard Success
          if (state is DashboardSuccess) {
            final user = state.user;
            userName = '${user.firstName} ${user.lastName}';

            return Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: AppBar(
                title: Text('Dashboard', style: TextStyle(color: AppColors.purple)),
                centerTitle: true,
                backgroundColor: AppColors.bgColor,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProfileRow("Name", userName!),
                    buildProfileRow("DoB", user.dob),
                    buildProfileRow("Email", user.email),
                    buildProfileRow("City", user.city),
                    buildProfileRow("Country", user.country),
                    SizedBox(height: 30),
                    Text("Select a Date",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: dates.map((date) {
                        final isSelected = selectedDate != null &&
                            DateFormat('yyyy-MM-dd').format(selectedDate!) ==
                                DateFormat('yyyy-MM-dd').format(date);

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.pinkAccent : Colors.grey[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            setState(() => selectedDate = date);
                            context.read<DashboardBloc>().add(
                              FetchTimeSlotsEvent(
                                  DateFormat('yyyy-MM-dd').format(date), context),
                            );
                          },
                          child: Column(
                            children: [
                              Text(DateFormat('EEE').format(date),
                                  style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black)),
                              Text(DateFormat('dd MMM').format(date),
                                  style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),

                    if (selectedDate != null)
                      BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, slotState) {
                          if (slotState is TimeSlotsLoaded) {
                            final slots = slotState.slots;
                            if (slots.isEmpty) return Center(child: Text("No slots available"));
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: slots.map((slot) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: slot['isBooked'] ? Colors.grey : Colors.pinkAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(8),
                                  ),
                                  onPressed: slot['isBooked'] ? null : () => showSlotDialog(slot),
                                  child: Text("${slot['startTime']} - ${slot['endTime']}",
                                      style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            );
                          }
                          else if (slotState is TimeSlotsError) {
                            return Center(child: Text(slotState.message));
                          }
                          return SizedBox();
                        },
                      ),
                  ],
                ),
              ),
            );
          }

          else{
            return Scaffold(body: Center(child: Text('data'),),);
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
              text: title, fontWeight: FontWeight.w500, fontsize: 20, color: AppColors.headText),
          CommonPack().regularText(
              text: value, fontWeight: FontWeight.w500, fontsize: 20, color: AppColors.headText),
        ],
      ),
    );
  }

  void showSlotDialog(Map<String, dynamic> slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Appointment'),
        content: Text(
          'Name: $userName\n'
              'Date: ${DateFormat('dd MMM yyyy').format(selectedDate!)}\n'
              'Time: ${slot['startTime']} - ${slot['endTime']}\n'
              'Additional Info: ${slot['details'] ?? 'No details'}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonColor),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Appointment confirmed on ${DateFormat('dd MMM yyyy').format(selectedDate!)} at ${slot['startTime']}')));
            },
            child: Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

}
