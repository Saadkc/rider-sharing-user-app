import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  final String driverId;
  const ScheduleScreen({super.key, required this.driverId});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Schedule'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: StreamBuilder<dynamic>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("schedule")
              .child(widget.driverId)
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Center(
                  child: Text('No Schdule available right now'));
            }

            Map data = snapshot.data!.snapshot.value;

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  fromLocationController.text =
                      data.values.elementAt(index)['fromLocation'];
                  toLocationController.text =
                      data.values.elementAt(index)['toLocation'];
                  return Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              data.values.elementAt(index)['date'].toString(),
                              // _selectedDate == null
                              //     ? "Select Date"
                              //     : DateFormat.yMMMd()
                              //         .format(_selectedDate!)
                              //         .toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () async {
                                  // showDatePicker(
                                  //         context: context,
                                  //         initialDate: DateTime.now(),
                                  //         firstDate: DateTime.now(),
                                  //         lastDate: DateTime(2100))
                                  //     .then((value) => setState(() {
                                  //           _selectedDate = value!;
                                  //         }));
                                },
                                child:
                                    const Icon(Icons.calendar_today_outlined))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              data.values.elementAt(index)['time'].toString(),
                              // _selectedTime == null
                              //     ? "Select Time"
                              //     : TimeOfDay(
                              //             hour: _selectedTime!.hour,
                              //             minute: _selectedTime!.minute)
                              //         .format(context)
                              //         .toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () async {
                                  // showTimePicker(
                                  //         context: context,
                                  //         initialTime: TimeOfDay(
                                  //             hour: DateTime.now().hour,
                                  //             minute: DateTime.now().minute))
                                  //     .then((value) => setState(() {
                                  //           _selectedTime = value!;
                                  //         }));
                                },
                                child: const Icon(Icons.timer_outlined))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: fromLocationController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.location_on_outlined),
                            labelText: "Add From Location",
                            // hintText: "Select From Location",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: toLocationController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.location_on_outlined),
                            labelText: "Add To Location",
                            // hintText: "Select From Location",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
