import 'dart:math';

class CarBrand {
    final int id;
    final String name;
    final String imageUrl;
     int make_count;
    final bool isAllCars;

    CarBrand({
      int? id,
      required this.name,
      required this.imageUrl,
      this.isAllCars = false,
      required this.make_count,
    }) : id = id ?? Random().nextInt(10);

  // Comprehensive list of car brands with their logo URLs
  // static List<CarBrand> get brands => [
  //       CarBrand(
  //         id: 'all',
  //         name: 'All Cars',
  //         imageUrl: 'assets/images/ic_all_cars.png',
  //         isAllCars: true,
  //       ),
  //       // Japanese
  //       CarBrand(name: 'Toyota', imageUrl: 'https://www.carlogos.org/logo/Toyota-logo-1920x1080.png'),
  //       CarBrand(name: 'Nissan', imageUrl: 'https://www.carlogos.org/logo/Nissan-logo-2020-1920x1080.png'),
  //       CarBrand(name: 'Honda', imageUrl: 'https://www.carlogos.org/logo/Honda-logo-1920x1080.png'),
  //       CarBrand(name: 'Mazda', imageUrl: 'https://www.carlogos.org/logo/Mazda-logo-1997-1920x1080.png'),
  //       CarBrand(name: 'Mitsubishi', imageUrl: 'https://www.carlogos.org/logo/Mitsubishi-logo-1990-1920x1080.png'),
  //       CarBrand(name: 'Subaru', imageUrl: 'https://www.carlogos.org/logo/Subaru-logo-2003-1920x1080.png'),
  //       CarBrand(name: 'Lexus', imageUrl: 'https://www.carlogos.org/logo/Lexus-logo-1988-1920x1080.png'),
  //       CarBrand(name: 'Infiniti', imageUrl: 'https://www.carlogos.org/logo/Infiniti-logo-1920x1080.png'),
  //       CarBrand(name: 'Acura', imageUrl: 'https://www.carlogos.org/logo/Acura-logo-1989-1920x1080.png'),
  //       CarBrand(name: 'Suzuki', imageUrl: 'https://www.carlogos.org/logo/Suzuki-logo-2003-1920x1080.png'),
  //
  //       // German
  //       CarBrand(name: 'BMW', imageUrl: 'https://www.carlogos.org/logo/BMW-logo-2020-1920x1080.png'),
  //       CarBrand(name: 'Mercedes', imageUrl: 'https://www.carlogos.org/logo/Mercedes-Benz-logo-2011-1920x1080.png'),
  //       CarBrand(name: 'Audi', imageUrl: 'https://www.carlogos.org/logo/Audi-logo-2009-1920x1080.png'),
  //       CarBrand(name: 'Volkswagen', imageUrl: 'https://www.carlogos.org/logo/Volkswagen-logo-2019-1920x1080.png'),
  //       CarBrand(name: 'Porsche', imageUrl: 'https://www.carlogos.org/logo/Porsche-logo-1920x1080.png'),
  //       CarBrand(name: 'Opel', imageUrl: 'https://www.carlogos.org/logo/Opel-logo-2009-1920x1080.png'),
  //
  //       // American
  //       CarBrand(name: 'Ford', imageUrl: 'https://www.carlogos.org/logo/Ford-logo-2003-1920x1080.png'),
  //       CarBrand(name: 'Chevrolet', imageUrl: 'https://www.carlogos.org/logo/Chevrolet-logo-2013-1920x1080.png'),
  //       CarBrand(name: 'Jeep', imageUrl: 'https://www.carlogos.org/logo/Jeep-logo-2013-1920x1080.png'),
  //       CarBrand(name: 'Dodge', imageUrl: 'https://www.carlogos.org/logo/Dodge-logo-2011-1920x1080.png'),
  //       CarBrand(name: 'Chrysler', imageUrl: 'https://www.carlogos.org/logo/Chrysler-logo-2010-1920x1080.png'),
  //       CarBrand(name: 'Cadillac', imageUrl: 'https://www.carlogos.org/logo/Cadillac-logo-2014-1920x1080.png'),
  //       CarBrand(name: 'GMC', imageUrl: 'https://www.carlogos.org/logo/GMC-logo-1920x1080.png'),
  //
  //       // Korean
  //       CarBrand(name: 'Hyundai', imageUrl: 'https://www.carlogos.org/logo/Hyundai-logo-1920x1080.png'),
  //       CarBrand(name: 'Kia', imageUrl: 'https://www.carlogos.org/logo/Kia-logo-1920x1080.png'),
  //       CarBrand(name: 'Genesis', imageUrl: 'https://www.carlogos.org/logo/Genesis-logo-2015-1920x1080.png'),
  //
  //       // European
  //       CarBrand(name: 'Volvo', imageUrl: 'https://www.carlogos.org/logo/Volvo-logo-2014-1920x1080.png'),
  //       CarBrand(name: 'Renault', imageUrl: 'https://www.carlogos.org/logo/Renault-logo-2015-1920x1080.png'),
  //       CarBrand(name: 'Peugeot', imageUrl: 'https://www.carlogos.org/logo/Peugeot-logo-2021-1920x1080.png'),
  //       CarBrand(name: 'Citroen', imageUrl: 'https://www.carlogos.org/logo/Citroen-logo-2009-1920x1080.png'),
  //       CarBrand(name: 'Fiat', imageUrl: 'https://www.carlogos.org/logo/Fiat-logo-2006-1920x1080.png'),
  //       CarBrand(name: 'Alfa Romeo', imageUrl: 'https://www.carlogos.org/logo/Alfa-Romeo-logo-2015-1920x1080.png'),
  //       CarBrand(name: 'Jaguar', imageUrl: 'https://www.carlogos.org/logo/Jaguar-logo-2012-1920x1080.png'),
  //       CarBrand(name: 'Land Rover', imageUrl: 'https://www.carlogos.org/logo/Land-Rover-logo-2011-1920x1080.png'),
  //       CarBrand(name: 'Mini', imageUrl: 'https://www.carlogos.org/logo/MINI-logo-2020-1920x1080.png'),
  //       CarBrand(name: 'Smart', imageUrl: 'https://www.carlogos.org/logo/Smart-logo-2019-1920x1080.png'),
  //
  //       // Luxury/Sports
  //       CarBrand(name: 'Ferrari', imageUrl: 'https://www.carlogos.org/logo/Ferrari-logo-1920x1080.png'),
  //       CarBrand(name: 'Lamborghini', imageUrl: 'https://www.carlogos.org/logo/Lamborghini-logo-1920x1080.png'),
  //       CarBrand(name: 'Maserati', imageUrl: 'https://www.carlogos.org/logo/Maserati-logo-2020-1920x1080.png'),
  //       CarBrand(name: 'Bentley', imageUrl: 'https://www.carlogos.org/logo/Bentley-logo-1920x1080.png'),
  //       CarBrand(name: 'Rolls-Royce', imageUrl: 'https://www.carlogos.org/logo/Rolls-Royce-logo-2020-1920x1080.png'),
  //       CarBrand(name: 'Aston Martin', imageUrl: 'https://www.carlogos.org/logo/Aston-Martin-logo-2003-1920x1080.png'),
  //       CarBrand(name: 'McLaren', imageUrl: 'https://www.carlogos.org/logo/McLaren-logo-2021-1920x1080.png'),
  //
  //       // Others
  //       CarBrand(name: 'Tesla', imageUrl: 'https://www.carlogos.org/logo/Tesla-logo-2008-1920x1080.png'),
  //       CarBrand(name: 'BYD', imageUrl: 'https://www.carlogos.org/logo/BYD-logo-2007-1920x1080.png'),
  //       CarBrand(name: 'Geely', imageUrl: 'https://www.carlogos.org/logo/Geely-logo-2014-1920x1080.png'),
  //     ];
}
