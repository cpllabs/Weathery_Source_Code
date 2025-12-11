import 'package:flutter/material.dart';

class WeatherOutfitService {
  // 1. Refined Data Store
  static const Map<String, Map<String, Map<String, List<String>>>> _clothingData = {
    "sunny": {
      "below0": {
        "colors": [
          "Dark Blue",
          "Black",
          "Burgundy",
          "Forest Green"
        ],
        "cloths": [
          "Heavy Winter Coat",
          "Thermal Underwear",
          "Wool Sweater",
          "Insulated Pants",
          "Winter Boots",
          "Warm Hat",
          "Gloves",
          "Scarf"
        ],
        "material": [
          "Wool",
          "Down",
          "Fleece",
          "Thermal Knit",
          "Thick Cotton"
        ]
      },
      "0-10": {
        "colors": [
          "Navy",
          "Gray",
          "Burgundy",
          "Olive Green"
        ],
        "cloths": [
          "Winter Coat",
          "Sweater",
          "Long-Sleeve Shirt",
          "Trousers",
          "Closed Shoes",
          "Light Scarf"
        ],
        "material": [
          "Wool",
          "Fleece",
          "Cotton Blend",
          "Denim"
        ]
      },
      "11-20": {
        "colors": [
          "Light Blue",
          "Beige",
          "Pastels",
          "White"
        ],
        "cloths": [
          "Light Jacket",
          "Cardigan",
          "Long-Sleeve Shirt",
          "Jeans",
          "Sneakers"
        ],
        "material": [
          "Cotton",
          "Linen",
          "Light Wool",
          "Denim"
        ]
      },
      "21-30": {
        "colors": [
          "White",
          "Light Colors",
          "Pastels",
          "Khaki"
        ],
        "cloths": [
          "T-Shirt",
          "Shorts",
          "Light Trousers",
          "Sandals",
          "Sun Hat"
        ],
        "material": [
          "Cotton",
          "Linen",
          "Breathable Fabrics",
          "Seersucker"
        ]
      },
      "31-100": {
        "colors": [
          "White",
          "Light Colors",
          "Bright Colors"
        ],
        "cloths": [
          "Tank Top",
          "Shorts",
          "Light Dress",
          "Sandals",
          "Sun Hat",
          "Sunglasses"
        ],
        "material": [
          "Linen",
          "Cotton",
          "Moisture-Wicking Fabrics",
          "Rayon"
        ]
      }
    },
    "cloudy": {
      "below0": {
        "colors": [
          "Dark Colors",
          "Gray",
          "Navy",
          "Black"
        ],
        "cloths": [
          "Heavy Winter Coat",
          "Thermal Layers",
          "Wool Sweater",
          "Insulated Pants",
          "Winter Boots",
          "Beanie",
          "Gloves"
        ],
        "material": [
          "Wool",
          "Down",
          "Fleece",
          "Thermal Materials"
        ]
      },
      "0-10": {
        "colors": [
          "Medium Colors",
          "Gray",
          "Navy",
          "Burgundy"
        ],
        "cloths": [
          "Warm Coat",
          "Sweater",
          "Long Pants",
          "Closed Shoes",
          "Light Hat"
        ],
        "material": [
          "Wool Blend",
          "Fleece",
          "Cotton",
          "Corduroy"
        ]
      },
      "11-20": {
        "colors": [
          "Medium Colors",
          "Olive Green",
          "Tan",
          "Navy"
        ],
        "cloths": [
          "Light Jacket",
          "Sweater",
          "Long-Sleeve Shirt",
          "Jeans",
          "Sneakers"
        ],
        "material": [
          "Cotton",
          "Light Wool",
          "Polyester Blend",
          "Denim"
        ]
      },
      "21-30": {
        "colors": [
          "Light Colors",
          "Pastels",
          "Khaki",
          "Light Gray"
        ],
        "cloths": [
          "T-Shirt",
          "Light Sweater",
          "Trousers",
          "Comfortable Shoes"
        ],
        "material": [
          "Cotton",
          "Linen",
          "Breathable Blends"
        ]
      },
      "31-100": {
        "colors": [
          "Light Colors",
          "White",
          "Pastels"
        ],
        "cloths": [
          "Light T-Shirt",
          "Shorts",
          "Breathable Trousers",
          "Comfortable Shoes"
        ],
        "material": [
          "Cotton",
          "Linen",
          "Moisture-Wicking Fabrics"
        ]
      }
    },
    "rainy": {
      "below0": {
        "colors": [
          "Dark Colors",
          "Black",
          "Navy",
          "Dark Green"
        ],
        "cloths": [
          "Waterproof Winter Coat",
          "Thermal Layers",
          "Waterproof Pants",
          "Insulated Boots",
          "Waterproof Hat"
        ],
        "material": [
          "Waterproof Fabrics",
          "Gore-Tex",
          "Rubber",
          "Treated Wool"
        ]
      },
      "0-10": {
        "colors": [
          "Dark Colors",
          "Navy",
          "Black",
          "Dark Gray"
        ],
        "cloths": [
          "Raincoat",
          "Waterproof Jacket",
          "Waterproof Pants",
          "Gum Boots",
          "Umbrella"
        ],
        "material": [
          "Waterproof Materials",
          "Rubber",
          "Treated Cotton",
          "Nylon"
        ]
      },
      "11-20": {
        "colors": [
          "Medium-Dark Colors",
          "Navy",
          "Olive",
          "Burgundy"
        ],
        "cloths": [
          "Waterproof Jacket",
          "Water-Resistant Pants",
          "Waterproof Shoes",
          "Umbrella",
          "Light Sweater"
        ],
        "material": [
          "Water-Resistant Fabrics",
          "Nylon",
          "Treated Cotton",
          "Polyester"
        ]
      },
      "21-30": {
        "colors": [
          "Medium Colors",
          "Khaki",
          "Navy",
          "Gray"
        ],
        "cloths": [
          "Light Rain Jacket",
          "Quick-Dry Pants",
          "Water-Resistant Shoes",
          "Umbrella"
        ],
        "material": [
          "Water-Resistant Fabrics",
          "Quick-Dry Materials",
          "Nylon",
          "Polyester"
        ]
      },
      "31-100": {
        "colors": [
          "Light Colors",
          "Pastels",
          "White"
        ],
        "cloths": [
          "Breathable Rain Jacket",
          "Quick-Dry Shorts",
          "Water-Friendly Sandals",
          "Umbrella"
        ],
        "material": [
          "Breathable Waterproof Fabrics",
          "Quick-Dry Materials",
          "Nylon"
        ]
      }
    },
    "snowy": {
      "below0": {
        "colors": [
          "Bright Colors",
          "White",
          "Light Blue",
          "Red"
        ],
        "cloths": [
          "Insulated Winter Coat",
          "Snow Pants",
          "Thermal Layers",
          "Waterproof Boots",
          "Winter Hat",
          "Insulated Gloves",
          "Scarf"
        ],
        "material": [
          "Down",
          "Wool",
          "Fleece",
          "Waterproof Fabrics",
          "Thermal Materials"
        ]
      },
      "0-10": {
        "colors": [
          "Medium-Bright Colors",
          "Navy",
          "Burgundy",
          "Forest Green"
        ],
        "cloths": [
          "Winter Coat",
          "Waterproof Pants",
          "Warm Layers",
          "Waterproof Boots",
          "Warm Hat",
          "Gloves"
        ],
        "material": [
          "Wool",
          "Fleece",
          "Waterproof Materials",
          "Insulated Fabrics"
        ]
      }
    },
    "windy": {
      "below0": {
        "colors": [
          "Dark Colors",
          "Black",
          "Navy",
          "Dark Gray"
        ],
        "cloths": [
          "Windproof Winter Coat",
          "Windproof Pants",
          "Thermal Layers",
          "Winter Boots",
          "Balaclava",
          "Windproof Gloves"
        ],
        "material": [
          "Windproof Fabrics",
          "Gore-Tex",
          "Tight-Knit Wool",
          "Fleece"
        ]
      },
      "0-10": {
        "colors": [
          "Medium-Dark Colors",
          "Navy",
          "Gray",
          "Burgundy"
        ],
        "cloths": [
          "Windbreaker",
          "Windproof Jacket",
          "Layered Clothing",
          "Long Pants",
          "Closed Shoes",
          "Scarf"
        ],
        "material": [
          "Wind-Resistant Fabrics",
          "Nylon",
          "Polyester",
          "Wool Blend"
        ]
      },
      "11-20": {
        "colors": [
          "Medium Colors",
          "Khaki",
          "Olive",
          "Navy"
        ],
        "cloths": [
          "Windbreaker",
          "Light Jacket",
          "Long-Sleeve Shirt",
          "Trousers",
          "Comfortable Shoes"
        ],
        "material": [
          "Wind-Resistant Fabrics",
          "Cotton Blend",
          "Polyester",
          "Nylon"
        ]
      },
      "21-30": {
        "colors": [
          "Light Colors",
          "Pastels",
          "White",
          "Light Gray"
        ],
        "cloths": [
          "Light Windbreaker",
          "Long-Sleeve Shirt",
          "Light Trousers",
          "Comfortable Shoes"
        ],
        "material": [
          "Light Wind-Resistant Fabrics",
          "Cotton",
          "Linen Blend"
        ]
      },
      "31-100": {
        "colors": [
          "Light Colors",
          "White",
          "Pastels"
        ],
        "cloths": [
          "Light Long-Sleeve Shirt",
          "Breathable Trousers",
          "Comfortable Shoes"
        ],
        "material": [
          "Breathable Fabrics",
          "Cotton",
          "Linen"
        ]
      }
    }
  };
  // 2. Helpers
  static String _getTempKey(double temp) {
    if (temp < 0) return "below0";
    if (temp >= 0 && temp <= 10) return "0-10";
    if (temp > 10 && temp <= 20) return "11-20";
    if (temp > 20 && temp <= 30) return "21-30";
    return "31-100";
  }

  static String _normalizeWeatherKey(String description) {
    description = description.toLowerCase();
    if (description.contains("rain") || description.contains("drizzle") || description.contains("thunder")) return "rainy";
    if (description.contains("snow") || description.contains("sleet") || description.contains("ice")) return "snowy";
    if (description.contains("clear") || description.contains("sun")) return "sunny";
    if (description.contains("wind") || description.contains("breeze")) return "windy";
    return "cloudy";
  }

  // 3. Main Function
  static Map<String, List<String>> getOutfitRecommendations({
    required double temperature,
    required String currentDescription,
    required int uvIndex,
  }) {
    String weatherKey = _normalizeWeatherKey(currentDescription);
    String tempKey = _getTempKey(temperature);

    // Defensive fetch: Try exact match -> Fallback to cloudy -> Fallback to empty
    var weatherData = _clothingData[weatherKey];
    if (weatherData == null || !weatherData.containsKey(tempKey)) {
      weatherData = _clothingData["cloudy"];
    }

    var attributes = weatherData?[tempKey];
    if (attributes == null) {
      return {"colors": [], "cloths": ["No data available"], "material": []};
    }

    // Use Sets to prevent duplicates if we modify lists dynamically
    Set<String> finalCloths = Set.from(attributes["cloths"] ?? []);
    Set<String> finalColors = Set.from(attributes["colors"] ?? []);
    Set<String> finalMaterials = Set.from(attributes["material"] ?? []);

    // UV Index Logic
    if (uvIndex >= 6 && weatherKey != "rainy" && weatherKey != "snowy") {
      finalCloths.addAll(["sunglasses", "sun hat"]);
      // Remove dark colors that absorb heat if it's hot
      if (temperature > 20) {
        finalColors.removeWhere((c) => c.contains("black") || c.contains("dark"));
        finalColors.add("white");
      }
    }

    return {
      "colors": finalColors.toList(),
      "cloths": finalCloths.toList(),
      "material": finalMaterials.toList(),
    };


  }
}

class OutfitColorMapper {

  /// Returns a LinearGradient for a given color name string.
  /// Used for UI chips, backgrounds, or text highlights.
  static LinearGradient getGradient(String colorName) {
    final String key = colorName.toLowerCase().trim();

    // 1. Check Broad Categories (Actual Gradients)
    if (_broadRangeGradients.containsKey(key)) {
      return _broadRangeGradients[key]!;
    }

    // 2. Check Specific Colors (Solid Colors mapped to Gradient)
    if (_solidColors.containsKey(key)) {
      Color c = _solidColors[key]!;
      return LinearGradient(colors: [c, c]);
    }

    // 3. Fallback (Grey)
    return const LinearGradient(colors: [Colors.grey, Colors.blueGrey]);
  }

  // --- Definitions ---

  static final Map<String, LinearGradient> _broadRangeGradients = {
    // Light & Airy
    "pastels": const LinearGradient(
      colors: [Color(0xFFF8BBD0), Color(0xFFE1BEE7), Color(0xFFB2DFDB)], // Pink -> Purple -> Teal
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    ),
    "light colors": const LinearGradient(
      colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)], // Off-white -> Light Grey
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    ),
    "white": const LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
    ),
    "bright colors": const LinearGradient(
      colors: [Color(0xFFFF5252), Color(0xFFFFEB3B), Color(0xFF00E676)], // Red -> Yellow -> Green
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    ),

    // Medium Tones
    "medium colors": const LinearGradient(
      colors: [Color(0xFF7986CB), Color(0xFF9575CD)], // Indigo -> Deep Purple
    ),
    "medium tones": const LinearGradient(
      colors: [Color(0xFF7986CB), Color(0xFF64B5F6)],
    ),
    "medium-bright colors": const LinearGradient(
      colors: [Color(0xFF26C6DA), Color(0xFF42A5F5)], // Cyan -> Blue
    ),

    // Dark & Heavy
    "dark colors": const LinearGradient(
      colors: [Color(0xFF212121), Color(0xFF37474F)], // Black -> Blue Grey
    ),
    "medium-dark colors": const LinearGradient(
      colors: [Color(0xFF455A64), Color(0xFF37474F)],
    ),

    // Gradients for multiple specific mentions in one string
    "medium-bright": const LinearGradient(colors: [Color(0xFFFFA726), Color(0xFFEF5350)]),
  };

  static final Map<String, Color> _solidColors = {
    // Blues
    "navy": Color(0xFF001F3F),
    "dark blue": Color(0xFF0D47A1),
    "light blue": Color(0xFFB3E5FC),

    // Greens
    "forest green": Color(0xFF2E7D32),
    "olive green": Color(0xFF556B2F),
    "olive": Color(0xFF808000),
    "dark green": Color(0xFF1B5E20),

    // Reds/Pinks
    "burgundy": Color(0xFF800020),
    "red": Color(0xFFD32F2F),

    // Neutrals
    "black": Color(0xFF000000),
    "gray": Color(0xFF9E9E9E),
    "dark gray": Color(0xFF616161),
    "light gray": Color(0xFFEEEEEE),
    "beige": Color(0xFFF5F5DC),
    "khaki": Color(0xFFC3B091),
    "tan": Color(0xFFD2B48C),
    "medium tones": Color(0xFF757575),
  };
}