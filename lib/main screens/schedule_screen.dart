import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_fyp/global/global.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();
  TextEditingController faresController = TextEditingController();
  String isDaily = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
      ),
      body: StreamBuilder<dynamic>(
          stream: FirebaseDatabase.instance.ref().child("schedule").onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.snapshot.value == null) {
              return const Center(
                  child: Text('No Schdule available right now'));
            }

            Map data = snapshot.data!.snapshot.value;

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  isDaily = data.values.elementAt(index)['isDaily'];
                  faresController.text =
                      data.values.elementAt(index)['fares'].toString();
                  return Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    height: 600,
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
                        Text(
                          "Driver Name: ${data.values.elementAt(index)['driver_name']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Driver Phone: ${data.values.elementAt(index)['driver_phone']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue:
                              data.values.elementAt(index)['fromLocation'],
                          // controller: fromLocationController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.location_on_outlined),
                            labelText: "Pickup Location",
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
                          initialValue:
                              data.values.elementAt(index)['toLocation'],
                          // controller: toLocationController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.location_on_outlined),
                            labelText: "DropOff Location",
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
                        Row(
                          children: [
                            const Text(
                              "Seats",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            Text(
                              data.values.elementAt(index)['seats'].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Available Seats",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            Text(
                              data.values
                                  .elementAt(index)['availableSeats']
                                  .toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: data.values
                                            .elementAt(index)['availableSeats']
                                            .toString() ==
                                        "0"
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isDaily == "true"
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Daily",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isDaily == "true"
                                          ? Colors.white
                                          : Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isDaily == "false"
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "One Time",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDaily == "false"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              data.values.elementAt(index)['date'].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            const Icon(Icons.calendar_today_outlined)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              data.values.elementAt(index)['time'].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            const Icon(Icons.timer_outlined)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Fares /Km",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: TextFormField(
                                controller: faresController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Fares",
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
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (data.values
                                            .elementAt(index)['availableSeats']
                                            .toString() !=
                                        "0") {
                                      String selectedSeats = "1";
                                      String AvailableSeats = data.values
                                          .elementAt(index)['availableSeats']
                                          .toString();
                                      List<String> seats = [];
                                      if (AvailableSeats == "1") {
                                        seats.add("1");
                                      } else if (AvailableSeats == "2") {
                                        seats.add("1");
                                        seats.add("2");
                                      } else if (AvailableSeats == "3") {
                                        seats.add("1");
                                        seats.add("2");
                                        seats.add("3");
                                      } else if (AvailableSeats == "4") {
                                        seats.add("1");
                                        seats.add("2");
                                        seats.add("3");
                                        seats.add("4");
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Select How Many Seats'),
                                                content: DropdownButton<String>(
                                                  value: selectedSeats,
                                                  items:
                                                      seats.map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedSeats =
                                                          value.toString();
                                                    });
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      FirebaseDatabase.instance
                                                          .ref()
                                                          .child("schedule")
                                                          .child(data.keys
                                                              .elementAt(index))
                                                          .update({
                                                        "availableSeats": (int.parse(data
                                                                    .values
                                                                    .elementAt(index)[
                                                                        'availableSeats']
                                                                    .toString()) -
                                                                int.parse(
                                                                    selectedSeats))
                                                            .toString(),
                                                        "passenger_id":
                                                            currentFirebaseUser!
                                                                .uid,
                                                        "passenger_name":
                                                            currentFirebaseUser!
                                                                .displayName,
                                                        "passenger_email":
                                                            currentFirebaseUser!
                                                                .email,
                                                      }).then((value) {
                                                        
                                                        FirebaseDatabase
                                                            .instance
                                                            .ref()
                                                            .child('booking')
                                                            .child(
                                                                currentFirebaseUser!
                                                                    .uid)
                                                            .set({
                                                          "fromLocation": data
                                                                  .values
                                                                  .elementAt(
                                                                      index)[
                                                              'fromLocation'],
                                                          "toLocation": data
                                                                  .values
                                                                  .elementAt(
                                                                      index)[
                                                              'toLocation'],
                                                          "seats": data.values
                                                                  .elementAt(
                                                                      index)[
                                                              'seats'],
                                                          "isDaily": data.values
                                                                  .elementAt(
                                                                      index)[
                                                              'isDaily'],
                                                          "date": data.values
                                                                  .elementAt(
                                                                      index)[
                                                              'date'],
                                                          "time": data.values
                                                                  .elementAt(
                                                                      index)[
                                                              'time'],
                                                          "fares": data.values
                                                                  .elementAt(
                                                                      index)[
                                                              'fares'],
                                                          "selectedSeats":
                                                              selectedSeats,
                                                          "driver_id": data
                                                                  .values
                                                                  .elementAt(
                                                                      index)[
                                                              'driver_id'],
                                                          "driver_name": data
                                                                  .values
                                                                  .elementAt(
                                                                      index)[
                                                              'driver_name'],
                                                          "driver_phone": data
                                                                  .values
                                                                  .elementAt(
                                                                      index)[
                                                              'driver_phone'],
                                                          "passenger_id":
                                                              currentFirebaseUser!
                                                                  .uid,
                                                          "passenger_name":
                                                              userModelCurrentInfo!
                                                                  .name,
                                                          "passenger_phone":
                                                              userModelCurrentInfo!
                                                                  .phone,
                                                        }).then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                      });
                                                      // Add code here to handle form submission
                                                    },
                                                    child: const Text('Submit'),
                                                  ),
                                                ],
                                              );
                                            });
                                          });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "No Seats Available",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: const Text(
                                    "Book Now",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
