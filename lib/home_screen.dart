import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeSCREEN extends StatelessWidget {
   HomeSCREEN({Key? key}) : super(key: key);
var locationManger=Location();
  @override
  Widget build(BuildContext context) {
    return const Scaffold();

  }
Future<bool> isLocationServiceEnable()async{
 return  await  locationManger.serviceEnabled();
}
Future<bool> requestService()async{
 var enable=await  locationManger.requestService();
 return enable;
}
Future<bool> isPermissionGranted()async{
 var permissionStatus=await  locationManger.hasPermission();
 return permissionStatus==PermissionStatus.granted;
}
Future<bool> requestPermission()async{
 var permissionStatus=await  locationManger.requestPermission();
 return permissionStatus==PermissionStatus.granted;
}

}
