import 'package:flutter/material.dart';

class NotificationManager with ChangeNotifier {
  String _loading = '';
  String _promoTitle = '';
  String _promoDate = '';
  int _promoDiscount = 0;

  String _adminNotifi = '';
  String _customNotifi = '';
  String _promotionNotifi = '';

  String get loading => _loading;
  void setLoading(String loading) {
    _loading = loading;
    notifyListeners();
  }

  String get promoTitle => _promoTitle;
  void setpromoTitle({required String title}) {
    _promoTitle = title;
    notifyListeners();
  }

  String get promoDate => _promoDate;
  void setpromoDate({required String date}) {
    _promoDate = date;

    notifyListeners();
  }

  int get promoDiscount => _promoDiscount;
  void setpromoDiscount({required int discount}) {
    _promoDiscount = discount;
    notifyListeners();
  }

  String get adminNotifi => _adminNotifi;
  void setAdminNotifi({required String notifi}) {
    _adminNotifi = notifi;

    notifyListeners();
  }

  String get customNotifi => _customNotifi;
  void setCustomNotifi({required String notifi}) {
    _customNotifi = notifi;

    notifyListeners();
  }

  String get promotionNotifi => _promotionNotifi;
  void setPromotionNotifi({required String notifi}) {
    _promotionNotifi = notifi;

    notifyListeners();
  }
}
