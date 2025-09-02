import 'package:flutter/material.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:ivf/Api/api_methods.dart';
import 'package:ivf/Screens/Dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivf/Bloc/login_bloc.dart';
import 'package:ivf/Utils/common.dart';

class NewUser extends StatefulWidget {
  NewUser({super.key});

  @override
  State<NewUser> createState() => NewUserState();
}

class NewUserState extends State<NewUser> {
  var formKey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  final ApiMethods api = ApiMethods();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(
                backgroundColor: AppColors.bgColor,
                centerTitle: true,
                title: CommonPack().regularText(
                    text: 'Basic Details',
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontsize: 20)),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          CommonPack().regularText(
                              text: 'Enter your basic details to register.',
                              color: AppColors.purple,
                              fontsize: 20,
                              fontWeight: FontWeight.w500),
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CommonPack().regularText(
                                text: 'First Name',
                                fontsize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: fnameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter first name'
                                    : null,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              hintText: 'XXXXXXX',
                              hintStyle: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Outfit',
                                  fontSize: 14),
                              fillColor: AppColors.textColor,
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CommonPack().regularText(
                                text: 'Last Name',
                                fontsize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: lnameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter last name'
                                    : null,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              hintText: 'XXXXXXX',
                              hintStyle: TextStyle(
                                fontFamily: 'Outfit',
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                              fillColor: AppColors.textColor,
                              filled: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CommonPack().regularText(
                                text: 'Date of Birth',
                                fontsize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildDropdown(31, 'XX', selectedDay, (value) {
                                setState(() {
                                  selectedDay = value;
                                });
                              }),
                              buildDropdown(12, 'XX', selectedMonth, (value) {
                                setState(() {
                                  selectedMonth = value;
                                });
                              }),
                              buildDropdown(106, 'XXXX', selectedYear, (value) {
                                setState(() {
                                  selectedYear = value;
                                });
                              }, start: 1920),
                            ],
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CommonPack().regularText(
                                text: 'Email',
                                fontsize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please enter email';
                              String pattern =
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                              if (!RegExp(pattern).hasMatch(value))
                                return 'Enter a valid email address';
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              hintText: 'XXXXXXX',
                              hintStyle: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                              fillColor: AppColors.textColor,
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CommonPack().regularText(
                                text: 'Country',
                                fontsize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: countryController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter country'
                                    : null,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              hintText: 'XXXXXXX',
                              hintStyle: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                              fillColor: AppColors.textColor,
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CommonPack().regularText(
                                text: 'City',
                                fontsize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: cityController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter city'
                                    : null,
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                              hintText: 'XXXXXXX',
                              hintStyle: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                              fillColor: AppColors.textColor,
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: submitForm,
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.pink, width: 2),
                                    right: BorderSide(
                                        color: Colors.pink, width: 2),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.buttonColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(Icons.arrow_forward,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDropdown(int count, String hint, String? selectedValue,
      ValueChanged<String?> onChanged,
      {int start = 1}) {
    return Container(
      width: 110,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.textColor,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isDense: true,
          isExpanded: true,
          iconSize: 45,
          iconEnabledColor: AppColors.purple,
          alignment: Alignment.centerRight,
          hint: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(hint, style: TextStyle(
              fontFamily: 'Outfit',
              color: AppColors.black,
              fontWeight: FontWeight.w300,
              fontSize: 14),)]),
          items: List.generate(count, (index) {
            final value = (start + index).toString();
            return DropdownMenuItem(value: value, child: Text(value));
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      if (selectedDay == null ||
          selectedMonth == null ||
          selectedYear == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select Date of Birth')));
        return;
      }

      final dob = '${selectedDay!}-${selectedMonth!}-${selectedYear!}';

      try {
        final data = await api.updateNewUsers(
          firstName: fnameController.text,
          lastName: lnameController.text,
          dateOfBirth: dob,
          email: emailController.text,
          country: countryController.text,
          city: cityController.text,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token != null) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('User updated successfully')));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Dashboard(token)));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No Token")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Can't update user")));
      }
    }
  }
}
