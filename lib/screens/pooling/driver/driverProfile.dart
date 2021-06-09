import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/driverModel.dart';

class DriverProfile extends StatelessWidget {
  final DriverModel driverModel;
  DriverProfile(this.driverModel);
  @override
  Widget build(BuildContext context) {
    int rides =  driverModel.rides  ;
    return Scaffold(
      appBar: AppBar(title: Text("Driver Details")),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,right: 0,
                      child: Center(
                        child: Container(
              child: CircleAvatar(
                backgroundImage: driverModel.profilePicture == null
                    ? AssetImage('assets/avatar.png') as ImageProvider
                    : NetworkImage(driverModel.profilePicture!),
                radius: 50,
              ),
            ),
                      ),
          ),
          Positioned(top:120,left:0,right: 0,
          child: Text(driverModel.displayName,textAlign: TextAlign.center, style: title.copyWith(fontSize: 20),)),
          Padding(
            padding: const EdgeInsets.only(top:130.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /*  Row(
                  children: [
                    Icon(Icons.star, size: 12, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(driverModel.rating.toString() ?? '3.0',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    )
                  ],
                ), */
                customRow(
                    Icon(Icons.star), driverModel.rating.toString() ),
                customRow(
                    driverModel.music
                        ? Icon(Icons.music_note_outlined)
                        : Icon(Icons.music_off_outlined),
                    'Its all about the playlist!'),
                driverModel.petAllow
                    ? customRow(
                        Icon(Icons.pets), 'You can bring you pets with you')
                    : customRow(Icon(Icons.no_transfer_outlined),
                        'Sorry, pets are not allowed'),
                driverModel.smoke
                    ? customRow(Icon(Icons.smoking_rooms), 'You can smoke in car')
                    : customRow(
                        Icon(Icons.smoke_free), 'Please, do not smoke in car'),
                driverModel.funny
                    ? customRow(Icon(Icons.speaker_notes),
                        'I\'m chatty when i feel comfortable')
                    : customRow(
                        Icon(Icons.speaker_notes_off), 'Sorry, i\'m not chatty'),
                customRow(Icon(Icons.directions_car),
                   '${rides.toString()} rides completed'),
                customRow(
                    Icon(Icons.date_range),
                   
                        'Member since ${AppConfig().dateWithoutTime.format(DateTime.parse(driverModel.memberDate))}'),
                TextButton(
                  child: Text('Report this member',style: TextStyle(color: Colors.greenAccent),),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget customRow(Icon icon, String title) {
    return Container(height: 40,child: ListTile(leading: icon, title: Text(title)));
  }
}
