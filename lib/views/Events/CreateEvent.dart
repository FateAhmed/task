import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hiring_task/constants/FirestoreConstants.dart';
import 'package:hiring_task/env.dart';
import 'package:hiring_task/models/RentalItem.dart';
import 'package:hiring_task/router/RouteConstants.dart';
import 'package:hiring_task/router/Router.dart';
import 'package:hiring_task/utils/AppDimens.dart';
import 'package:hiring_task/utils/Validatioms.dart';
import 'package:hiring_task/widgets/CustomTextFormField.dart';
import 'package:hiring_task/widgets/OulineRoundedButton.dart';
import 'package:hiring_task/widgets/ProgressHud.dart';
import 'package:hiring_task/widgets/RoundedButton.dart';
import 'package:hiring_task/widgets/Snackbar.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_string/random_string.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _insctructionFocusNode = FocusNode();
  final FocusNode _descripitonFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late User _user;
  File? selectedPdf;
  LatLng? pickedCoordinates;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final dateFormat = DateFormat('dd-MM-yyyy');
  final timeFormat = DateFormat('hh:mm:ss');

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Create a new Event',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: AppDimens.horizontalPadding16,
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Event Name', style: TextStyle(fontSize: 13.w)),
                          CustomTextFormField(
                            contentPadding: EdgeInsets.zero,
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            validator: (e) => notEmpty(e),
                          ),
                          AppDimens.sizebox20,
                          Text('Description', style: TextStyle(fontSize: 13.w)),
                          CustomTextFormField(
                            maxLines: 2,
                            controller: _descriptionController,
                            focusNode: _descripitonFocusNode,
                            validator: (e) => notEmpty(e),
                          ),
                          AppDimens.sizebox20,
                          Text('Instructions', style: TextStyle(fontSize: 13.w)),
                          CustomTextFormField(
                            maxLines: 2,
                            controller: _instructionController,
                            focusNode: _insctructionFocusNode,
                            validator: (e) => notEmpty(e),
                          ),
                          AppDimens.sizebox20,
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async => _selectDate(context),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 5,
                                            spreadRadius: 2),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            selectedDate == null
                                                ? 'Select Date'
                                                : dateFormat.format(selectedDate!),
                                            style: const TextStyle(color: Color(0XFF8A8A8E)),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_up_outlined,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              AppDimens.sizebox20,
                              Expanded(
                                child: InkWell(
                                  onTap: () async => _selectTime(context),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            selectedTime == null
                                                ? 'Select Time'
                                                : localizations.formatTimeOfDay(selectedTime!),
                                            style: const TextStyle(color: Color(0XFF8A8A8E)),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_up_outlined,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          AppDimens.sizebox20,
                          locationPickerField(context),
                          AppDimens.sizebox15,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AppDimens.sizebox20,
            OutlineRoundedButton(
              text: selectedPdf != null ? 'Picked File : ${selectedPdf!.path.split('/').last}' : 'Upload PDF',
              press: pickPDF,
            ),
            AppDimens.sizebox10,
            RoundedButton(
              text: 'Confirm & Next',
              press: createEvent,
            ),
            AppDimens.sizebox40,
          ],
        ),
      ),
    );
  }

  Widget locationPickerField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: TextStyle(fontSize: 13.w)),
        CustomTextFormField(
          onTap: () async {
            final res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlacePicker(
                  apiKey: ENV.mapsAPIKey,
                  onGeocodingSearchFailed: (value) {},
                  onPlacePicked: (result) {
                    if (result.geometry == null) {
                      return;
                    }
                    Navigator.of(context).pop(result);
                  },
                  initialPosition: const LatLng(31.52004384510866, 74.32556570009),
                  useCurrentLocation: false,
                  resizeToAvoidBottomInset: false,
                ),
              ),
            );
            if (res != null && res is PickResult && mounted) {
              pickedCoordinates = LatLng(res.geometry!.location.lat, res.geometry!.location.lng);
              _locationController.text = res.formattedAddress ?? pickedCoordinates!.toString();
            }
          },
          readOnly: true,
          validator: (e) => notEmpty(e),
          controller: _locationController,
          focusNode: _locationFocusNode,
        ),
        AppDimens.sizebox15,
        InkWell(
          onTap: () async {
            showLoadingHUD(context);
            try {
              LocationPermission permission;
              permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
              }
              if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                var location = await Geolocator.getCurrentPosition();
                var address = await placemarkFromCoordinates(location.latitude, location.longitude);

                pickedCoordinates = LatLng(location.latitude, location.longitude);
                _locationController.text =
                    '${address[0].street} ${address[0].subAdministrativeArea} ${address[0].administrativeArea} ${address[0].country}';
                if (context.mounted) context.pop();
              }
              if (context.mounted &&
                  (permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever)) {
                context.pop();
                showSnacBar(context, content: 'Please allow location permission or try a manual search');
              }
            } catch (e) {
              if (!context.mounted) return;
              context.pop();
              showSnacBar(context, content: 'Something went wrong');
            }
          },
          child: const Row(
            children: [
              Icon(Icons.my_location, size: 18),
              AppDimens.sizebox5,
              Text('Use current location.'),
            ],
          ),
        )
      ],
    );
  }

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
      });
    } else {
      if (mounted) showSnacBar(context, content: 'No File Picked');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  List<String> prepareMetadata() {
    String title = _nameController.text;
    List<String> temp = [];
    for (var i = 1; i <= title.length; i++) {
      temp.add(title.substring(0, i).toLowerCase());
    }
    return temp;
  }

  Future<String> uploadPDF() async {
    late String link;
    var path = randomString(16);
    final storageRef = FirebaseStorage.instance.ref().child('files/$path.pdf');
    await storageRef.putFile(File(selectedPdf!.path));
    var url = await storageRef.getDownloadURL();
    link = url;
    return link;
  }

  createEvent() async {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null || selectedTime == null) {
        showSnacBar(context, content: 'Please pick Event Date And Time');
        return;
      }

      try {
        showLoadingHUD(context);
        EventItem event = EventItem(
          status: true,
          createdBy: _user.uid,
          metadata: prepareMetadata(),
          coordinates: pickedCoordinates!,
          title: _nameController.text.trimLeft(),
          location: _locationController.text.trim(),
          description: _descriptionController.text.trim(),
          eventTime: selectedDate!.copyWith(hour: selectedTime!.hour, minute: selectedTime!.minute),
        );

        if (selectedPdf != null) {
          event.pdfFile = await uploadPDF();
        }

        await FirebaseFirestore.instance.collection(FirestoreConstants.events).add(event.toMap());

        if (mounted) {
          context.pop();
          context.go(RouteConstants.dashboardPath);
        }
      } catch (e) {
        logger.e(e);
        if (mounted) context.pop();
        return;
      }
    }
  }
}
