import 'package:flutter/material.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:ivf/Utils/common.dart';
import 'package:ivf/Repositary/app_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:ivf/Bloc/user_ bloc.dart';
import 'package:ivf/Screens/Dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewUser extends StatefulWidget {
  const NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => UserBloc(),
      child: BlocListener<UserBloc, NewUserState>(
        listener: (context, state) {
          if (state is UpdateUserState) {
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ));
            }
          }
        },
        child: BlocBuilder<UserBloc, NewUserState>(
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
                  fontsize: 20,
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Container(
                        width: width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            CommonPack().regularText(
                              text: 'Enter your basic details to register.',
                              color: AppColors.purple,
                              fontsize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 30),
                            buildLabel('First Name'),
                            buildTextField(
                                fnameController, 'Please enter first name'),
                            buildLabel('Last Name'),
                            buildTextField(
                                lnameController, 'Please enter last name'),
                            buildLabel('Date of Birth'),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildDropdown(31, 'XX', selectedDay, (value) {
                                  setState(() => selectedDay = value);
                                }),
                                buildDropdown(12, 'XX', selectedMonth, (value) {
                                  setState(() => selectedMonth = value);
                                }),
                                buildDropdown(106, 'XXXX', selectedYear,
                                    (value) {
                                  setState(() => selectedYear = value);
                                }, start: 1920),
                              ],
                            ),
                            buildLabel('Email'),
                            TextFormField(
                              controller: emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                const pattern =
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                if (!RegExp(pattern).hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                              decoration: inputDecoration('XXXXXXX'),
                            ),
                            const SizedBox(height: 20),
                            buildLabel('Country'),
                            buildTextField(
                                countryController, 'Please enter country'),
                            buildLabel('City'),
                            buildTextField(cityController, 'Please enter city'),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (selectedDay == null ||
                                        selectedMonth == null ||
                                        selectedYear == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please select Date of Birth')),
                                      );
                                      return;
                                    }
                                    final dob = '${selectedDay!}-${selectedMonth!}-${selectedYear!}';

                                    final prefs = await SharedPreferences.getInstance();
                                    final userId = prefs.getString('id');print('UserId:${userId}');

                                    if (userId == null || userId.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('User ID not found!')),
                                      );
                                      return;
                                    }
                                    var payload = NewUserModel(
                                      firstName: fnameController.text,
                                      lastName: lnameController.text,
                                      dob: dob,
                                      email: emailController.text,
                                      country: countryController.text,
                                      city: cityController.text,
                                    );
                                    BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(userId, payload, context));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Form submitted. DOB: $dob')),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: const Border(
                                      top: BorderSide(
                                          color: Colors.pink, width: 2),
                                      right: BorderSide(
                                          color: Colors.pink, width: 2),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.buttonColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(Icons.arrow_forward,
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
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: CommonPack().regularText(
        text: text,
        fontsize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String errorMsg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            (value == null || value.isEmpty) ? errorMsg : null,
        decoration: inputDecoration('XXXXXXX'),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Outfit',
        color: AppColors.black,
        fontWeight: FontWeight.w300,
        fontSize: 14,
      ),
      fillColor: AppColors.textColor,
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  Widget buildDropdown(
    int count,
    String hint,
    String? selectedValue,
    ValueChanged<String?> onChanged, {
    int start = 1,
  }) {
    return Container(
      width: 110,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          iconSize: 30,
          iconEnabledColor: AppColors.purple,
          hint: Text(
            hint,
            style: TextStyle(
              fontFamily: 'Outfit',
              color: AppColors.black,
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
          ),
          items: List.generate(count, (index) {
            final value = (start + index).toString();
            return DropdownMenuItem(value: value, child: Text(value));
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }

}
