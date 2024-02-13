class PopulateCountriesWithContinent < ActiveRecord::Migration[6.0]
  def change
    europe = [
      "Austria",
      "Belgium",
      "Bulgaria",
      "Cyprus",
      "Denmark",
      "Spain",
      "Finland",
      "France",
      "Greece",
      "Hungary",
      "Ireland",
      "Italy",
      "Luxembourg",
      "Malta",
      "Netherlands",
      "Poland",
      "Portugal",
      "Germany",
      "Rumanía",
      "Sweden",
      "Latvia",
      "Estonia",
      "Lithuania",
      "Czech Republic",
      "Slovak Republic",
      "Croatia",
      "Slovenia",
      "Albania",
      "Iceland",
      "Liechtenstein",
      "Monaco",
      "Norway",
      "Andorra",
      "United Kingdom",
      "San Marino",
      "Holy See",
      "Switzerland",
      "Ukraine",
      "Moldova",
      "Belarus",
      "Georgia",
      "Bosnia and Herzegovina",
      "Armenia",
      "Russia",
      "Macedonia ",
      "Serbia",
      "Montenegro",
      "Turkey"
    ]

    africa = [
      "Burkina Faso",
      "Angola",
      "Algeria",
      "Benin",
      "Botswana",
      "Burundi",
      "Cape Verde",
      "Cameroon",
      "Union of Comoros",
      "Congo",
      "Ivory Coast",
      "Djibouti",
      "Egytp",
      "Ethiopia",
      "Gabon",
      "Gambia",
      "Ghana",
      "Guinea",
      "Guinea-Bissau",
      "Equatorial Guinea ",
      "Kenya",
      "Lesotho",
      "Liberia",
      "Libya",
      "Madagascar",
      "Malawi",
      "Mali",
      "Morocco",
      "Mauritius",
      "Mauritania",
      "Mozambique",
      "Namibia",
      "Níger",
      "Nigeria",
      "Central African Republic",
      "South Africa",
      "Rwanda",
      "Sao Tomé and Príncipe",
      "Senegal",
      "Seychelles",
      "Sierra Leone",
      "Somalia",
      "Sudan",
      "Swaziland",
      "Tanzania",
      "Chad",
      "Togo",
      "Tunisia",
      "Uganda",
      "Democratic Republic of the Congo",
      "Zambia",
      "Zimbabwe",
      "Eritrea",
      "South Sudan",
    ]

    north_america = [
      "Canada",
      "The United States of America",
      "Mexico"
    ]

    central_america_and_caribe = [
      "Antigua y Barbuda",
      "Bahamas",
      "Barbados",
      "Belize",
      "Costa Rica",
      "Cuba",
      "Dominique",
      "El Salvador",
      "Grenada",
      "Guatemala",
      "Haiti",
      "Honduras",
      "Jamaica",
      "Nicaragua",
      "Panama",
      "Saint Vincent and the Grenadines",
      "Dominican Republic",
      "Trinidad and Tobago",
      "Saint Lucia",
      "Saint Kitts and Neviss"
    ]

    south_america = [
      "Argentina",
      "Bolivia",
      "Brazil",
      "Colombia",
      "Chile",
      "Ecuador",
      "Guyana",
      "Paraguay",
      "Peru",
      "Surinam",
      "Uruguay",
      "Venezuela"
    ]

    asia = [
      "Afghanistan",
      "Saudi Arabia",
      "Bahrain",
      "Bangladesh",
      "Myanmar",
      "China",
      "United Arab Emirates",
      "Philippines",
      "India",
      "Indonesia",
      "Iraq",
      "Iran",
      "Israel",
      "Japan",
      "Jordan",
      "Cambodia",
      "Kuwait",
      "Laos",
      "Lebanon",
      "Malaysia",
      "Maldives",
      "Mongolia",
      "Nepal",
      "Oman",
      "Pakistan",
      "Qatar",
      "Korea",
      "North Korea",
      "Singapore",
      "Syria",
      "Sri Lanka",
      "Thailand",
      "Vietnam",
      "Brunei",
      "Marshall Islands",
      "Yemen",
      "Azerbaijan",
      "Kazakhstán",
      "Kirgyzstan",
      "Tajikistan",
      "Turkmeinetan",
      "Uzbekistan",
      "Bhutan",
      "Palestine"
    ]

    oceania = [
      "Australia",
      "Fiji",
      "New Zeland",
      "Papua New Guinea",
      "Solomon Islands",
      "Samoa",
      "Tonga",
      "Vanuatu",
      "Micronesia",
      "Tuvalu",
      "Cook Islands",
      "Kiribati",
      "Nauru",
      "Palau",
      "East Timor"
    ]

    Country.all.each do |country|
      if europe.include? country.name_eng
        country.update_columns(continent: "Europe")
      elsif africa.include? country.name_eng
        country.update_columns(continent: "Africa")
      elsif north_america.include? country.name_eng
        country.update_columns(continent: "North America")
      elsif central_america_and_caribe.include? country.name_eng
        country.update_columns(continent: "Central America and Caribe")
      elsif south_america.include? country.name_eng
        country.update_columns(continent: "South America")
      elsif asia.include? country.name_eng
        country.update_columns(continent: "Asia")
      elsif oceania.include? country.name_eng
        country.update_columns(continent: "Oceania")
      end
    end

  end
end
