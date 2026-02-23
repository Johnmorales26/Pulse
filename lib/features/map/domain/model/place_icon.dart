enum PlaceIcon {
  all('id_all', 'All', 'assets/icons/locations/ic_location_all.png'),
  bar('id_bar', 'Bar', 'assets/icons/locations/ic_location_bar.png'),
  beach('id_beach', 'Beach', 'assets/icons/locations/ic_location_beach.png'),
  cinema('id_cinema', 'Cinema', 'assets/icons/locations/ic_location_cinema.png'),
  clock('id_clock', 'Clock', 'assets/icons/locations/ic_location_clock.png'),
  club('id_club', 'Club', 'assets/icons/locations/ic_location_club.png'),
  cyber('id_cyber', 'Cyber', 'assets/icons/locations/ic_location_cyber.png'),
  gym('id_gym', 'Gym', 'assets/icons/locations/ic_location_gym.png'),
  hotel('id_hotel', 'Hotel', 'assets/icons/locations/ic_location_hotel.png'),
  incognito('id_incognito', 'Incognito', 'assets/icons/locations/ic_location_incognito.png'),
  notification('id_notification', 'Notification', 'assets/icons/locations/ic_location_notification.png'),
  nudistBeach('id_nudist_beach', 'Nudist Beach', 'assets/icons/locations/ic_location_nudist_beach.png'),
  park('id_park', 'Park', 'assets/icons/locations/ic_location_park.png'),
  restroom('id_restroom', 'Restroom', 'assets/icons/locations/ic_location_restroom.png'),
  sexShop('id_sex_shop', 'Sex Shop', 'assets/icons/locations/ic_location_sex_shop.png'),
  steamBath('id_steam_bath', 'Steam Bath', 'assets/icons/locations/ic_location_steam_bat.png'),
  unknown('id_unknown', 'User/Default', 'assets/icons/locations/ic_location_user.png');

  final String id;
  final String label;
  final String asset;

  const PlaceIcon(this.id, this.label, this.asset);

  static PlaceIcon fromId(String id) {
    return PlaceIcon.values.firstWhere(
          (icon) => icon.id == id,
      orElse: () => PlaceIcon.unknown,
    );
  }
}