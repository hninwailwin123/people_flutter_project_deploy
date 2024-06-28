import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:people_frontend/services/api.services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formField = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final userTypeController = TextEditingController();
  final imageController = TextEditingController();
  final genderController = TextEditingController();
  final postCodeController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumber1Controller = TextEditingController();
  final phoneNumber2Controller = TextEditingController();
  final nationalityController = TextEditingController();
  final districtController = TextEditingController();
  final religionController = TextEditingController();
  final departmentController = TextEditingController();
  final entryDateController = TextEditingController();
  final leavingDateController = TextEditingController();
  final educationController = TextEditingController();
  final workExperimentController = TextEditingController();
  final hobbyController = TextEditingController();
  final specialSkillController = TextEditingController();
  final languageController = TextEditingController();
  final nrcController = TextEditingController();

  bool passwordToggle = true;
  bool passwordToggle1 = true;
  bool admin = true;
  bool nameError = false;
  bool imageError = false;
  bool emailError = false;
  bool passwordError = false;
  bool nrcError = false;
  bool phoneNumber1Error = false;
  bool nationalityError = false;
  bool districtError = false;
  bool departmentError = false;
  bool entryDateError = false;
  bool educationError = false;
  bool hobbyError = false;
  bool dateOfBirthError = false;
  int gender = 1;
  int userTypeValue = 2;
  List<String> userTypes = [
    'Admin User',
    'General',
    'Guest',
  ];

  String nameWarning = '';
  String emailWarning = '';
  String passwordWarning = '';
  String dateOfBirthWarning = '';
  String phoneNumber1Warning = '';
  String nationalityWarning = '';
  String districtWarning = '';
  String departmentWarning = '';
  String entryDateWarning = '';
  String educationWarning = '';
  String hobbyWarning = '';
  String nrcWarning = '';
  Uint8List? imageBytes;

  bool _validateData() {
    bool isValid = true;
    if (nameController.text.isEmpty) {
      setState(() {
        nameWarning = '* Please enter your name';
        nameError = true;
        isValid = false;
      });
    }
    if (emailController.text.isEmpty) {
      setState(() {
        emailWarning = '* Please enter your email';
        emailError = true;
        isValid = false;
      });
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordWarning = '* Please enter your password';
        passwordError = true;
        isValid = false;
      });
    }
    if (dateOfBirthController.text.isEmpty) {
      setState(() {
        dateOfBirthWarning = '* Please select a date';
        dateOfBirthError = true;
        isValid = false;
      });
    }
    if (phoneNumber1Controller.text.isEmpty) {
      setState(() {
        phoneNumber1Warning = '* Please Fill your phone number';
        phoneNumber1Error = true;
        isValid = false;
      });
    }
    if (nationalityController.text.isEmpty) {
      setState(() {
        nationalityWarning = '* Please Fill your Nation';
        nationalityError = true;
        isValid = false;
      });
    }
    if (districtController.text.isEmpty) {
      setState(() {
        districtWarning = '* Please Fill your district';
        districtError = true;
        isValid = false;
      });
    }
    if (departmentController.text.isEmpty) {
      setState(() {
        departmentWarning = '* Please Fill your department';
        departmentError = true;
        isValid = false;
      });
    }
    if (entryDateController.text.isEmpty) {
      setState(() {
        entryDateWarning = '* Please select a date';
        entryDateError = true;
        isValid = false;
      });
    }
    if (educationController.text.isEmpty) {
      setState(() {
        educationWarning = '* Please Fill your education';
        educationError = true;
        isValid = false;
      });
    }
    if (hobbyController.text.isEmpty) {
      setState(() {
        hobbyWarning = '* Please Fill your Hobby';
        hobbyError = true;
        isValid = false;
      });
    }
    if (nrcController.text.isEmpty) {
      setState(() {
        nrcWarning = '* Please Fill your NRC';
        nrcError = true;
        isValid = false;
      });
    }
    return isValid;
  }

  Future<void> pickAndEncodeImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        imageBytes = bytes;
        imageController.text = base64Encode(bytes);
      });
    }
  }

  String formatDateString(String dateString) {
    try {
      final date = DateTime.parse(dateString);

      return date.toIso8601String();
    } catch (e) {
      throw Exception('Invalid date format: $dateString');
    }
  }

  void create() async {
    try {
      DateTime dateOfBirth = DateTime.parse(dateOfBirthController.text);
      DateTime entryDate = DateTime.parse(entryDateController.text);
      DateTime? leavingDate;

      if (leavingDateController.text.isNotEmpty) {
        leavingDate = DateTime.parse(leavingDateController.text);
      }

      await initializeDateFormatting();

      String res = await createUser(
          nameController.text,
          emailController.text,
          passwordController.text,
          dateOfBirth,
          userTypeValue,
          imageController.text,
          gender,
          postCodeController.text,
          addressController.text,
          phoneNumber1Controller.text,
          phoneNumber2Controller.text,
          nationalityController.text,
          districtController.text,
          religionController.text,
          departmentController.text,
          entryDate,
          leavingDate,
          educationController.text,
          workExperimentController.text,
          hobbyController.text,
          specialSkillController.text,
          languageController.text,
          nrcController.text);   
      if(res == "OK"){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromRGBO(21, 101, 192, 1.0),
          content: Text(
            "User Create Successfully!",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
       Map<String, dynamic>  mailrequest = await emailSending(emailController.text, nameController.text);
    }
      await Future.delayed(const Duration(seconds: 4));
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '$error',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: _formField,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: pickAndEncodeImage,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                backgroundColor: Colors.grey[300],
                              ),
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: Center(
                                  child: imageBytes == null
                                      ? Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 60,
                                          color: Colors.grey[600],
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            if (imageBytes != null)
                              GestureDetector(
                                onTap: pickAndEncodeImage,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: MemoryImage(imageBytes!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorText: nameWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: nameError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            nameError = false;
                            nameWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorText: emailWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: emailError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            emailError = false;
                            emailWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: passwordToggle,
                        decoration: InputDecoration(
                            hintText: "Password",
                            errorText: passwordWarning,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: passwordError
                                  ? const BorderSide(color: Colors.red)
                                  : BorderSide.none, // Red border when error
                            ),
                            fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                                .withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  passwordToggle = !passwordToggle;
                                });
                              },
                              child: Icon(
                                passwordToggle
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                            )),
                        onChanged: (value) {
                          setState(() {
                            passwordError = false;
                            passwordWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          contentPadding:
                              const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: userTypeValue,
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  userTypeValue = newValue;
                                });
                              }
                            },
                            items: userTypes
                                .asMap()
                                .entries
                                .map<DropdownMenuItem<int>>((entry) {
                              int idx = entry.key + 1;
                              String value = entry.value;
                              return DropdownMenuItem<int>(
                                value: idx,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownColor:
                                const Color.fromARGB(255, 210, 208, 241),
                            borderRadius: BorderRadius.circular(18),
                            elevation: 5,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: dateOfBirthController,
                        decoration: InputDecoration(
                          hintText: "Birthday",
                          errorText: dateOfBirthWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: dateOfBirthError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? picked0 = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked0 != null) {
                            setState(() {
                              dateOfBirthController.text =
                                  picked0.toLocal().toString().split(' ')[0];
                              dateOfBirthWarning = '';
                              dateOfBirthError = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text('Gender :',
                                  style: TextStyle(
                                      color: Color.fromRGBO(21, 101, 192, 1)))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: gender,
                                activeColor:
                                    const Color.fromRGBO(21, 101, 192, 1),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value as int;
                                  });
                                },
                              ),
                              const Text('Male'),
                              Radio(
                                value: 2,
                                groupValue: gender,
                                activeColor:
                                    const Color.fromRGBO(21, 101, 192, 1),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value as int;
                                  });
                                },
                              ),
                              const Text('Female'),
                              Radio(
                                value: 3,
                                groupValue: gender,
                                activeColor:
                                    const Color.fromRGBO(21, 101, 192, 1),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value as int;
                                  });
                                },
                              ),
                              const Text('Others'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: postCodeController,
                        decoration: InputDecoration(
                          hintText: "Post Code",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(FontAwesomeIcons.wpforms),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: "Address",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.place),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: phoneNumber1Controller,
                        decoration: InputDecoration(
                          hintText: "Phone Number 1",
                          errorText: phoneNumber1Warning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: phoneNumber1Error
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.local_phone),
                        ),
                        onChanged: (value) {
                          setState(() {
                            phoneNumber1Error = false;
                            phoneNumber1Warning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: phoneNumber2Controller,
                        decoration: InputDecoration(
                          hintText: "Phone Number 2",
                          errorText: nameWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.local_phone),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nationalityController,
                        decoration: InputDecoration(
                          hintText: "Nationality",
                          errorText: nationalityWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: nationalityError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.flag),
                        ),
                        onChanged: (value) {
                          setState(() {
                            nationalityError = false;
                            nationalityWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: districtController,
                        decoration: InputDecoration(
                          hintText: "District",
                          errorText: districtWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: districtError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.location_city),
                        ),
                        onChanged: (value) {
                          setState(() {
                            districtError = false;
                            districtWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: religionController,
                        decoration: InputDecoration(
                          hintText: "Religion",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(FontAwesomeIcons.pray),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: departmentController,
                        decoration: InputDecoration(
                          hintText: "Department",
                          errorText: departmentWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: departmentError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.business),
                        ),
                        onChanged: (value) {
                          setState(() {
                            departmentError = false;
                            departmentWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: entryDateController,
                        decoration: InputDecoration(
                          hintText: "Entry Date",
                          errorText: entryDateWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: entryDateError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.date_range),
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              entryDateController.text =
                                  picked.toLocal().toString().split(' ')[0];
                              entryDateError = false;
                              entryDateWarning = '';
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: leavingDateController,
                        decoration: InputDecoration(
                          hintText: "Leaving Date",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.date_range),
                        ),
                        onTap: () async {
                          DateTime? picked1 = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked1 != null) {
                            setState(() {
                              leavingDateController.text =
                                  picked1.toLocal().toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: educationController,
                        decoration: InputDecoration(
                          hintText: "Education",
                          errorText: educationWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: educationError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.school),
                        ),
                        onChanged: (value) {
                          setState(() {
                            educationError = false;
                            educationWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: workExperimentController,
                        decoration: InputDecoration(
                          hintText: "Work Experience",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.work),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: hobbyController,
                        decoration: InputDecoration(
                          hintText: "Hobby",
                          errorText: hobbyWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: hobbyError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(FontAwesomeIcons.heart),
                        ),
                        onChanged: (value) {
                          setState(() {
                            hobbyError = false;
                            hobbyWarning = '';
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: specialSkillController,
                        decoration: InputDecoration(
                          hintText: "Special Skills",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.assessment),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: languageController,
                        decoration: InputDecoration(
                          hintText: "Language",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.language),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nrcController,
                        decoration: InputDecoration(
                          hintText: "NRC",
                          errorText: nrcWarning,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: nrcError
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none, // Red border when error
                          ),
                          fillColor: const Color.fromRGBO(21, 101, 192, 1.0)
                              .withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.credit_card),
                        ),
                        onChanged: (value) {
                          setState(() {
                            nrcError = false;
                            nrcWarning = '';
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: SizedBox(
                          width: 280,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_validateData()) {
                                create();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor:
                                  const Color.fromRGBO(21, 101, 192, 1.0),
                            ),
                            child: const Text(
                              "Create User",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
