import 'package:flutter/material.dart';
import 'package:joub_jum/consts.dart';
import 'package:joub_jum/pages/auth_pages/login_screen.dart';
import 'package:joub_jum/pages/auth_pages/username.dart';

class PhoneNum extends StatefulWidget {
  const PhoneNum({super.key});

  @override
  State<PhoneNum> createState() => _PhoneNumState();
}

class _PhoneNumState extends State<PhoneNum> {
  String selectedValue = '+855'; // Default country code
  List<String> dropDownCountryNums = [
    '+855',
    '+1',
    '+44',
    '+65',
    '+66'
  ]; // List of country codes

  List<DropdownMenuItem<String>> getDropdownMenuItems() {
    // Create a list of items with the selected value at the top
    List<String> sortedItems = [selectedValue];
    sortedItems
        .addAll(dropDownCountryNums.where((code) => code != selectedValue));

    return sortedItems.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  void _clickedButton() {
    navigateToNextScreen(context, const Username());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // This makes the scaffold resize when the keyboard is present
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // To space the children
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 100.0,
                ),
                const Text(
                  'Phone Number',
                  style: TextStyle(
                      color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40, left: 25, right: 25),
                  child: TextField(
                    keyboardType: TextInputType.phone, // Phone keyboard
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(13),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      prefixIcon: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                          items:
                          getDropdownMenuItems(), // Use the custom list with selected item at top
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: _clickedButton,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      navigateToNextScreen(context, const LoginPage());
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
