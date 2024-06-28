import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:people_frontend/services/api.services.dart';

class UserDetailsPage extends StatefulWidget {
  final int userId;

  UserDetailsPage({required this.userId});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String? name;
  String? district;
  String? dateOfBirth;
  String? imageUrl;
  String? gender;
  String? postCode;
  String? address;
  String? nationality;
  String? phoneNumber1;
  String? phoneNumber2;
  String? religion;
  String? department;
  String? education;
  String? entryDate;
  String? leavingDate;
  String? workExperience;
  String? hobby;
  String? specialSkill;
  String? language;
  String? nrc;
  String? email;
  bool isLoading = true;
  late String mobilePath;

  @override
  void initState() {
    super.initState();
    loadUserData(widget.userId);
  }

  String checkUrl(String imageUrl) {
    if (kIsWeb)
      return imageUrl;
    else
      mobilePath = imageUrl.substring(12);
    return "http://10.0.2.2${mobilePath}";
  }

  Future<void> loadUserData(int userId) async {
    try {
      var responseData = await fetchuser_details(userId);

      if (responseData != null) {
        setState(() {
          name = responseData['detail_user_infos']['name'];
          district = responseData['detail_user_infos']['district'];
          dateOfBirth = responseData['detail_user_infos']['date_of_birth'];
          imageUrl = responseData['detail_user_infos']['image'];
          gender = responseData['detail_user_infos']['gender'] == 1
              ? 'Male'
              : 'Female';
          postCode = responseData['detail_user_infos']['post_code'];
          address = responseData['detail_user_infos']['address'];
          nationality = responseData['detail_user_infos']['nationality'];
          phoneNumber1 = responseData['detail_user_infos']['phone_number_1'];
          phoneNumber2 = responseData['detail_user_infos']['phone_number_2'];
          religion = responseData['detail_user_infos']['religion'];
          department = responseData['detail_user_infos']['department'];
          education = responseData['detail_user_infos']['education'];
          entryDate = responseData['detail_user_infos']['entry_date'];
          leavingDate = responseData['detail_user_infos']['leaving_date'];
          workExperience = responseData['detail_user_infos']['work_experience'];
          hobby = responseData['detail_user_infos']['hobby'];
          specialSkill = responseData['detail_user_infos']['special_skill'];
          language = responseData['detail_user_infos']['language'];
          nrc = responseData['detail_user_infos']['nrc'];
          email = responseData['detail_users']['email'];

          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 1),
            child: checkUrl(imageUrl!) != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      checkUrl(imageUrl!),
                      width: 400,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  )
                : Text('No image available'),
          ),
          const SizedBox(height: 10),
          Text(
            name ?? 'Name not available',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            email ?? 'Email not available',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 12, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserData('Birthday : ', dateOfBirth ?? 'null'),
                    UserData('NRC No : ', nrc ?? 'null'),
                    UserData('Gender : ', gender ?? 'null'),
                    UserData('Address : ',
                        '${address ?? 'null'}, ${district ?? 'null'}'),
                    UserData('Post Code : ', postCode ?? 'null'),
                    UserData('Phone No : ',
                        '${phoneNumber1 ?? 'null'}, ${phoneNumber2 ?? 'null'}'),
                    UserData('Religion : ', religion ?? 'null'),
                    UserData('Nationality : ', nationality ?? 'null'),
                    UserData('Department : ', department ?? 'null'),
                    UserData('Education : ', education ?? 'null'),
                    UserData('Entry Date : ', entryDate ?? 'null'),
                    UserData('Leave Date : ', leavingDate ?? 'null'),
                    UserData('Work Exp : ', workExperience ?? 'null'),
                    UserData('Hobby : ', hobby ?? 'null'),
                    UserData('Special Skill : ', specialSkill ?? 'null'),
                    UserData('Language : ', language ?? 'null'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget UserData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(fontSize: 17, height: 2),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Container(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontSize: 16,
                        height: 2,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}