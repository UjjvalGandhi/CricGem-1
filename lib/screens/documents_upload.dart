import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../db/app_db.dart';
import 'package:http/http.dart' as http;
import '../widget/appbar_for_setting.dart';
import '../widget/getdocuments.dart';

class DocumentsUploadScreen extends StatefulWidget {
  const DocumentsUploadScreen({super.key});

  @override
  State<DocumentsUploadScreen> createState() => _DocumentsUploadScreenState();
}

class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  // These will store the File for local images
  File? _aadhaarFrontImage;
  File? _aadhaarBackImage;
  File? _panFrontImage;
  File? _panBackImage;

  String? aadharcardstatus;
  String? pancardstatus;

  // These will store the URLs for images
  String? _aadhaarFrontImageUrl;
  String? _aadhaarBackImageUrl;
  String? _panFrontImageUrl;
  String? _panBackImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchAndPopulateData();
  }

  Future<void> _fetchAndPopulateData() async {
    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    await documentProvider.fetchDocumentDetails();

    setState(() {
      if (documentProvider.documentDetails != null) {
        final details = documentProvider.documentDetails!.data;
        _aadhaarController.text = details.adhaarCardNum.toString();
        _panController.text = details.panCardNum;
        _aadhaarFrontImageUrl = details.adhaarCardFrontPhoto;
        _aadhaarBackImageUrl = details.adhaarCardBackPhoto;
        _panFrontImageUrl = details.panCardFrontPhoto;
        _panBackImageUrl = details.panCardBackPhoto;
        aadharcardstatus = details.adhaarCardStatus;
        pancardstatus = details.panCardStatus;
      } else {
        // Set default statuses when no documents are found
        aadharcardstatus = 'not_uploaded';
        pancardstatus = 'not_uploaded';
        // Clear any existing data
        _aadhaarController.clear();
        _panController.clear();
        _aadhaarFrontImageUrl = null;
        _aadhaarBackImageUrl = null;
        _panFrontImageUrl = null;
        _panBackImageUrl = null;
      }
    });
  }
  // Future<void> _fetchAndPopulateData() async {
  //   final documentProvider =
  //       Provider.of<DocumentProvider>(context, listen: false);
  //   await documentProvider.fetchDocumentDetails();
  //
  //   if (documentProvider.documentDetails != null) {
  //     final details = documentProvider.documentDetails!.data;
  //
  //     _aadhaarController.text = details.adhaarCardNum.toString();
  //     _panController.text = details.panCardNum;
  //
  //     // Store image URLs as strings, not File objects
  //     setState(() {
  //       _aadhaarFrontImageUrl = details.adhaarCardFrontPhoto;
  //       _aadhaarBackImageUrl = details.adhaarCardBackPhoto;
  //       _panFrontImageUrl = details.panCardFrontPhoto;
  //       _panBackImageUrl = details.panCardBackPhoto;
  //       aadharcardstatus = details.adhaarCardStatus;
  //       pancardstatus = details.panCardStatus;
  //     });
  //   }
  // }

  Future<void> _pickImage(bool isFront, ImageSource source, String type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        final selectedImage = File(pickedFile.path);
        if (type == 'Aadhaar') {
          if (isFront) {
            _aadhaarFrontImage = selectedImage;
          } else {
            _aadhaarBackImage = selectedImage;
          }
        } else if (type == 'PAN') {
          if (isFront) {
            _panFrontImage = selectedImage;
          } else {
            _panBackImage = selectedImage;
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  String? _validateDocumentNumber(String value, String type) {
    if (type == 'Aadhaar') {
      if (!RegExp(r'^\d{12}$').hasMatch(value)) {
        return 'Please enter a valid 12-digit Aadhaar number.';
      }
    } else if (type == 'PAN') {
      if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
        return 'Please enter a valid PAN number (e.g., ABCDE1234F).';
      }
    }
    return null;
  }

  Future<void> _uploadDocuments(
    String aadhaarNumber,
    File aadhaarFront,
    File aadhaarBack,
    String panNumber,
    File panFront,
    File panBack,
  ) async {
    try {
      print('Upload clicked');
      String? token = await AppDB.appDB.getToken();
      var uri = Uri.parse(
          'https://batting-api-1.onrender.com/api/document/addDocument');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': '$token',
          'Accept': 'application/json',
        })
        ..fields['adhaar_card_num'] = aadhaarNumber
        ..fields['pan_card_num'] = panNumber
        ..files.add(await http.MultipartFile.fromPath(
            'adhaar_card_front_photo', aadhaarFront.path))
        ..files.add(await http.MultipartFile.fromPath(
            'adhaar_card_back_photo', aadhaarBack.path))
        ..files.add(await http.MultipartFile.fromPath(
            'pan_card_front_photo', panFront.path))
        ..files.add(await http.MultipartFile.fromPath(
            'pan_card_back_photo', panBack.path));

      print('path of the aadhar front:- ${aadhaarFront.path}');
      // print('path of the aadhar front:- ${aadhaarFront.path}');

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('response body :- $responseBody');
      print('response body :- ${response.statusCode}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documents uploaded successfully')),
        );
        setState(() {
          _aadhaarController.clear();
          _panController.clear();
          _aadhaarFrontImage = null;
          _aadhaarBackImage = null;
          _panFrontImage = null;
          _panBackImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading documents: $e')),
      );
    }
  }

  Future<void> _updateDocuments(
    String aadhaarNumber,
    File aadhaarFront,
    File aadhaarBack,
    String panNumber,
    File panFront,
    File panBack,
  ) async {
    try {
      print('Updated clicked');

      String? token = await AppDB.appDB.getToken();
      var uri =
          Uri.parse('https://batting-api-1.onrender.com/api/document/update');
      var request = http.MultipartRequest('PUT', uri)
        ..headers.addAll({
          'Authorization': '$token',
          'Accept': 'application/json',
        })
        ..fields['adhaar_card_num'] = aadhaarNumber
        ..fields['pan_card_num'] = panNumber
        ..files.add(await http.MultipartFile.fromPath(
            'adhaar_card_front_photo', aadhaarFront.path))
        ..files.add(await http.MultipartFile.fromPath(
            'adhaar_card_back_photo', aadhaarBack.path))
        ..files.add(await http.MultipartFile.fromPath(
            'pan_card_front_photo', panFront.path))
        ..files.add(await http.MultipartFile.fromPath(
            'pan_card_back_photo', panBack.path));

      print('path of the aadhar front:- ${aadhaarFront.path}');
      // print('path of the aadhar front:- ${aadhaarFront.path}');

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('response body :- $responseBody');
      print('response body :- ${response.statusCode}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documents Updated successfully')),
        );
        setState(() {
          _aadhaarController.clear();
          _panController.clear();
          _aadhaarFrontImage = null;
          _aadhaarBackImage = null;
          _panFrontImage = null;
          _panBackImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated failed: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Updated documents: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Documents Upload',
        onBackButtonPressed: () => Navigator.pop(context),
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, documentProvider, child) {
          if (documentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDocumentSection(
                    status: aadharcardstatus!,
                    title: 'Aadhaar Card',
                    controller: _aadhaarController,
                    frontImageUrl: _aadhaarFrontImageUrl,
                    backImageUrl: _aadhaarBackImageUrl,
                    frontImage: _aadhaarFrontImage,
                    backImage: _aadhaarBackImage,
                    type: 'Aadhaar',
                  ),
                  const SizedBox(height: 20),
                  _buildDocumentSection(
                    status: pancardstatus!,
                    title: 'PAN Card',
                    controller: _panController,
                    frontImageUrl: _panFrontImageUrl,
                    backImageUrl: _panBackImageUrl,
                    frontImage: _panFrontImage,
                    backImage: _panBackImage,
                    type: 'PAN',
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      final aadhaarError = _validateDocumentNumber(
                          _aadhaarController.text, 'Aadhaar');
                      final panError =
                          _validateDocumentNumber(_panController.text, 'PAN');

                      if (documentProvider.documentDetails != null) {
                        if (aadhaarError != null || panError != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(aadhaarError ?? panError!)),
                          );
                          return;
                        }
                        if (_aadhaarFrontImage == null ||
                            _aadhaarBackImage == null ||
                            _panFrontImage == null ||
                            _panBackImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'All Images are required for update.')),
                          );
                          return;
                        }
                        _updateDocuments(
                          _aadhaarController.text,
                          _aadhaarFrontImage!,
                          _aadhaarBackImage!,
                          _panController.text,
                          _panFrontImage!,
                          _panBackImage!,
                        );
                      } else {
                        if (aadhaarError != null || panError != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(aadhaarError ?? panError!)),
                          );
                          return;
                        }
                        if (_aadhaarFrontImage == null ||
                            _aadhaarBackImage == null ||
                            _panFrontImage == null ||
                            _panBackImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please upload all required images.')),
                          );
                          return;
                        }
                        _uploadDocuments(
                          _aadhaarController.text,
                          _aadhaarFrontImage!,
                          _aadhaarBackImage!,
                          _panController.text,
                          _panFrontImage!,
                          _panBackImage!,
                        );
                      }
                      print('Pressed upload button');
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xff140B40),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          documentProvider.documentDetails != null
                              ? 'Update Documents'
                              : 'Upload Documents',
                          // "Upload Documents",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDocumentSection({
    required String title,
    required TextEditingController controller,
    required String? frontImageUrl,
    required String? backImageUrl,
    required File? frontImage,
    required File? backImage,
    required String type,
    required String status, // Added status to display
  }) {
    // Determine the color based on the status
    Color statusColor = Colors.black;
    String statusText = '';
    bool canPickImage = true;

    if (status == 'rejected') {
      statusColor = Colors.red;
      statusText = 'Rejected';
    } else if (status == 'pending') {
      statusColor = Colors.yellow.shade900;
      statusText = 'Pending';
    } else if (status == 'approved') {
      statusColor = Colors.green;
      statusText = 'Approved';
      canPickImage = false; // Disable image picking for approved status
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for the document
        Text('$title Number',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        // Aadhaar/PAN Number input field
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            cursorColor: Colors.black,
            controller: controller,
            keyboardType:
                type == 'Aadhaar' ? TextInputType.number : TextInputType.text,
            maxLength: type == 'Aadhaar' ? 12 : 10,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 5, left: 10),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Front and Back Image section in a row
        Row(
          children: [
            // Front Image Section
            Expanded(
              child: Column(
                children: [
                  const Text('Front Image',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: canPickImage
                            ? () => _pickImage(true, ImageSource.gallery, type)
                            : null, // Disable image picking for approved
                        child: frontImageUrl != null
                            ? Image.network(
                                frontImageUrl,
                                height: 100,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildErrorPlaceholder(
                                      "Image not available");
                                },
                              )
                            : frontImage != null
                                ? Image.file(frontImage,
                                    height: 100, fit: BoxFit.cover)
                                : _buildPlaceholder(),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: canPickImage
                              ? () =>
                                  _pickImage(true, ImageSource.gallery, type)
                              : null, // Disable image picking for approved
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Back Image Section
            Expanded(
              child: Column(
                children: [
                  const Text('Back Image',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: canPickImage
                            ? () => _pickImage(false, ImageSource.gallery, type)
                            : null, // Disable image picking for approved
                        child: backImageUrl != null
                            ? Image.network(
                                backImageUrl,
                                height: 100,
                                fit: BoxFit.fill,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildErrorPlaceholder(
                                      "Image not available");
                                },
                              )
                            : backImage != null
                                ? Image.file(backImage,
                                    height: 100, fit: BoxFit.cover)
                                : _buildPlaceholder(),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: canPickImage
                              ? () =>
                                  _pickImage(false, ImageSource.gallery, type)
                              : null, // Disable image picking for approved
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Status Row - Aadhaar Card or PAN Card Status based on type
        // Center(
        //   child: Text(
        //     '$statusText',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       color: statusColor,
        //       fontSize: 16,
        //     ),
        //   ),
        // ),
        // type == 'Aadhaar'
        //     ?
        Center(
          child: RichText(
            text: TextSpan(
              text: 'Verification Status: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: statusText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor, // Apply the color based on status
                  ),
                ),
              ],
            ),
          ),
        )
        //     : Center(
        //   child: RichText(
        //     text: TextSpan(
        //       text: 'PAN Card Status: ',
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black,
        //       ),
        //       children: [
        //         TextSpan(
        //           text: statusText,
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             color: statusColor, // Apply the color based on status
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Widget _buildDocumentSection({
  //   required String title,
  //   required TextEditingController controller,
  //   required String? frontImageUrl,
  //   required String? backImageUrl,
  //   required File? frontImage,
  //   required File? backImage,
  //   required String type,
  //   required String status, // Added status to display
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Title for the document
  //       Text('$title Number', style: TextStyle(fontWeight: FontWeight.bold)),
  //       const SizedBox(height: 10),
  //
  //       // Aadhaar/PAN Number input field
  //       Container(
  //         height: 44,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           border: Border.all(color: Colors.grey.shade400, width: 1.0),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         child: TextFormField(
  //           cursorColor: Colors.black,
  //           controller: controller,
  //           keyboardType: type == 'Aadhaar' ? TextInputType.number : TextInputType.text,
  //           maxLength: type == 'Aadhaar' ? 12 : 10,
  //           decoration: const InputDecoration(
  //             contentPadding: EdgeInsets.only(bottom: 5, left: 10),
  //             border: InputBorder.none,
  //             counterText: '',
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //
  //       // Front and Back Image section in a row
  //       Row(
  //         children: [
  //           // Front Image Section
  //           Expanded(
  //             child: Column(
  //               children: [
  //                 const Text('Front Image', style: TextStyle(fontWeight: FontWeight.bold)),
  //                 const SizedBox(height: 10),
  //                 Stack(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () => _pickImage(true, ImageSource.gallery, type),
  //                       child: frontImageUrl != null
  //                           ? Image.network(
  //                         frontImageUrl,
  //                         height: 100,
  //                         fit: BoxFit.cover,
  //                         loadingBuilder: (context, child, loadingProgress) {
  //                           if (loadingProgress == null) {
  //                             return child;
  //                           }
  //                           return Center(
  //                             child: CircularProgressIndicator(
  //                               value: loadingProgress.expectedTotalBytes != null
  //                                   ? loadingProgress.cumulativeBytesLoaded /
  //                                   (loadingProgress.expectedTotalBytes ?? 1)
  //                                   : null,
  //                             ),
  //                           );
  //                         },
  //                         errorBuilder: (context, error, stackTrace) {
  //                           return _buildErrorPlaceholder("Image not available");
  //                         },
  //                       )
  //                           : frontImage != null
  //                           ? Image.file(frontImage, height: 100, fit: BoxFit.cover)
  //                           : _buildPlaceholder(),
  //                     ),
  //                     Positioned(
  //                       bottom: 5,
  //                       right: 5,
  //                       child: GestureDetector(
  //                         onTap: () => _pickImage(true, ImageSource.gallery, type),
  //                         child: Container(
  //                           padding: const EdgeInsets.all(5),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white.withOpacity(0.7),
  //                             borderRadius: BorderRadius.circular(30),
  //                           ),
  //                           child: const Icon(Icons.camera_alt, color: Colors.black),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(width: 10),
  //
  //           // Back Image Section
  //           Expanded(
  //             child: Column(
  //               children: [
  //                 const Text('Back Image', style: TextStyle(fontWeight: FontWeight.bold)),
  //                 const SizedBox(height: 10),
  //                 Stack(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () => _pickImage(false, ImageSource.gallery, type),
  //                       child: backImageUrl != null
  //                           ? Image.network(
  //                         backImageUrl!,
  //                         height: 100,
  //                         fit: BoxFit.fill,
  //                         loadingBuilder: (context, child, loadingProgress) {
  //                           if (loadingProgress == null) {
  //                             return child;
  //                           }
  //                           return Center(
  //                             child: CircularProgressIndicator(
  //                               value: loadingProgress.expectedTotalBytes != null
  //                                   ? loadingProgress.cumulativeBytesLoaded /
  //                                   (loadingProgress.expectedTotalBytes ?? 1)
  //                                   : null,
  //                             ),
  //                           );
  //                         },
  //                         errorBuilder: (context, error, stackTrace) {
  //                           return _buildErrorPlaceholder("Image not available");
  //                         },
  //                       )
  //                           : backImage != null
  //                           ? Image.file(backImage, height: 100, fit: BoxFit.cover)
  //                           : _buildPlaceholder(),
  //                     ),
  //                     Positioned(
  //                       bottom: 5,
  //                       right: 5,
  //                       child: GestureDetector(
  //                         onTap: () => _pickImage(false, ImageSource.gallery, type),
  //                         child: Container(
  //                           padding: const EdgeInsets.all(5),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white.withOpacity(0.7),
  //                             borderRadius: BorderRadius.circular(30),
  //                           ),
  //                           child: const Icon(Icons.camera_alt, color: Colors.black),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 10),
  //
  //       // Status Row - Aadhaar Card or PAN Card Status based on type
  //       type == 'Aadhaar'
  //           ? Center(child: Text('Aadhaar Card Status: $status', style: TextStyle(fontWeight: FontWeight.bold)))
  //           : Center(child: Text('PAN Card Status: $status', style: TextStyle(fontWeight: FontWeight.bold))),
  //     ],
  //   );
  // }



  Widget _buildErrorPlaceholder(String message) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          message,
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: const Center(
        child: Icon(Icons.add_a_photo, size: 40),
      ),
    );
  }
}

// Widget _buildDocumentSection({
//   required String title,
//   required TextEditingController controller,
//   required String? frontImageUrl,
//   required String? backImageUrl,
//   required File? frontImage,
//   required File? backImage,
//   required String type,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text('$title Number', style: TextStyle(fontWeight: FontWeight.bold)),
//       const SizedBox(height: 10),
//       Container(
//         height: 44,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade400, width: 1.0),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: TextFormField(
//           cursorColor: Colors.black,
//           controller: controller,
//           keyboardType: type == 'Aadhaar' ? TextInputType.number : TextInputType.text,
//           maxLength: type == 'Aadhaar' ? 12 : 10,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.only(bottom: 5, left: 10),
//             border: InputBorder.none,
//             counterText: '',
//           ),
//         ),
//       ),
//       const SizedBox(height: 10),
//       Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _pickImage(true, ImageSource.gallery, type),
//               child: frontImageUrl != null
//                   ? Image.network(
//                 frontImageUrl,
//                 height: 100,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                           (loadingProgress.expectedTotalBytes ?? 1)
//                           : null,
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildErrorPlaceholder("Image not available");
//                 },
//               )
//                   : frontImage != null
//                   ? Image.file(frontImage, height: 100, fit: BoxFit.cover)
//                   : _buildPlaceholder(),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => _pickImage(false, ImageSource.gallery, type),
//               child: backImageUrl != null
//                   ? Image.network(
//                 backImageUrl!,
//                 height: 100,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                           (loadingProgress.expectedTotalBytes ?? 1)
//                           : null,
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildErrorPlaceholder("Image not available");
//                 },
//               )
//                   : backImage != null
//                   ? Image.file(backImage, height: 100, fit: BoxFit.cover)
//                   : _buildPlaceholder(),
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }
// Widget _buildDocumentSection({
//   required String title,
//   required TextEditingController controller,
//   required String? frontImageUrl,
//   required String? backImageUrl,
//   required File? frontImage,
//   required File? backImage,
//   required String type,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Title for the document
//       Text('$title Number', style: TextStyle(fontWeight: FontWeight.bold)),
//       const SizedBox(height: 10),
//
//       // Aadhaar/PAN Number input field
//       Container(
//         height: 44,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade400, width: 1.0),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: TextFormField(
//           cursorColor: Colors.black,
//           controller: controller,
//           keyboardType: type == 'Aadhaar' ? TextInputType.number : TextInputType.text,
//           maxLength: type == 'Aadhaar' ? 12 : 10,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.only(bottom: 5, left: 10),
//             border: InputBorder.none,
//             counterText: '',
//           ),
//         ),
//       ),
//       const SizedBox(height: 10),
//
//       // Front and Back Image section
//       Row(
//         children: [
//           // Front Image Section
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text('Front Image', style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () => _pickImage(true, ImageSource.gallery, type),
//                   child: frontImageUrl != null
//                       ? Image.network(
//                     frontImageUrl,
//                     height: 100,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) {
//                         return child;
//                       }
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                               (loadingProgress.expectedTotalBytes ?? 1)
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return _buildErrorPlaceholder("Image not available");
//                     },
//                   )
//                       : frontImage != null
//                       ? Image.file(frontImage, height: 100, fit: BoxFit.cover)
//                       : _buildPlaceholder(),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//
//           // Back Image Section
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text('Back Image', style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () => _pickImage(false, ImageSource.gallery, type),
//                   child: backImageUrl != null
//                       ? Image.network(
//                     backImageUrl!,
//                     height: 100,
//                     // width: 400,
//                     fit: BoxFit.fill,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) {
//                         return child;
//                       }
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                               (loadingProgress.expectedTotalBytes ?? 1)
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return _buildErrorPlaceholder("Image not available");
//                     },
//                   )
//                       : backImage != null
//                       ? Image.file(backImage, height: 100, fit: BoxFit.cover)
//                       : _buildPlaceholder(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../db/app_db.dart';
// import 'package:http/http.dart' as http;
// import '../widget/appbar_for_setting.dart';
// import '../widget/getdocuments.dart';
//
// class DocumentsUploadScreen extends StatefulWidget {
//   const DocumentsUploadScreen({super.key});
//
//   @override
//   State<DocumentsUploadScreen> createState() => _DocumentsUploadScreenState();
// }
//
// class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
//   final TextEditingController _aadhaarController = TextEditingController();
//   final TextEditingController _panController = TextEditingController();
//
//   File? _aadhaarFrontImage;
//   File? _aadhaarBackImage;
//   File? _panFrontImage;
//   File? _panBackImage;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAndPopulateData();
//   }
//
//   Future<void> _fetchAndPopulateData() async {
//     final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
//     await documentProvider.fetchDocumentDetails();
//
//     if (documentProvider.documentDetails != null) {
//       final details = documentProvider.documentDetails!.data;
//
//       _aadhaarController.text = details.adhaarCardNum.toString();
//       _panController.text = details.panCardNum;
//
//       // Use network images as placeholders
//       setState(() {
//         _aadhaarFrontImage = File(details.adhaarCardFrontPhoto); // Set network image placeholder
//         print('aadhar front pic:-${_aadhaarFrontImage}');
//         _aadhaarBackImage = File(details.adhaarCardBackPhoto);
//         _panFrontImage = File(details.panCardFrontPhoto);
//         _panBackImage = File(details.panCardBackPhoto);
//       });
//     }
//   }
//
//   Future<void> _pickImage(bool isFront, ImageSource source, String type) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(
//       source: source,
//       imageQuality: 80,
//     );
//
//     if (pickedFile != null) {
//       setState(() {
//         final selectedImage = File(pickedFile.path);
//         if (type == 'Aadhaar') {
//           if (isFront) {
//             _aadhaarFrontImage = selectedImage;
//           } else {
//             _aadhaarBackImage = selectedImage;
//           }
//         } else if (type == 'PAN') {
//           if (isFront) {
//             _panFrontImage = selectedImage;
//           } else {
//             _panBackImage = selectedImage;
//           }
//         }
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No image selected')),
//       );
//     }
//   }
//
//   Future<void> _uploadOrUpdateDocuments() async {
//     final isUpdating = Provider.of<DocumentProvider>(context, listen: false).documentDetails != null;
//
//     if (_aadhaarFrontImage == null ||
//         _aadhaarBackImage == null ||
//         _panFrontImage == null ||
//         _panBackImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload all required images.')),
//       );
//       return;
//     }
//
//     try {
//       String? token = await AppDB.appDB.getToken();
//       var uri = Uri.parse('https://batting-api-1.onrender.com/api/document/addDocument');
//       var request = http.MultipartRequest('POST', uri)
//         ..headers.addAll({
//           'Authorization': '$token',
//           'Accept': 'application/json',
//         })
//         ..fields['adhaar_card_num'] = _aadhaarController.text
//         ..fields['pan_card_num'] = _panController.text
//         ..files.add(await http.MultipartFile.fromPath('adhaar_card_front_photo', _aadhaarFrontImage!.path))
//         ..files.add(await http.MultipartFile.fromPath('adhaar_card_back_photo', _aadhaarBackImage!.path))
//         ..files.add(await http.MultipartFile.fromPath('pan_card_front_photo', _panFrontImage!.path))
//         ..files.add(await http.MultipartFile.fromPath('pan_card_back_photo', _panBackImage!.path));
//
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(isUpdating ? 'Documents updated successfully' : 'Documents uploaded successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to upload/update documents')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: 'Documents Upload',
//         onBackButtonPressed: () => Navigator.pop(context),
//       ),      body: Consumer<DocumentProvider>(
//         builder: (context, documentProvider, child) {
//           if (documentProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDocumentSection(
//                     title: 'Aadhaar Card',
//                     controller: _aadhaarController,
//                     frontImage: _aadhaarFrontImage,
//                     backImage: _aadhaarBackImage,
//                     type: 'Aadhaar',
//                   ),
//                   const SizedBox(height: 20),
//                   _buildDocumentSection(
//                     title: 'PAN Card',
//                     controller: _panController,
//                     frontImage: _panFrontImage,
//                     backImage: _panBackImage,
//                     type: 'PAN',
//                   ),
//                   const SizedBox(height: 30),
//                   // ElevatedButton(
//                   //   onPressed: _uploadOrUpdateDocuments,
//                   //   child: Text(documentProvider.documentDetails != null ? 'Update Documents' : 'Upload Documents'),
//                   // ),
//                   GestureDetector(
//                     onTap: () {
//                       _uploadOrUpdateDocuments();
//                       // final aadhaarError = _validateDocumentNumber(_aadhaarController.text, 'Aadhaar');
//                       // final panError = _validateDocumentNumber(_panController.text, 'PAN');
//                       //
//                       // if (aadhaarError != null || panError != null) {
//                       //   ScaffoldMessenger.of(context).showSnackBar(
//                       //     SnackBar(content: Text(aadhaarError ?? panError!)),
//                       //   );
//                       //   return;
//                       // }
//                       if (_aadhaarFrontImage == null ||
//                           _aadhaarBackImage == null ||
//                           _panFrontImage == null ||
//                           _panBackImage == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Please upload all required images.')),
//                         );
//                         return;
//                       }
//                       print('Pressed upload button');
//                       // _uploadDocuments(
//                       //   _aadhaarController.text,
//                       //   _aadhaarFrontImage!,
//                       //   _aadhaarBackImage!,
//                       //   _panController.text,
//                       //   _panFrontImage!,
//                       //   _panBackImage!,
//                       // );
//                     },
//                     child: Container(
//                       height: 48.h,
//                       decoration: BoxDecoration(
//                         color: const Color(0xff140B40),
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Center(
//                         child: Text(
//                           documentProvider.documentDetails != null ? 'Update Documents' : 'Upload Documents',
//                           // "Upload Documents",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//   Widget _buildDocumentSection({
//     required String title,
//     required TextEditingController controller,
//     required File? frontImage,
//     required File? backImage,
//     required String type,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('$title Number', style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 10),
//         Container(
//           height: 44,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Colors.grey.shade400, width: 1.0),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: TextFormField(
//             cursorColor: Colors.black,
//             controller: controller,
//             keyboardType: type == 'Aadhaar' ? TextInputType.number : TextInputType.text,
//             maxLength: type == 'Aadhaar' ? 12 : 10,
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.only(bottom: 5, left:  10),
//               border: InputBorder.none,
//               counterText: '',
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => _pickImage(true, ImageSource.gallery, type),
//                 child: frontImage != null
//                     ? Image.file(frontImage, height: 100, fit: BoxFit.cover)
//                     : _buildPlaceholder(),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => _pickImage(false, ImageSource.gallery, type),
//                 child: backImage != null
//                     ? Image.file(backImage, height: 100, fit: BoxFit.cover)
//                     : _buildPlaceholder(),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//   // Widget _buildDocumentSection({
//   //   required String title,
//   //   required TextEditingController controller,
//   //   required File? frontImage,
//   //   required File? backImage,
//   //   required String type,
//   // }) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text('$title Number', style: const TextStyle(fontWeight: FontWeight.bold)),
//   //       const SizedBox(height: 10),
//   //       TextFormField(
//   //         controller: controller,
//   //         decoration: const InputDecoration(border: OutlineInputBorder()),
//   //       ),
//   //       const SizedBox(height: 10),
//   //       Row(
//   //         children: [
//   //           Expanded(
//   //             child: GestureDetector(
//   //               onTap: () => _pickImage(true, ImageSource.gallery, type),
//   //               child: frontImage != null
//   //                   ? Image.file(frontImage, height: 100, fit: BoxFit.cover)
//   //                   : _buildPlaceholder(),
//   //             ),
//   //           ),
//   //           const SizedBox(width: 10),
//   //           Expanded(
//   //             child: GestureDetector(
//   //               onTap: () => _pickImage(false, ImageSource.gallery, type),
//   //               child: backImage != null
//   //                   ? Image.file(backImage, height: 100, fit: BoxFit.cover)
//   //                   : _buildPlaceholder(),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ],
//   //   );
//   // }
//   Widget _buildPlaceholder() {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey),
//       ),
//       child: const Center(
//         child: Icon(Icons.add_a_photo, size: 40),
//       ),
//     );
//   }
//   // Widget _buildPlaceholder() {
//   //   return Container(
//   //     height: 100,
//   //     decoration: BoxDecoration(
//   //       color: Colors.grey[200],
//   //       borderRadius: BorderRadius.circular(8),
//   //       border: Border.all(color: Colors.grey),
//   //     ),
//   //     child: const Center(
//   //       child: Icon(Icons.add_a_photo, size: 40),
//   //     ),
//   //   );
//   // }
// }
//
// // import 'dart:convert';
// // import 'dart:math';
// // import 'package:batting_app/widget/appbar_for_setting.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'dart:io';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:http/http.dart' as http;
// // import '../db/app_db.dart';
// //
// // class DocumentsUploadScreen extends StatefulWidget {
// //   const DocumentsUploadScreen({super.key});
// //
// //   @override
// //   State<DocumentsUploadScreen> createState() => _DocumentsUploadScreenState();
// // }
// //
// // class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
// //   final TextEditingController _aadhaarController = TextEditingController();
// //   final TextEditingController _panController = TextEditingController();
// //
// //   File? _aadhaarFrontImage;
// //   File? _aadhaarBackImage;
// //   File? _panFrontImage;
// //   File? _panBackImage;
// //
// //   Future<void> _pickImage(bool isFront, ImageSource source, String type) async {
// //     final ImagePicker picker = ImagePicker();
// //
// //     final XFile? pickedFile = await picker.pickImage(
// //       source: source,
// //       imageQuality: 80,
// //     );
// //
// //     if (pickedFile != null) {
// //       File selectedImage = File(pickedFile.path);
// //
// //       // Convert PNG to JPEG if needed
// //       if (pickedFile.path.toLowerCase().endsWith('.png')) {
// //         selectedImage = await _convertToJpeg(selectedImage);
// //       }
// //
// //       setState(() {
// //         if (type == 'Aadhaar') {
// //           if (isFront) {
// //             _aadhaarFrontImage = selectedImage;
// //           } else {
// //             _aadhaarBackImage = selectedImage;
// //           }
// //         } else if (type == 'PAN') {
// //           if (isFront) {
// //             _panFrontImage = selectedImage;
// //           } else {
// //             _panBackImage = selectedImage;
// //           }
// //         }
// //       });
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('No image selected')),
// //       );
// //     }
// //   }
// //
// //   Future<File> _convertToJpeg(File originalImage) async {
// //     final bytes = await originalImage.readAsBytes();
// //     final image = img.decodeImage(bytes);
// //
// //     if (image != null) {
// //       final jpegImage = img.encodeJpg(image, quality: 80);
// //       final directory = await getTemporaryDirectory();
// //       final jpegFile = File('${directory.path}/converted_image.jpg');
// //       await jpegFile.writeAsBytes(jpegImage);
// //       print('jpeg file:- $jpegFile');
// //       return jpegFile;
// //     }
// //     return originalImage;
// //   }
// //
// //   String? _validateDocumentNumber(String value, String type) {
// //     if (type == 'Aadhaar') {
// //       if (!RegExp(r'^\d{12}$').hasMatch(value)) {
// //         return 'Please enter a valid 12-digit Aadhaar number.';
// //       }
// //     } else if (type == 'PAN') {
// //       if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
// //         return 'Please enter a valid PAN number (e.g., ABCDE1234F).';
// //       }
// //     }
// //     return null;
// //   }
// //
// //   Future<void> _uploadDocuments(
// //       String aadhaarNumber,
// //       File aadhaarFront,
// //       File aadhaarBack,
// //       String panNumber,
// //       File panFront,
// //       File panBack,
// //       ) async {
// //     try {
// //       String? token = await AppDB.appDB.getToken();
// //       var uri = Uri.parse('https://batting-api-1.onrender.com/api/document/addDocument');
// //       var request = http.MultipartRequest('POST', uri)
// //         ..headers.addAll({
// //           'Authorization': '$token',
// //           'Accept': 'application/json',
// //         })
// //         ..fields['adhaar_card_num'] = aadhaarNumber
// //         ..fields['pan_card_num'] = panNumber
// //         ..files.add(await http.MultipartFile.fromPath('adhaar_card_front_photo', aadhaarFront.path))
// //         ..files.add(await http.MultipartFile.fromPath('adhaar_card_back_photo', aadhaarBack.path))
// //         ..files.add(await http.MultipartFile.fromPath('pan_card_front_photo', panFront.path))
// //         ..files.add(await http.MultipartFile.fromPath('pan_card_back_photo', panBack.path));
// //
// //       print('path of the aadhar front:- ${aadhaarFront.path}');
// //       // print('path of the aadhar front:- ${aadhaarFront.path}');
// //
// //
// //       var response = await request.send();
// //       var responseBody = await response.stream.bytesToString();
// //       print('response body :- ${responseBody}');
// //       print('response body :- ${response.statusCode}');
// //
// //       if (response.statusCode == 200) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Documents uploaded successfully')),
// //         );
// //         setState(() {
// //           _aadhaarController.clear();
// //           _panController.clear();
// //           _aadhaarFrontImage = null;
// //           _aadhaarBackImage = null;
// //           _panFrontImage = null;
// //           _panBackImage = null;
// //         });
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Upload failed: ${response.reasonPhrase}')),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error uploading documents: $e')),
// //       );
// //     }
// //   }
// //
// //   Widget _buildDocumentSection({
// //     required String title,
// //     required TextEditingController controller,
// //     required File? frontImage,
// //     required File? backImage,
// //     required String type,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text('$title Number', style: TextStyle(fontWeight: FontWeight.bold)),
// //         const SizedBox(height: 10),
// //         Container(
// //           height: 44,
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             border: Border.all(color: Colors.grey.shade400, width: 1.0),
// //             borderRadius: BorderRadius.circular(10.0),
// //           ),
// //           child: TextFormField(
// //             cursorColor: Colors.black,
// //             controller: controller,
// //             keyboardType: type == 'Aadhaar' ? TextInputType.number : TextInputType.text,
// //             maxLength: type == 'Aadhaar' ? 12 : 10,
// //             decoration: const InputDecoration(
// //               contentPadding: EdgeInsets.only(bottom: 5, left:  10),
// //               border: InputBorder.none,
// //               counterText: '',
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 10),
// //         Row(
// //           children: [
// //             Expanded(
// //               child: GestureDetector(
// //                 onTap: () => _pickImage(true, ImageSource.gallery, type),
// //                 child: frontImage != null
// //                     ? Image.file(frontImage, height: 100, fit: BoxFit.cover)
// //                     : _buildPlaceholder(),
// //               ),
// //             ),
// //             const SizedBox(width: 10),
// //             Expanded(
// //               child: GestureDetector(
// //                 onTap: () => _pickImage(false, ImageSource.gallery, type),
// //                 child: backImage != null
// //                     ? Image.file(backImage, height: 100, fit: BoxFit.cover)
// //                     : _buildPlaceholder(),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildPlaceholder() {
// //     return Container(
// //       height: 100,
// //       decoration: BoxDecoration(
// //         color: Colors.grey[200],
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.grey),
// //       ),
// //       child: const Center(
// //         child: Icon(Icons.add_a_photo, size: 40),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: CustomAppBar(
// //         title: 'Documents Upload',
// //         onBackButtonPressed: () => Navigator.pop(context),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(15),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildDocumentSection(
// //                 title: 'Aadhaar Card',
// //                 controller: _aadhaarController,
// //                 frontImage: _aadhaarFrontImage,
// //                 backImage: _aadhaarBackImage,
// //                 type: 'Aadhaar',
// //               ),
// //               const SizedBox(height: 20),
// //               _buildDocumentSection(
// //                 title: 'PAN Card',
// //                 controller: _panController,
// //                 frontImage: _panFrontImage,
// //                 backImage: _panBackImage,
// //                 type: 'PAN',
// //               ),
// //               const SizedBox(height: 30),
// //               GestureDetector(
// //                 onTap: () {
// //                   final aadhaarError = _validateDocumentNumber(_aadhaarController.text, 'Aadhaar');
// //                   final panError = _validateDocumentNumber(_panController.text, 'PAN');
// //
// //                   if (aadhaarError != null || panError != null) {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text(aadhaarError ?? panError!)),
// //                     );
// //                     return;
// //                   }
// //                   if (_aadhaarFrontImage == null ||
// //                       _aadhaarBackImage == null ||
// //                       _panFrontImage == null ||
// //                       _panBackImage == null) {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(content: Text('Please upload all required images.')),
// //                     );
// //                     return;
// //                   }
// //                   print('Pressed upload button');
// //                   _uploadDocuments(
// //                     _aadhaarController.text,
// //                     _aadhaarFrontImage!,
// //                     _aadhaarBackImage!,
// //                     _panController.text,
// //                     _panFrontImage!,
// //                     _panBackImage!,
// //                   );
// //                 },
// //                 child: Container(
// //                   height: 48.h,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xff140B40),
// //                     borderRadius: BorderRadius.circular(8.r),
// //                   ),
// //                   child: Center(
// //                     child: Text(
// //                       "Upload Documents",
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.w600,
// //                         fontSize: 16.sp,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // import 'dart:convert';
// // import 'package:batting_app/widget/appbar_for_setting.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'dart:io';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:http/http.dart' as http;
// // import '../db/app_db.dart';
// // import '../widget/smalltext.dart';
// // class DocumentsUploadScreen extends StatefulWidget {
// //   const DocumentsUploadScreen({super.key});
// //   @override
// //   State<DocumentsUploadScreen> createState() => _DocumentsUploadScreenState();
// // }
// // class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
// //   String? _selectedDocument; // Holds the selected dropdown value
// //   // List of document options
// //   final TextEditingController _documentNumberController = TextEditingController();
// //
// //   final List<String> _documentOptions = [
// //     'Aadhaar Card',
// //     'PAN Card',
// //     // 'Bank Statement',
// //     // 'Voter ID',
// //     // 'Driving License',
// //   ];
// //   File? _frontImage;
// //   File? _backImage;
// //
// //   String? _validateDocumentNumber(String value) {
// //     if (_selectedDocument == 'Aadhaar Card') {
// //       // Aadhaar card validation (12 digits)
// //       if (!RegExp(r'^\d{12}$').hasMatch(value)) {
// //         return 'Please enter a valid 12-digit Aadhaar number.';
// //       }
// //     } else if (_selectedDocument == 'PAN Card') {
// //       // PAN card validation (5 alphabets + 4 digits + 1 alphabet)
// //       if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
// //         return 'Please enter a valid PAN number (e.g., ABCDE1234F).';
// //       }
// //     }
// //     return null;
// //   }
// //   Future<void> _pickImage(bool isFront, ImageSource source) async {
// //     final ImagePicker picker = ImagePicker();
// //
// //     final XFile? pickedFile = await picker.pickImage(
// //       source: source,
// //       imageQuality: 80,
// //     );
// //
// //     if (pickedFile != null) {
// //       File selectedImage = File(pickedFile.path);
// //
// //       // Convert PNG to JPEG if needed
// //       if (pickedFile.path.toLowerCase().endsWith('.png')) {
// //         selectedImage = await _convertToJpeg(selectedImage);
// //       }
// //
// //       setState(() {
// //         if (isFront) {
// //           _frontImage = selectedImage;
// //         } else {
// //           _backImage = selectedImage;
// //         }
// //       });
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('No image selected')),
// //       );
// //     }
// //   }
// //   void _showImagePickerDialog(bool isFront) {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return SafeArea(
// //           child: Wrap(
// //             children: [
// //               ListTile(
// //                 leading: const Icon(Icons.camera_alt),
// //                 title: const Text('Camera'),
// //                 onTap: () {
// //                   Navigator.of(context).pop();
// //                   _pickImage(isFront, ImageSource.camera);
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.photo_library),
// //                 title: const Text('Gallery'),
// //                 onTap: () {
// //                   Navigator.of(context).pop();
// //                   _pickImage(isFront, ImageSource.gallery);
// //                 },
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //   Future<File> _convertToJpeg(File originalImage) async {
// //     final bytes = await originalImage.readAsBytes();
// //     final image = img.decodeImage(bytes);
// //     print('image is resizing......');
// //
// //     if (image != null) {
// //       final jpegImage = img.encodeJpg(image, quality: 80); // Adjust quality as needed
// //       final directory = await getTemporaryDirectory();
// //       final jpegFile = File('${directory.path}/converted_image.jpg');
// //
// //       await jpegFile.writeAsBytes(jpegImage);
// //       print('image is resizing.11111111111.....$jpegFile');
// //       return jpegFile;
// //     }
// //     print('image is resizing.22222222222222222222.....$originalImage');
// //
// //     return originalImage;
// //   }
// //   void _onDocumentChanged(String? newValue) {
// //     setState(() {
// //       _selectedDocument = newValue;
// //       _documentNumberController.clear();
// //       _frontImage = null; // Reset front image
// //       _backImage = null; // Reset back image
// //     });
// //   }
// //
// //   Future<void> _uploadDocuments(String title,String number, File frontImage, File backImage) async {
// //     try {
// //       String? token = await AppDB.appDB.getToken();
// //       var uri = Uri.parse('https://batting-api-1.onrender.com/api/document/addDocument');
// //       var request = http.MultipartRequest('POST', uri)
// //         ..headers.addAll({
// //           'Authorization': '$token',
// //           'Accept': 'application/json',
// //         })
// //         ..fields['title'] = title
// //         ..fields['number'] = number
// //         ..files.add(await http.MultipartFile.fromPath('frontImage', frontImage.path))
// //         ..files.add(await http.MultipartFile.fromPath('backImage', backImage.path));
// //
// //       var response = await request.send();
// //       var responseBody = await response.stream.bytesToString();
// //
// //       if (response.statusCode == 200) {
// //         print("Upload successful: $responseBody");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Documents uploaded successfully')),
// //         );
// //         setState(() {
// //           _frontImage = null;
// //           _backImage = null;
// //           _selectedDocument = null;
// //         });
// //       } else {
// //         print("Upload failed: $responseBody");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Upload failed: ${response.reasonPhrase}')),
// //         );
// //       }
// //     } catch (e) {
// //       print("Error uploading documents: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error uploading documents: $e')),
// //       );
// //     }
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppBar(
// //         title: 'Documents Upload',
// //         onBackButtonPressed: () {
// //           Navigator.pop(context);
// //         },
// //       ),
// //       backgroundColor: Colors.white,
// //       body: Padding(
// //         padding: const EdgeInsets.all(15),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Select Document to Upload',
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //               Center(
// //                 child: Container(
// //                   width: _selectedDocument != null ? MediaQuery.of(context).size.width :MediaQuery.of(context).size.width/1.3,
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(color: Colors.grey.shade300),
// //                   ),
// //                   child: DropdownButtonHideUnderline(
// //                     child: DropdownButton<String>(
// //                       value: _selectedDocument,
// //                       hint: const Text('Choose a document'),
// //                       isExpanded: true,
// //                       dropdownColor: Colors.white,
// //                       icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
// //                       items: _documentOptions.map((String document) {
// //                         return DropdownMenuItem<String>(
// //                           value: document,
// //                           child: Text(document),
// //                         );
// //                       }).toList(),
// //                       onChanged: _onDocumentChanged,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               if (_selectedDocument != null) ...[
// //                 const Text('Enter Document Number', style: TextStyle(fontWeight: FontWeight.bold)),
// //                 // const SizedBox(height: 15),
// //                 // SmallText(color: Colors.grey, text: "Enter Document Number"),
// //                 // const SizedBox(height: 5),
// //                 Container(
// //                   height: 44,
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     border: Border.all(color: Colors.grey.shade400, width: 1.0),
// //                     borderRadius: BorderRadius.circular(10.0),
// //                   ),
// //                   child: TextFormField(
// //                     cursorColor: Colors.black,
// //                     controller: _documentNumberController,
// //                     keyboardType: _selectedDocument == 'Aadhaar Card'? TextInputType.number: TextInputType.text,
// //                     maxLength: _selectedDocument == 'Aadhaar Card' ? 12 : 10,
// //                     decoration: const InputDecoration(
// //                       contentPadding: EdgeInsets.only(bottom: 8, left: 10),
// //                       border: InputBorder.none,
// //                       counterText: "",
// //                     ),
// //                     validator: (value) => _validateDocumentNumber(value ?? ''),
// //                   ),
// //                 ),
// //                 // TextFormField(
// //                 //   controller: _documentNumberController,
// //                 //   keyboardType: _selectedDocument == 'Aadhaar Card'? TextInputType.number: TextInputType.text,
// //                 //   maxLength: _selectedDocument == 'Aadhaar Card' ? 12 : 10,
// //                 //   decoration: InputDecoration(
// //                 //     hintText: _selectedDocument == 'Aadhaar Card'
// //                 //         ? 'Enter Aadhaar number'
// //                 //         : 'Enter PAN number',
// //                 //   ),
// //                 //   validator: (value) => _validateDocumentNumber(value ?? ''),
// //                 // ),
// //                 const SizedBox(height: 20),
// //                 const Text(
// //                   'Upload Front Image',
// //                   style: TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 GestureDetector(
// //                   onTap: () => _showImagePickerDialog(true),
// //                   child: _frontImage != null
// //                       ? Image.file(
// //                     _frontImage!,
// //                     width: double.infinity,
// //                     height: 200,
// //                     fit: BoxFit.cover,
// //                   )
// //                       : Container(
// //                     width: double.infinity,
// //                     height: 200,
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey[200],
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: Colors.grey),
// //                     ),
// //                     child: const Center(
// //                       child: Icon(Icons.add_a_photo, size: 50),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const Text(
// //                   'Upload Back Image',
// //                   style: TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 GestureDetector(
// //                   onTap: () => _showImagePickerDialog(false),
// //                   child: _backImage != null
// //                       ? Image.file(
// //                     _backImage!,
// //                     width: double.infinity,
// //                     height: 200,
// //                     fit: BoxFit.cover,
// //                   )
// //                       : Container(
// //                     width: double.infinity,
// //                     height: 200,
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey[200],
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: Colors.grey),
// //                     ),
// //                     child: const Center(
// //                       child: Icon(Icons.add_a_photo, size: 50),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 GestureDetector(
// //                   onTap: () {
// //                     final docNumber = _documentNumberController.text.trim();
// //                     final error = _validateDocumentNumber(docNumber);
// //                     if (error != null) {
// //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
// //                       return;
// //                     }
// //                     if (_frontImage != null && _backImage != null && _selectedDocument != null) {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(
// //                           content: Text('Uploading $_selectedDocument...'),
// //                         ),
// //                       );
// //
// //                       _uploadDocuments(_selectedDocument!,docNumber,_frontImage!,_backImage!);
// //                     } else {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                           content: Text('Please select a document type and upload both front and back images'),
// //                         ),
// //                       );
// //                     }
// //                   },
// //                   child: Container(
// //                     height: 48.h,
// //                     width: MediaQuery.of(context).size.width * 0.90,
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xff140B40),
// //                       borderRadius: BorderRadius.circular(8.r),
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         "Upload Documents",
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: 16.sp,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // // Future<void> _pickImage(bool isFront, ImageSource source) async {
// // //   final ImagePicker picker = ImagePicker();
// // //
// // //   final XFile? pickedFile = await picker.pickImage(
// // //     source: source,
// // //     imageQuality: 80,
// // //   );
// // //
// // //   if (pickedFile != null) {
// // //     setState(() {
// // //       if (isFront) {
// // //         _frontImage = File(pickedFile.path);
// // //       } else {
// // //         _backImage = File(pickedFile.path);
// // //       }
// // //     });
// // //   } else {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(content: Text('No image selected')),
// // //     );
// // //   }
// // // }
// //
// // // onTap: () {
// // //   if (_frontImage != null && _backImage != null) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text('Uploading $_selectedDocument...'),
// // //       ),
// // //     );
// // //
// // //     setState(() {
// // //       _frontImage = null; // Reset front image
// // //       _backImage = null;
// // //     });
// // //
// // //   } else {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(
// // //         content:
// // //         Text('Please upload both front and back images'),
// // //       ),
// // //     );
// // //   }
// // // },
// //
// // // import 'package:batting_app/widget/appbar_for_setting.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'dart:io';
// // //
// // // import 'package:image_picker/image_picker.dart';
// // //
// // // class DocumentsUploadScreen extends StatefulWidget {
// // //   const DocumentsUploadScreen({super.key});
// // //
// // //   @override
// // //   State<DocumentsUploadScreen> createState() => _DocumentsUploadScreenState();
// // // }
// // //
// // // class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
// // //   String? _selectedDocument; // Holds the selected dropdown value
// // //
// // //   // List of document options
// // //   final List<String> _documentOptions = [
// // //     'Aadhaar Card',
// // //     'PAN Card',
// // //     'Bank Statement',
// // //     'Voter ID',
// // //     'Driving License',
// // //   ];
// // //
// // //   File? _frontImage;
// // //   File? _backImage;
// // //
// // //   Future<void> _pickImage(bool isFront) async {
// // //     final ImagePicker picker = ImagePicker();
// // //
// // //     // Pick an image from the gallery
// // //     final XFile? pickedFile = await picker.pickImage(
// // //       source: ImageSource.gallery,
// // //       imageQuality: 80,
// // //     );
// // //
// // //     if (pickedFile != null) {
// // //       setState(() {
// // //         if (isFront) {
// // //           _frontImage = File(pickedFile.path);
// // //         } else {
// // //           _backImage = File(pickedFile.path);
// // //         }
// // //       });
// // //     } else {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('No image selected')),
// // //       );
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: CustomAppBar(
// // //         title: 'Documents Upload',
// // //         onBackButtonPressed: () {
// // //           Navigator.pop(context);
// // //         },
// // //       ),
// // //       backgroundColor: Colors.white,
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(15),
// // //         child: SingleChildScrollView(
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 'Select Document to Upload',
// // //                 style: TextStyle(
// // //                   fontSize: 16,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: Colors.black,
// // //                 ),
// // //               ),
// // //               SizedBox(height: 10),
// // //               Container(
// // //                 padding: EdgeInsets.symmetric(horizontal: 12),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.white,
// // //                   borderRadius: BorderRadius.circular(8),
// // //                   border: Border.all(color: Colors.grey.shade300),
// // //                 ),
// // //                 child: DropdownButtonHideUnderline(
// // //                   child: DropdownButton<String>(
// // //                     value: _selectedDocument,
// // //                     hint: Text('Choose a document'),
// // //                     isExpanded: true,
// // //                     dropdownColor: Colors.white,
// // //                     icon: Icon(Icons.arrow_drop_down, color: Colors.black),
// // //                     items: _documentOptions.map((String document) {
// // //                       return DropdownMenuItem<String>(
// // //                         value: document,
// // //                         child: Text(document),
// // //                       );
// // //                     }).toList(),
// // //                     onChanged: (String? newValue) {
// // //                       setState(() {
// // //                         _selectedDocument = newValue;
// // //                       });
// // //                     },
// // //                   ),
// // //                 ),
// // //               ),
// // //               SizedBox(height: 20),
// // //               if (_selectedDocument != null) ...[
// // //                 Text(
// // //                   'Upload Front Image',
// // //                   style: TextStyle(fontWeight: FontWeight.bold),
// // //                 ),
// // //                 SizedBox(height: 10),
// // //                 GestureDetector(
// // //                   onTap: () => _pickImage(true),
// // //                   child: _frontImage != null
// // //                       ? Image.file(
// // //                           _frontImage!,
// // //                           width: double.infinity,
// // //                           height: 200,
// // //                           fit: BoxFit.cover,
// // //                         )
// // //                       : Container(
// // //                           width: double.infinity,
// // //                           height: 200,
// // //                           decoration: BoxDecoration(
// // //                             color: Colors.grey[200],
// // //                             borderRadius: BorderRadius.circular(8),
// // //                             border: Border.all(color: Colors.grey),
// // //                           ),
// // //                           child: Center(
// // //                             child: Icon(Icons.add_a_photo, size: 50),
// // //                           ),
// // //                         ),
// // //                 ),
// // //                 SizedBox(height: 20),
// // //                 Text(
// // //                   'Upload Back Image',
// // //                   style: TextStyle(fontWeight: FontWeight.bold),
// // //                 ),
// // //                 SizedBox(height: 10),
// // //                 GestureDetector(
// // //                   onTap: () => _pickImage(false),
// // //                   child: _backImage != null
// // //                       ? Image.file(
// // //                           _backImage!,
// // //                           width: double.infinity,
// // //                           height: 200,
// // //                           fit: BoxFit.cover,
// // //                         )
// // //                       : Container(
// // //                           width: double.infinity,
// // //                           height: 200,
// // //                           decoration: BoxDecoration(
// // //                             color: Colors.grey[200],
// // //                             borderRadius: BorderRadius.circular(8),
// // //                             border: Border.all(color: Colors.grey),
// // //                           ),
// // //                           child: Center(
// // //                             child: Icon(Icons.add_a_photo, size: 50),
// // //                           ),
// // //                         ),
// // //                 ),
// // //                 SizedBox(height: 20),
// // //                 GestureDetector(
// // //                   onTap: () {
// // //                     if (_frontImage != null && _backImage != null) {
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         SnackBar(
// // //                           content: Text('Uploading $_selectedDocument...'),
// // //                         ),
// // //                       );
// // //                     } else {
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         SnackBar(
// // //                           content:
// // //                               Text('Please upload both front and back images'),
// // //                         ),
// // //                       );
// // //                     }
// // //                   },
// // //                   child: Container(
// // //                     height: 48.h,
// // //                     width: MediaQuery.of(context).size.width * 0.90,
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xff140B40),
// // //                       borderRadius: BorderRadius.circular(8.r),
// // //                     ),
// // //                     child: Center(
// // //                       child: Row(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           // Padding(
// // //                           //   padding: const EdgeInsets.only(bottom: 1),
// // //                           //   child: Image.asset(
// // //                           //     'assets/whatsup.png',
// // //                           //     height: 18.h,
// // //                           //   ),
// // //                           // ),
// // //                           SizedBox(width: 5.w),
// // //                           Text(
// // //                             "Upload Documents",
// // //                             style: TextStyle(
// // //                               color: Colors.white,
// // //                               fontWeight: FontWeight.w600,
// // //                               fontSize: 16.sp,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // // import 'package:batting_app/widget/appbar_for_setting.dart';
// // // import 'package:flutter/material.dart';
// // //
// // // class DocumentsUploadScreen extends StatefulWidget {
// // //   const DocumentsUploadScreen({super.key});
// // //
// // //   @override
// // //   State<DocumentsUploadScreen> createState() => _DocumentsUploadScreenState();
// // // }
// // //
// // // class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
// // //   String? _selectedDocument; // Holds the selected dropdown value
// // //
// // //   // List of document options
// // //   final List<String> _documentOptions = [
// // //     'Aadhaar Card',
// // //     'PAN Card',
// // //     'Bank Statement',
// // //     'Voter ID',
// // //     'Driving License',
// // //   ];
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: CustomAppBar(
// // //         title: 'Documents Upload',
// // //         onBackButtonPressed: () {
// // //           Navigator.pop(context);
// // //         },
// // //       ),
// // //       backgroundColor: Colors.white,
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(15),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Select Document to Upload',
// // //               style: TextStyle(
// // //                 fontSize: 16,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: Colors.black,
// // //               ),
// // //             ),
// // //             SizedBox(height: 10),
// // //             Container(
// // //               padding: EdgeInsets.symmetric(horizontal: 12),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 border: Border.all(color: Colors.grey.shade300),
// // //               ),
// // //               child: DropdownButtonHideUnderline(
// // //                 child: DropdownButton<String>(
// // //                   value: _selectedDocument,
// // //                   hint: Text('Choose a document'),
// // //                   isExpanded: true,
// // //                   dropdownColor: Colors.white,
// // //                   icon: Icon(Icons.arrow_drop_down, color: Colors.black),
// // //                   items: _documentOptions.map((String document) {
// // //                     return DropdownMenuItem<String>(
// // //                       value: document,
// // //                       child: Text(document),
// // //                     );
// // //                   }).toList(),
// // //                   onChanged: (String? newValue) {
// // //                     setState(() {
// // //                       _selectedDocument = newValue;
// // //                     });
// // //                   },
// // //                 ),
// // //               ),
// // //             ),
// // //             SizedBox(height: 20),
// // //             if (_selectedDocument != null)
// // //               Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     'Selected Document: $_selectedDocument',
// // //                     style: TextStyle(
// // //                       fontSize: 14,
// // //                       color: Colors.black,
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 10),
// // //                   ElevatedButton(
// // //                     onPressed: () {
// // //                       // Logic to handle document upload
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         SnackBar(
// // //                           content: Text('Uploading $_selectedDocument...'),
// // //                         ),
// // //                       );
// // //                     },
// // //                     child: Text('Upload Document'),
// // //                   ),
// // //                 ],
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // import 'package:batting_app/widget/appbar_for_setting.dart';
// // // // import 'package:flutter/material.dart';
// // // //
// // // // class DocumentsUploadScreen extends StatefulWidget {
// // // //   const DocumentsUploadScreen({super.key});
// // // //
// // // //   @override
// // // //   State<DocumentsUploadScreen> createState() => _DocumentsUploadScreenState();
// // // // }
// // // //
// // // // class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: CustomAppBar(title: 'Documents Upload', onBackButtonPressed: () {
// // // //         // Custom behavior for back button (if needed)
// // // //         Navigator.pop(context);
// // // //       },),
// // // //       backgroundColor: Colors.white,
// // // //       body: Padding(padding: EdgeInsets.all(15), child:Column(
// // // //         children: [
// // // //
// // // //         ],
// // // //       ),),
// // // //     );
// // // //   }
// // // // }
