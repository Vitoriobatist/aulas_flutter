import 'package:flutter/material.dart';

abstract final class AppIcons {
  static const delivery = Icons.local_shipping_outlined;
  static const add = Icons.add_rounded;
  static const edit = Icons.edit_outlined;
  static const delete = Icons.delete_outline;
  static const back = Icons.arrow_back;
  static const forward = Icons.arrow_forward;
  static const save = Icons.save_outlined;
  static const addCircle = Icons.add_circle_outline;
  static const location = Icons.location_on_outlined;
  static const person = Icons.person_outline;
  static const code = Icons.qr_code_2_outlined;
  static const clock = Icons.schedule_outlined;
  static const gpsFixed = Icons.gps_fixed;
  static const gpsOff = Icons.gps_not_fixed;
  static const refresh = Icons.refresh_rounded;
  static const package = Icons.inventory_2_outlined;
  static const myLocation = Icons.my_location_outlined;
  static const mail = Icons.mail_outline;
  static const lock = Icons.lock_outline;
  static const visibility = Icons.visibility_outlined;
  static const visibilityOff = Icons.visibility_off_outlined;
  static const logout = Icons.logout;
  static const expandMore = Icons.expand_more;
  static const expandLess = Icons.expand_less;
  static const checkCircle = Icons.check_circle_outline;
  static const bike = Icons.directions_bike_outlined;
  static const hourglass = Icons.hourglass_empty_outlined;
  static const phone = Icons.phone_android_outlined;
  static const error = Icons.error_outline;
  static const notifications = Icons.notifications_outlined;

  static IconData statusIcon(String status) {
    switch (status) {
      case 'Entregue':
        return checkCircle;
      case 'Em transporte':
        return delivery;
      case 'Saiu para entrega':
        return bike;
      default:
        return hourglass;
    }
  }
}
