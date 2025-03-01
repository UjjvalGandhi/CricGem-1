import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../db/app_db.dart';
import '../model/ProfileDisplay.dart';
import '../widget/appbartext.dart';
import '../widget/smalltext.dart';
import 'country/selection.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime? selectedDate;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController pincode = TextEditingController();
  LocationSelection locationSelection = LocationSelection();

  String? _selectedCity;
  String? _selectedState;
  List<String> _city = [];
  List<String> _state = [];
  List<String>? cityList;
  XFile? _imageFile;
  // String? _selectedGender;
  String? _character = "Male";
  String? _profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    loadData();
    cityData(_selectedCity ?? '');
  }
  Future<String> loadData() async {
    var data = await rootBundle.loadString("assets/CountryStateCity.json");
    print("Raw JSON data: $data"); // Print the raw JSON

    // Adjust based on the actual structure of your JSON
    var countries = json.decode(data) as List; // If the root is a list

    String countryName = "India";
    var country = countries.firstWhere((c) => c["name"] == countryName, orElse: () => null);
    if (country != null) {
      List<dynamic> stateDynamic = country["states"];
      List<String> stateList = stateDynamic.map((e) => e['name'].toString()).toList();
      setState(() {
        _state = stateList;
      });
    } else {
      print("Country $countryName not found.");
    }
    return "success";
  }

  Future<String> cityData(String stateName) async {
    var data = await rootBundle.loadString("assets/CountryStateCity.json");
    print("Raw JSON data: $data"); // Print the raw JSON

    var countries = json.decode(data) as List; // If the root is a list

    String countryName = "India";
    var country = countries.firstWhere((c) => c["name"] == countryName, orElse: () => null);
    if (country != null) {
      var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
      if (state != null) {
        List<dynamic> cities = state["cities"];
        List<String> cityNames = cities.map((city) => city["name"].toString()).toList();
        setState(() {
          _city = cityNames;
        });
      } else {
        print("State $stateName not found in $countryName.");
      }
    } else {
      print("Country $countryName not found.");
    }
    return "success";
  }

  Future<void> _loadProfileData() async {
    ProfileDisplay? profileData = await profileDisplay();
    if (profileData != null) {
      setState(() {
        name.text = profileData.data!.name ?? '';
        email.text = profileData.data!.email ?? '';
        mobile.text = profileData.data!.mobile.toString() ?? '';
        date.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(profileData.data!.dob ?? ''));
        _character = profileData.data!.gender ?? 'Male';
        address.text = profileData.data!.address ?? '';
        country.text = profileData.data!.country ?? '';
        _selectedState = profileData.data!.state ?? '';
        _selectedCity = profileData.data!.city ?? '';
        pincode.text = profileData.data!.pincode.toString() ?? '';
        _profilePhotoUrl = profileData.data!.profilePhoto ?? '';
      });
      cityData(_selectedState!); // Load cities based on the selected state
    }
  }
  bool _isValidEmail(String email) {
    // Simple regex for email validation
    final RegExp regex =     RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    // RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
  void edit(String name, String email, String mobile, String date, String address, String country, String state, String city, String pincode) async {
    // Your existing edit function here...
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }
    if (selectedDate != null) {
      int age = DateTime.now().year - selectedDate!.year;
      if (DateTime.now().month < selectedDate!.month || (DateTime.now().month == selectedDate!.month && DateTime.now().day < selectedDate!.day)) {
        // If the birthday hasn't occurred yet this year
        age--;
      }
      if (age < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are not 18+")),
        );
        return;
      }
    }

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('https://batting-api-1.onrender.com/api/user/updateUser'),
      );

      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        "Authorization": "$token",
      });

      request.fields['name'] = name ;
      request.fields['email'] = email;
      request.fields['mobile'] = mobile;
      // request.fields['dob'] = date;
      if (selectedDate != null) {
        request.fields['dob'] = DateFormat('yyyy-MM-dd').format(selectedDate!);
      }
      request.fields['address'] = address;
      request.fields['city'] = city;
      request.fields['pincode'] = pincode;
      request.fields['state'] = state;
      request.fields['country'] = country;

      if (_imageFile != null) {

        request.files.add(await http.MultipartFile.fromPath(
          'profile_photo',
          _imageFile!.path,

        ));
      }

      final response = await request.send();
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile name cannot be empty")),
        );
        return;
      }
      if (name.length > 17) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Name cannot be longer than 17 characters")),
        );
        return;
      }

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Edit Successful")),
        );
        debugPrint("Profile update response data: $data");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));

        Navigator.pop(context,true);
      }


      else {
        var responseBody = await response.stream.bytesToString();
        debugPrint("Profile update failed: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Edit failed')),
        );
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(68.0.h),
        child: AppBar(
          leading: Container (),
          surfaceTintColor: const Color(0xffF0F1F5),
          backgroundColor: const Color(0xffF0F1F5),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            height: 110,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff140B40),
                  Color(0xff140B40),
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context,true);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Center(child: AppBarText(color: Colors.white, text: "Edit Profile")),
                    InkWell(
                      onTap: () {
                        if (name.text.isNotEmpty &&
                            email.text.isNotEmpty &&
                            mobile.text.isNotEmpty &&
                            date.text.isNotEmpty &&
                            address.text.isNotEmpty &&
                            country.text.isNotEmpty &&
                            (_selectedState ?? '').isNotEmpty &&
                            (_selectedCity ?? '').isNotEmpty &&
                            pincode.text.isNotEmpty) {
                          // Call the edit function if all fields are valid
                          edit(
                            name.text.toString(),
                            email.text.toString(),
                            mobile.text.toString(),
                            date.text.toString(),
                            address.text.toString(),
                            country.text.toString(),
                            _selectedState ?? '',
                            _selectedCity ?? '',
                            pincode.text.toString(),
                          );
                        } else {
                          // Find which fields are empty and show an error message
                          String errorMessage = '';
                          if (name.text.isEmpty) {
                            errorMessage = "Please enter a name";
                          } else if (email.text.isEmpty) errorMessage = "Please enter an email";
                          else if (mobile.text.isEmpty) errorMessage = "Please enter a mobile number";
                          else if (date.text.isEmpty) errorMessage = "Please enter a date";
                          else if (address.text.isEmpty) errorMessage = "Please enter an address";
                          else if (country.text.isEmpty) errorMessage = "Please select a country";
                          else if ((_selectedState ?? '').isEmpty) errorMessage = "Please select a state";
                          else if ((_selectedCity ?? '').isEmpty) errorMessage = "Please select a city";
                          else if (pincode.text.isEmpty) errorMessage = "Please enter a pincode";

                          // Show the appropriate error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }


                      },
                      child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        color: const Color(0xffF0F1F5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 110,
                        width: 110,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55),
                          border: Border.all(color: const Color(0xff140B40)),
                        ),
                        child:

                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: _imageFile != null
                              ? Image.file(
                            File(_imageFile!.path), // Display the selected local image
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/remove.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                              : (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty)
                              ? Image.network(
                            _profilePhotoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/remove.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                              : Image.asset(
                            'assets/remove.png',
                            fit: BoxFit.cover,
                          ),
                        ),

                      ),
                      Positioned(
                        right: 0,
                        top: 6,
                        child: Image.asset(
                          'assets/editP.png',
                          height: 20,
                          color: const Color(0xff140B40),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Name"),
              const SizedBox(height: 5),
              _buildTextField(name),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Email"),
              const SizedBox(height: 5),
              _buildTextField(email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Mobile"),
              const SizedBox(height: 5),
              _buildTextField(mobile,isEditable: false,maxLength: 10, keyboardType: TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly],),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Date of Birth"),
              const SizedBox(height: 5),
              _buildDateField(date),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Gender"),
              const SizedBox(height: 5),
              _buildGenderField(),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Address"),
              const SizedBox(height: 5),
              SizedBox(height: 120,
                  child: _buildTextField(address,maxLine: 4)),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Country"),
              const SizedBox(height: 5),
              _buildTextField(country,isEditable: false),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "State"),
              const SizedBox(height: 5),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonFormField(
                  hint: Text(_selectedState ?? '', style: const TextStyle(fontWeight: FontWeight.w400 ,color: Colors.black,fontSize: 14),),

                  //value: _selectedState,
                  value: _state.contains(_selectedState) ? _selectedState : null,

                  items: _state
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedState = val as String;
                      _city.clear();
                      _selectedCity = null;
                      cityData(val);
                    });
                  },
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.black,
                    // color: Color.fromRGBO(197, 197, 197, 1),
                    fontSize: 14,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(197, 197, 197, 1),
                  ),
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration(
                    // Use InputDecoration.none to remove the underline
                    border: InputBorder.none,
                    // You can also set other properties if needed
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 5),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "City"),
              const SizedBox(height: 5),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonFormField(

                  hint: Text(_selectedCity ?? '',style: const TextStyle(color: Colors.black,fontSize: 16),),
                  value:  _city.contains(_selectedCity) ? _selectedCity : null,

                  // value: _selectedCity,
                  items: _city
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCity = val as String;
                    });
                  },
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.black,
                    // color: Color.fromRGBO(197, 197, 197, 1),
                    fontSize: 14,

                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(197, 197, 197, 1),
                  ),
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration(
                    // Use InputDecoration.none to remove the underline
                    border: InputBorder.none,
                    // You can also set other properties if needed
                    contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 5),
                  ),                  // decoration:
                ),
              ),
              const SizedBox(height: 15),
              SmallText(color: Colors.grey, text: "Pincode"),
              const SizedBox(height: 5),
              _buildTextField(pincode, keyboardType: TextInputType.number, maxLength: 6,inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {TextInputType keyboardType = TextInputType.text, bool obscureText = false, int? maxLength,int? maxLine,List<TextInputFormatter>? inputFormatters, bool isEditable = true,}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        maxLines: null,
        inputFormatters: inputFormatters,
        expands: true,// Allows the text field to expand vertically
        enabled: isEditable,
        decoration: const InputDecoration(
          // contentPadding: EdgeInsets.only(bottom: 5, left: 10, top: 10), // Padding for the text inside the field
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Adjusted padding for better appearance
          // contentPadding: EdgeInsets.only(bottom: 5, left: 10),
          border: InputBorder.none,
          counterText: "",
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              selectedDate = pickedDate;
              controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
            });
          }
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: IgnorePointer(
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  controller: controller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 12, left: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.date_range,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildGenderField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xff140B40),
              value: "Male",
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  _character = value;
                });
              },
            ),
            const Text('Male'),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xff140B40),
              value: "Female",
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  _character = value;
                });
              },
            ),
            const Text('Female'),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = image;
          _profilePhotoUrl = _imageFile!.path; // Update the profile photo URL to the new image path
        });
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  Future<ProfileDisplay?> profileDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse('https://batting-api-1.onrender.com/api/user/userDetails'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );

      if (response.statusCode == 200) {
        final data = ProfileDisplay.fromJson(jsonDecode(response.body.toString()));
        print("this is all data ${response.body}");
        debugPrint('data ${data.message}');
        return data;
      } else {
        print("heloooooooooooooooooooooooooo${response.body}");
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
      return null;
    }
  }
}



// if(name == null){
//   edit(
//     name.text.toString(),
//     email.text.toString(),
//     mobile.text.toString(),
//     date.text.toString(),
//     address.text.toString(),
//     country.text.toString(),
//     _selectedState ?? '',
//     _selectedCity ?? '',
//     pincode.text.toString(),
//   );
// }else{
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text("Please enter a name")),
//   );
// }
// ClipRRect(
//   borderRadius: BorderRadius.circular(50),
//   child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
//       ? Image.network(
//     _profilePhotoUrl!,
//     fit: BoxFit.cover,
//     errorBuilder: (context, error, stackTrace) {
//       // Show 'remove.png' image if there's an error loading the profile photo
//       return Image.asset(
//         'assets/remove.png',
//         fit: BoxFit.cover,
//       );
//     },
//   )
//       : Image.asset(
//     'assets/remove.png',
//     fit: BoxFit.cover,
//   ),
// ),
// ClipRRect(
//   borderRadius: BorderRadius.circular(50),
//   child: _imageFile != null
//       ? Image.file(
//     File(_imageFile!.path),
//     fit: BoxFit.cover,
//   )
//       : (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty)
//       ? Image.network(
//     _profilePhotoUrl!,
//     fit: BoxFit.cover,
//   )
//       : Image.asset(
//     'assets/remove.png',
//     fit: BoxFit.cover,
//   ),
// ),
// Widget _buildDateField(TextEditingController controller) {
//   return Container(
//     height: 45,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border.all(color: Colors.grey.shade400, width: 1.0),
//       borderRadius: BorderRadius.circular(10.0),
//     ),
//     child: GestureDetector(
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(1900),
//           lastDate: DateTime.now(),
//         );
//         if (pickedDate != null) {
//           setState(() {
//             selectedDate = pickedDate;
//             controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//           });
//         }
//       },
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: IgnorePointer(
//               child: TextFormField(
//                 textAlignVertical: TextAlignVertical.center,
//                 textAlign: TextAlign.left,
//                 controller: controller,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.only(bottom: 12, left: 10),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Icon(
//               Icons.date_range,
//               color: Colors.grey.shade400,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildGenderField() {
//   return Row(
//     children: [
//       Expanded(
//         child: ListTile(
//           title: const Text('Male'),
//           leading: Radio<String>(
//             activeColor: const Color(0xff140B40),
//             value: "Male",
//             groupValue: _character,
//             onChanged: (value) {
//               setState(() {
//                 _character = value;
//               });
//             },
//           ),
//         ),
//       ),
//       Expanded(
//         child: ListTile(
//           title: const Text('Female'),
//           leading: Radio<String>(
//             activeColor: const Color(0xff140B40),
//             value: "Female",
//             groupValue: _character,
//             onChanged: (value) {
//               setState(() {
//                 _character = value;
//               });
//             },
//           ),
//         ),
//       ),
//     ],
//   );
// }
// Future<void> _pickImage() async {
//   final ImagePicker _picker = ImagePicker();
//   try {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _imageFile = image;
//       });
//     }
//   } catch (e) {
//     print('Image picker error: $e');
//   }
// }
// Container(
//     decoration: BoxDecoration(
//       color: Colors.white, // White background
//       borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           blurRadius: 5,
//           spreadRadius: 2,
//           offset: const Offset(0, 3), // changes position of shadow
//         ),
//       ],
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//   child: DropdownButtonFormField<String>(
//     isExpanded: true,
//     value: _selectedState,
//     decoration: InputDecoration(
//       contentPadding: const EdgeInsets.only(bottom: 10),
//       border: InputBorder.none, // Remove default border
//       // You can customize hint text style here if you want
//       hintText: _selectedState,
//       hintStyle: const TextStyle(color: Colors.grey),
//     ),
//     items: _state.map((String value) {
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList(),
//     onChanged: (newValue) {
//       setState(() {
//         _selectedState = newValue;
//         _selectedCity = null;
//         cityData(newValue!);
//       });
//     },
//   ),
// ),

// const Icon(
//   Icons.location_on_rounded,
//   color: Colors.black,
// ),
// SizedBox(width: 2),
// const Text(
//   "State",
//   style: TextStyle(
//     fontFamily: "Roboto",
//     color: Colors.black,
//     fontSize: 12,
//   ),
// )

// SizedBox(
//   height: 0.5,
// ),

// decoration: InputDecoration(
//   filled: true,
//   fillColor: Colors.white,
//   contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//   focusedBorder: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(15),
//     borderSide: const BorderSide(
//       // color: Colors.white,
//     ),
//   ),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(15),
//     borderSide: const BorderSide(
//       color: Color.fromRGBO(234, 233, 234, 1),
//     ),
//   ),
// ),

// Container(
//     decoration: BoxDecoration(
//       color: Colors.white, // White background
//       borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           blurRadius: 5,
//           spreadRadius: 2,
//           offset: const Offset(0, 3), // changes position of shadow
//         ),
//       ],
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//   child: DropdownButtonFormField<String>(
//     isExpanded: true ,
//     value: _selectedCity,
//     decoration: InputDecoration(
//       contentPadding: const EdgeInsets.only(bottom: 10),
//       border: InputBorder.none, // Remove default border
//       // You can customize hint text style here if you want
//       hintText: _selectedCity,
//       hintStyle: const TextStyle(color: Colors.grey),
//     ),
//     items: _city.map((String value) {
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList(),
//     onChanged: (newValue) {
//       setState(() {
//         _selectedCity = newValue;
//       });
//     },
//   ),
// ),

// SizedBox(
//   height: 0.5,
// ),
// InputDecoration(
//   filled: true,
//   fillColor: Colors.white,
//   contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//   focusedBorder: OutlineInputBorder(
//     // borderRadius: BorderRadius.circular(15),
//     borderSide: const BorderSide(
//       // color: buttonblue,
//     ),
//   ),
//   border: OutlineInputBorder(
//     // borderRadius: BorderRadius.circular(15),
//     // borderSide: const BorderSide(
//     //   // color: Color.fromRGBO(234, 233, 234, 1),
//     // ),
//   ),
// ),
//
//   Future<String> loadData() async {
//     var data = await rootBundle.loadString("assets/CountryStateCity.json");
//     Map<String, dynamic> countryData = json.decode(data);
//
//     String countryName = "India";
//     String stateName = "Gujarat";
//     var country = countryData["data"].firstWhere((c) => c["name"] == countryName, orElse: () => null);
//
//     if (country != null) {
//       // Find the specified state within the country
//       // var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
//       if (country != null) {
//         // var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
//         List<dynamic> stateDynamic = country["states"];
//         print(stateDynamic.toString());
//         List<String> stateList = stateDynamic.map((e) => e['name'].toString()).toList();
//         setState(() {
//           _state = stateList.toList();
//         });
//         // if (state != null) {
//         //   // Extract the list of cities from the state
//         //   List<dynamic> cities = state["cities"];
//         //
//         //   // Extract city names from the list
//         //   List<String> cityNames = cities.map((city) => city["name"].toString()).toList();
//         //   setState(() {
//         //     _city = cityNames.toList();
//         //
//         //   });
//         //   print("Cities in $stateName, $countryName: $cityNames");
//         // } else {
//         //   print("State $stateName not found in $countryName.");
//         // }
//       } else {
//         print("Country $countryName not found.");
//       }
//     }
//     return "success";
//   }
//
//   Future<String> cityData(String stateName) async {
//     var data = await rootBundle.loadString("assets/CountryStateCity.json");
//     // setState(() {
//     //   cityList = json.decode(data);
//     // });
//     print("jfbsdjgbjfb$stateName");
//     Map<String, dynamic> countryData = json.decode(data);
//
// // Specify the country name and state name for which you want the city data
//     String countryName = "India";
//     // String stateName = "Gujarat";
//
// // Find the specified country
//     var country = countryData["data"].firstWhere((c) => c["name"] == countryName, orElse: () => null);
//
//     if (country != null) {
//       // Find the specified state within the country
//       var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
//
//       if (state != null) {
//         // Extract the list of cities from the state
//         List<dynamic> cities = state["cities"];
//
//         // Extract city names from the list
//         List<String> cityNames = cities.map((city) => city["name"].toString()).toList();
//         setState(() {
//           _city = cityNames.toList();
//         });
//         print("123Cities in $stateName, $countryName: $cityNames");
//       } else {
//         print("12State $stateName not found in $countryName.");
//       }
//     } else {
//       print("1Country $countryName not found.");
//     }
//
//     return "success";
//   }

// Future<void> loadData() async {
//   var data = await rootBundle.loadString("assets/CountryStateCity.json");
//   Map<String, dynamic> countryData = json.decode(data);
//   String countryName = "India";
//
//   var country = countryData["data"].firstWhere((c) => c["name"] == countryName, orElse: () => null);
//   if (country != null) {
//     List<dynamic> stateDynamic = country["states"];
//     List<String> stateList = stateDynamic.map((e) => e['name'].toString()).toList();
//     setState(() {
//       _state = stateList;
//     });
//   }
// }
//
// Future<void> cityData(String stateName) async {
//   var data = await rootBundle.loadString("assets/CountryStateCity.json");
//   Map<String, dynamic> countryData = json.decode(data);
//   String countryName = "India";
//
//   var country = countryData["data"].firstWhere((c) => c["name"] == countryName, orElse: () => null);
//   if (country != null) {
//     var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
//     if (state != null) {
//       List<dynamic> cities = state["cities"];
//       List<String> cityNames = cities.map((city) => city["name"].toString()).toList();
//       setState(() {
//         _city = cityNames;
//       });
//     }
//   }
// }
// Future<void> loadData() async {
//   var data = await rootBundle.loadString("assets/CountryStateCity.json");
//   Map<String, dynamic> countryData = json.decode(data);
//   String countryName = "India";
//
//   // Check if countryData["data"] is a List
//   List<dynamic> countries = countryData["data"];
//   var country = countries.firstWhere((c) => c["name"] == countryName, orElse: () => null);
//   if (country != null) {
//     List<dynamic> stateDynamic = country["states"];
//     List<String> stateList = stateDynamic.map((e) => e['name'].toString()).toList();
//     setState(() {
//       _state = stateList;
//     });
//   }
// }
//
// Future<void> cityData(String stateName) async {
//   var data = await rootBundle.loadString("assets/CountryStateCity.json");
//   Map<String, dynamic> countryData = json.decode(data);
//   String countryName = "India";
//
//   List<dynamic> countries = countryData["data"];
//   var country = countries.firstWhere((c) => c["name"] == countryName, orElse: () => null);
//   if (country != null) {
//     // Ensure that states is a List
//     var state = (country["states"] as List).firstWhere((s) => s["name"] == stateName, orElse: () => null);
//     if (state != null) {
//       List<dynamic> cities = state["cities"];
//       List<String> cityNames = cities.map((city) => city["name"].toString()).toList();
//       setState(() {
//         _city = cityNames;
//       });
//     }
//   }
// }





// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart'; // Import the intl package for date formatting
// import 'package:batting_app/screens/Profile.dart';
// import 'package:batting_app/screens/settingscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import '../db/app_db.dart';
// import '../model/ProfileDisplay.dart';
// import '../widget/appbartext.dart';
// import '../widget/smalltext.dart';
// import 'country/selection.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   DateTime? selectedDate; // To store the selected date
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController mobile = TextEditingController();
//   TextEditingController date = TextEditingController();
//   // TextEditingController password = TextEditingController();
//   TextEditingController address = TextEditingController();
//   TextEditingController country = TextEditingController();
//   // TextEditingController state = TextEditingController();
//   // TextEditingController city = TextEditingController();
//   TextEditingController pincode = TextEditingController();
//   LocationSelection locationSelection = LocationSelection();
//
//   String? _selectedCity;
//   String? _selectedState;
//   List<String> _city = [];
//   List<String> _state = [];
//   // String? _selectedCountry;
//   // String? _selectedState;
//   // String? _selectedCity;
//   // List<String> _countries = [];
//   // List<String> _states = [];
//   // List<String> _cities = [];
//
//   XFile? _imageFile;
//   String? _selectedGender;
//   late DateTime pickedDate;
//   String selectedDateText = "";
//   String? _character = "Male";
//   String? _profilePhotoUrl;
//
//
//   void edit(
//       String name,
//       String email,
//       String mobile,
//       String date,
//       String address,
//       String country,
//       String state,
//       String city,
//       String pincode,
//       ) async {
//     try {
//       var request = http.MultipartRequest(
//         'PUT',
//         Uri.parse('https://batting-api-1.onrender.com/api/user/updateUser'),
//       );
//
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token $token');
//
//       request.headers.addAll({
//         'Content-Type': 'multipart/form-data',
//         'Accept': 'application/json',
//         "Authorization": "$token",
//       });
//
//       request.fields['name'] = name ;
//       request.fields['email'] = email;
//       request.fields['mobile'] = mobile;
//       // request.fields['dob'] = date;
//       if (selectedDate != null) {
//         request.fields['dob'] = DateFormat('yyyy-MM-dd').format(selectedDate!);
//       }
//       request.fields['address'] = address;
//       request.fields['city'] = city;
//       request.fields['pincode'] = pincode;
//       request.fields['state'] = state;
//       request.fields['country'] = country;
//
//       if (_imageFile != null) {
//
//         request.files.add(await http.MultipartFile.fromPath(
//           'profile_photo',
//           _imageFile!.path,
//
//         ));
//       }
//
//       final response = await request.send();
//       if (name == null || name.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile name cannot be empty")),
//         );
//         return;
//       }
//       if (name.length > 17) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Name cannot be longer than 17 characters")),
//         );
//         return;
//       }
//
//       if (response.statusCode == 200) {
//         var responseBody = await response.stream.bytesToString();
//         var data = jsonDecode(responseBody.toString());
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile Edit Successful")),
//
//
//         );
//         debugPrint("Profile update response data: $data");
//
//       }
//
//
//       else {
//         var responseBody = await response.stream.bytesToString();
//         debugPrint("Profile update failed: $responseBody");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile Edit failed')),
//         );
//       }
//     } catch (e) {
//       debugPrint('Error updating profile: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // _loadCountries();
//     _loadProfileData();
//     loadData();cityData(_s);
//
//   }
//   List<String>? cityList;
//   Future<String> loadData() async {
//     var data = await rootBundle.loadString("assets/CountryStateCity.json");
//     Map<String, dynamic> countryData = json.decode(data);
//
//     String countryName = "India";
//     String stateName = "Gujarat";
//     var country = countryData["data"].firstWhere((c) => c["name"] == countryName, orElse: () => null);
//
//     if (country != null) {
//       // Find the specified state within the country
//       // var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
//       if (country != null) {
//         // var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
//         List<dynamic> stateDynamic = country["states"];
//         print(stateDynamic.toString());
//         List<String> stateList = stateDynamic.map((e) => e['name'].toString()).toList();
//         setState(() {
//           _state = stateList.toList();
//         });
//         // if (state != null) {
//         //   // Extract the list of cities from the state
//         //   List<dynamic> cities = state["cities"];
//         //
//         //   // Extract city names from the list
//         //   List<String> cityNames = cities.map((city) => city["name"].toString()).toList();
//         //   setState(() {
//         //     _city = cityNames.toList();
//         //
//         //   });
//         //   print("Cities in $stateName, $countryName: $cityNames");
//         // } else {
//         //   print("State $stateName not found in $countryName.");
//         // }
//       } else {
//         print("Country $countryName not found.");
//       }
//     }
//     return "success";
//   }
//
//   Future<String> cityData(String stateName) async {
//     var data = await rootBundle.loadString("assets/CountryStateCity.json");
//     // setState(() {
//     //   cityList = json.decode(data);
//     // });
//     print("jfbsdjgbjfb$stateName");
//     Map<String, dynamic> countryData = json.decode(data);
//
// // Specify the country name and state name for which you want the city data
//     String countryName = "India";
//     // String stateName = "Gujarat";
//
// // Find the specified country
//     var country = countryData["data"].firstWhere((c) => c["name"] == countryName, orElse: () => null);
//
//     if (country != null) {
//       // Find the specified state within the country
//       var state = country["states"].firstWhere((s) => s["name"] == stateName, orElse: () => null);
//
//       if (state != null) {
//         // Extract the list of cities from the state
//         List<dynamic> cities = state["cities"];
//
//         // Extract city names from the list
//         List<String> cityNames = cities.map((city) => city["name"].toString()).toList();
//         setState(() {
//           _city = cityNames.toList();
//         });
//         print("123Cities in $stateName, $countryName: $cityNames");
//       } else {
//         print("12State $stateName not found in $countryName.");
//       }
//     } else {
//       print("1Country $countryName not found.");
//     }
//
//     return "success";
//   }
//
//   // Future<void> _loadCountries() async {
//   //   await locationSelection.countryNameList();
//   //   // _states = await locationSelection.stateNameList(country);
//   //   setState(() {
//   //     setState(() {
//   //       _states = locationSelection.stateNameList("India");
//   //     });
//   //   });
//   // }
//   //
//   // void _onCountryChanged(String? country) {
//   //   setState(() {
//   //     // _selectedCountry = country;
//   //     _states = LocationSelection().stateNameList(country!);
//   //     _selectedState = null; // Reset state and city when country changes
//   //     _selectedCity = null;
//   //   });
//   // }
//   //
//   // void _onStateChanged(String? state) {
//   //   setState(() {
//   //     _selectedState = state;
//   //     _cities = LocationSelection().cityNameList(state!);
//   //     _selectedCity = null; // Reset city when state changes
//   //   });
//   // }
//   // Future<void> _loadProfileData() async {
//   //   ProfileDisplay? profileData = await profileDisplay();
//   //   if (profileData != null) {
//   //     setState(() {
//   //       name.text = profileData.data!.name ?? '';
//   //       email.text = profileData.data!.email ?? '';
//   //       mobile.text = profileData.data!.mobile.toString() ?? '';
//   //       date.text = DateFormat('dd-MM-yyyy').format(
//   //         DateTime.parse(profileData.data!.dob ?? ''),
//   //       );
//   //       _character = profileData.data!.gender ?? 'Male';
//   //       address.text = profileData.data!.address ?? '';
//   //       country.text = profileData.data!.country ?? '';
//   //
//   //       // _selectedCountry = profileData.data!.country ?? '';
//   //       _selectedState = profileData.data!.state ?? '';
//   //       _selectedCity = profileData.data!.city ?? '';
//   //       pincode.text = profileData.data!.pincode.toString() ?? '';
//   //       _profilePhotoUrl = profileData.data!.profilePhoto ?? '';
//   //     });
//   //     _loadStatesAndCities();
//   //   }
//   // }
//   // Future<void> _loadStatesAndCities() async {
//   //   // if (_selectedCountry != null) {
//   //   //   _states = LocationSelection().stateNameList(_selectedCountry!);
//   //   // }
//   //   if (_selectedState != null) {
//   //     _cities = LocationSelection().cityNameList(_selectedState!);
//   //   }
//   //   setState(() {});
//   // }
//
//   Future<void> _loadProfileData() async {
//     ProfileDisplay? profileData = await profileDisplay();
//
//     if (profileData != null) {
//       setState(() {
//
//         name.text = profileData.data!.name ?? '';
//         email.text = profileData.data!.email ?? '';
//         mobile.text = profileData.data!.mobile.toString() ?? '';
//         // date.text = profileData.data!.dob ?? '';
//         date.text = DateFormat('dd-MM-yyyy').format(
//           DateTime.parse(profileData.data!.dob ?? ''),
//         );
//         _character = profileData.data!.gender ?? 'Male';
//         // password.text = profileData.data!.password ?? '';
//         address.text = profileData.data!.address ?? '';
//         country.text = profileData.data!.country ?? '';
//         _selectedState = profileData.data!.state ?? '';
//         // state.text = profileData.data!.state ?? '';
//         _selectedCity = profileData.data!.city ?? '';
//         // city.text = profileData.data!.city ?? '';
//         pincode.text = profileData.data!.pincode.toString() ?? '';
//         _profilePhotoUrl = profileData.data!.profilePhoto ?? '';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70.0),
//         child: AppBar(
//           leading: Container(),
//           surfaceTintColor: const Color(0xffF0F1F5),
//           backgroundColor: const Color(0xffF0F1F5),
//           elevation: 0,
//           centerTitle: true,
//           flexibleSpace: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//             height: 100,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xff1D1459),
//                   Color(0xff140B40),
//                 ],
//               ),
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                     AppBarText(color: Colors.white, text: "Edit Profile"),
//                     InkWell(
//                       onTap: () {
//
//                         edit(
//                           name.text.toString(),
//                           email.text.toString(),
//                           mobile.text.toString(),
//                           date.text.toString(),
//                           address.text.toString(),
//                           country.text.toString(),
//                           state.text.toString(),
//                           city.text.toString(),
//                           // _selectedCountry ?? '',
//                           // _selectedState ?? '',
//                           // _selectedCity ?? '',
//                           pincode.text.toString(),
//                         );
//
//                       },
//
//                       // child: SmallText(color: Colors.white, text: "Save"),
//                       child: Text('Save',style: TextStyle(color: Colors.white,fontSize: 15),),
//
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         height: MediaQuery.of(context).size.height,
//         color: const Color(0xffF0F1F5),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20),
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     _pickImage();
//                   },
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: 110,
//                         width: 110,
//                         padding: const EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(55),
//                           border: Border.all(color: const Color(0xff140B40)),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: _imageFile != null
//                               ? Image.file(
//                             File(_imageFile!.path),
//                             fit: BoxFit.cover,
//                           )
//                               : (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty)
//                               ? Image.network(
//                             _profilePhotoUrl!,
//                             fit: BoxFit.cover,
//                           )
//                               : Image.asset(
//                             'assets/remove.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 0,
//                         top: 15,
//                         child: Image.asset(
//                           'assets/editP.png',
//                           height: 20,
//                           color: const Color(0xff140B40),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Name"),
//
//               SizedBox(height: 5),
//               _buildTextField(name),
//
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Email"),
//               SizedBox(height: 5),
//               _buildTextField(email, keyboardType: TextInputType.emailAddress),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Mobile"),
//               SizedBox(height: 5),
//               _buildTextField(mobile, keyboardType: TextInputType.number),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Date of Birth"),
//               SizedBox(height: 5),
//               _buildDateField(date),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Gender"),
//               SizedBox(height: 5),
//               _buildGenderField(),
//               SizedBox(height: 15),
//               // SmallText(color: Colors.grey, text: "Password"),
//               // SizedBox(height: 5),
//               // _buildTextField(password, obscureText: true),
//               // SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Address"),
//               SizedBox(height: 5),
//               _buildTextField(address),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Country"),
//               SizedBox(height: 5),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Country"),
//               SizedBox(height: 5),
//               // // _buildDropdown(
//               // //   _countries,
//               // //   _selectedCountry,
//               // //       (value) => _onCountryChanged(value),
//               // // ),
//               // SmallText(color: Colors.grey, text: "State"),
//               // SizedBox(height: 15),
//               // SmallText(color: Colors.grey, text: "State"),
//               // SizedBox(height: 5),
//               // _buildDropdown(
//               //   _states,
//               //   _selectedState,
//               //       (value) => _onStateChanged(value),
//               // ),
//               // SizedBox(height: 15),
//               // SmallText(color: Colors.grey, text: "City"),
//               // SizedBox(height: 5),
//               // _buildDropdown(
//               //   _cities,
//               //   _selectedCity,
//               //       (value) => setState(() => _selectedCity = value),
//               // ),
//               _buildTextField(country),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "State"),
//               SizedBox(height: 5),
//               _buildTextField(state),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "City"),
//               SizedBox(height: 5),
//               _buildTextField(city),
//               SizedBox(height: 15),
//               SmallText(color: Colors.grey, text: "Pincode"),
//               SizedBox(height: 5),
//               _buildTextField(pincode, keyboardType: TextInputType.number,maxLength: 6),
//               SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, {TextInputType keyboardType = TextInputType.text, bool obscureText = false,int? maxLength}) {
//     return Container(
//       // alignment: Alignment.center,
//       height: 44,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(
//           color: Colors.grey.shade400,
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: TextFormField(
//
//         cursorColor: Colors.black,
//         // textAlignVertical: TextAlignVertical.center,
//         // textAlign: TextAlign.left,
//         // textAlign: TextAlign.left,
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         maxLength: maxLength, // Set the max length here
//         decoration: const InputDecoration(
//           contentPadding: EdgeInsets.only(bottom: 5, left: 10),
//           border: InputBorder.none,
//           counterText: "", // Disable counter text
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateField(TextEditingController controller) {
//     return Container(
//       // alignment: Alignment.center,
//       height: 45,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(
//           color: Colors.grey.shade400,
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: GestureDetector(
//         onTap: () async {
//           DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(1900),
//             lastDate: DateTime.now(),
//           );
//           if (pickedDate != null) {
//             setState(() {
//               selectedDate = pickedDate;
//
//               // Format and display the date as dd-MM-yyyy
//               controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//               // controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//               // controller.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
//             });
//           }
//         },
//         child: Row(
//
//           children: <Widget>[
//             Expanded(
//               child: IgnorePointer(
//                 child: TextFormField(
//                   textAlignVertical: TextAlignVertical.center,
//                   textAlign: TextAlign.left,
//                   controller: controller,
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.only(bottom: 12, left: 10 ),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: Icon(
//                 Icons.date_range,
//                 color: Colors.grey.shade400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdown(List<String> items, String? selectedValue, Function(String?)? onChanged) {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade400, width: 1.0),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton(
//           isExpanded: true,
//           value: selectedValue,
//           onChanged: onChanged,
//           items: items.map((item) {
//             return DropdownMenuItem(
//               child: Text(item),
//               value: item,
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGenderField() {
//     return Row(
//       children: [
//         Expanded(
//           child: ListTile(
//             title: const Text('Male'),
//             leading: Radio<String>(
//               activeColor: const Color(0xff140B40),
//               value: "Male",
//               groupValue: _character,
//               onChanged: (value) {
//                 setState(() {
//                   _character = value;
//                 });
//               },
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListTile(
//             title: const Text('Female'),
//             leading: Radio<String>(
//               activeColor: const Color(0xff140B40),
//               value: "Female",
//               groupValue: _character,
//               onChanged: (value) {
//                 setState(() {
//                   _character = value;
//                 });
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//
//       if (image != null) {
//         setState(() {
//           _imageFile = image;
//         });
//       }
//     } catch (e) {
//       print('Image picker error: $e');
//     }
//   }
//
//   Future<ProfileDisplay?> profileDisplay() async {
//     try {
//       String? token = await AppDB.appDB.getToken();
//       debugPrint('Token $token');
//
//       final response = await http.get(
//         Uri.parse('https://batting-api-1.onrender.com/api/user/userDetails'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "$token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = ProfileDisplay.fromJson(jsonDecode(response.body.toString()));
//         print("this is all data ${response.body}");
//         debugPrint('data ${data.message}');
//         return data;
//
//       } else {
//         print("heloooooooooooooooooooooooooo${response.body}");
//         debugPrint('Failed to fetch profile data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching profile data: $e');
//       return null;
//     }
//   }
// }
//
