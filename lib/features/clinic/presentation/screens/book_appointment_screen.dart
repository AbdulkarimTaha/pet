import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petscare/core/presentation/widgets/pet_avatar.dart';
import 'package:petscare/features/clinic/presentation/screens/appointment_success_screen.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookAppointmentScreen extends StatefulWidget {
  final String clinicId;
  const BookAppointmentScreen({super.key, required this.clinicId});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? _selectedDateTime;
  int? selectedPetIndex;
  int? selectedServiceIndex;

  List<Map<String, dynamic>> pets = [];
  bool isLoadingPets = true;
  String? petsError;

  final List<Map<String, dynamic>> services = [
    {"name": "Check Up", "imageUrl": "assets/images/asd1.svg"},
    {"name": "Vaccination", "imageUrl": "assets/images/asd2.svg"},
    {"name": "Grooming", "imageUrl": "assets/images/asd3.svg"},
    {"name": "Treatment", "imageUrl": "assets/images/asd4.svg"},
    {"name": "Surgery", "imageUrl": "assets/images/asd5.svg"},
    {"name": "Dental Care", "imageUrl": "assets/images/asd6.svg"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    setState(() {
      isLoadingPets = true;
      petsError = null;
    });
    try {
      final userId = await UserService.getUserId();
      if (userId == null) throw Exception('User not logged in');
      final url = Uri.parse('https://api.docai.online/api/petProfiles/$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          pets = List<Map<String, dynamic>>.from(data);
          isLoadingPets = false;
        });
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (e) {
      setState(() {
        petsError = e.toString();
        isLoadingPets = false;
      });
    }
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _dayController.text = pickedDate.day.toString().padLeft(2, '0');
          _monthController.text = _getMonthAbbreviation(pickedDate.month);
          _timeController.text = _formatTime(pickedTime);
        });
      }
    }
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  void _handleBookAppointment() async {
    if (_selectedDateTime == null) {
      _showError('Please select date and time');
      return;
    }
    if (selectedPetIndex == null) {
      _showError('Please select a pet');
      return;
    }
    if (selectedServiceIndex == null) {
      _showError('Please select a service');
      return;
    }

    final petId = pets[selectedPetIndex!]['id'];
    final ownerId = await UserService.getUserId();
    final clinicId = widget.clinicId;
    final date = _selectedDateTime!.toIso8601String();
    final service = services[selectedServiceIndex!]['name'];

    try {
      final response = await ApiService.bookAppointment({
        'petId': petId,
        'clinicId': clinicId,
        'ownerId': ownerId,
        'date': date,
        'service': service,
      });

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppointmentSuccessScreen(clinicId: clinicId)),
        );
      } else {
        _showError('Failed to book appointment');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Book Appointment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20 * textScaleFactor,
            fontFamily: 'Poppins3',
            letterSpacing: 1.20,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xffD9D9D9),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
            horizontal: size.width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Selection
              SizedBox(
                height: size.height * 0.12,
                child: isLoadingPets
                    ? Center(child: CircularProgressIndicator())
                    : petsError != null
                        ? Center(child: Text(petsError!, style: TextStyle(color: Colors.red)))
                        : pets.isEmpty
                            ? Center(child: Text('No pets found.'))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: pets.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(right: size.width * 0.04),
                                  child: GestureDetector(
                                    onTap: () => setState(() => selectedPetIndex = index),
                                    child: PetAvatar(
                                      name: pets[index]["name"] ?? '',
                                      imageUrl: pets[index]["imageUrl"] ?? 'assets/images/Ellipse1.png',
                                      isSelected: index == selectedPetIndex,
                                    ),
                                  ),
                                ),
                              ),
              ),

              SizedBox(height: size.height * 0.03),

              // Date & Time Selection
              Text(
                'Select Date & Time',
                style: TextStyle(
                  color: const Color(0xFF222222),
                  fontSize: 16 * textScaleFactor,
                  fontFamily: 'poppins2',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.96,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDateTimeField(
                    'Day',
                    _dayController,
                    'DD',
                    size.width * 0.25,
                  ),
                  _buildDateTimeField(
                    'Month',
                    _monthController,
                    'MMM',
                    size.width * 0.25,
                  ),
                  _buildDateTimeField(
                    'Time',
                    _timeController,
                    'HH:MM',
                    size.width * 0.3,
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.03),

              // Services Selection
              Text(
                'Select Services',
                style: TextStyle(
                  color: const Color(0xFF222222),
                  fontSize: 16 * textScaleFactor,
                  fontFamily: 'poppins2',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.96,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: size.width * 0.04,
                  mainAxisSpacing: size.width * 0.04,
                  childAspectRatio: 0.9,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => setState(() => selectedServiceIndex = index),
                  child: _buildServiceItem(
                    services[index]["name"],
                    services[index]["imageUrl"],
                    index == selectedServiceIndex,
                    size,
                    textScaleFactor,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),

              // Book Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleBookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff99DDCC),
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16 * textScaleFactor,
                      fontFamily: 'Poppins1',
                      letterSpacing: 1.28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(
    String label,
    TextEditingController controller,
    String hint,
    double width,
  ) {
    return Container(
      width: width,
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffE1ECE9),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 12,
              fontFamily: 'poppins3',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.72,
            ),
          ),
          Expanded(
            child: Center(
              child: TextFormField(
                controller: controller,
                readOnly: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                onTap: () => _selectDateTime(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    String name,
    String imageUrl,
    bool isSelected,
    Size size,
    double textScaleFactor,
  ) {
    return Column(
      children: [
        Container(
          height: size.width * 0.2,
          width: size.width * 0.2,
          decoration: BoxDecoration(
            color: const Color(0xffE1ECE9),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xff99DDCC) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageUrl,
                width: size.width * 0.08,
                height: size.width * 0.08,
                colorFilter: ColorFilter.mode(
                  isSelected ? const Color(0xff99DDCC) : const Color(0xff4A4A4A),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xff99DDCC) : const Color(0xff4A4A4A),
            fontSize: 12 * textScaleFactor,
            fontFamily: 'Poppins3',
          ),
        ),
      ],
    );
  }
}
