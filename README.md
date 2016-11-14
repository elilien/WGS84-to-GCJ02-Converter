# WGS84 to GCJ02 Converter
_Convert World Geodetic System 1984 coordinate to Mars Geodetic System(GCJ02)._

The WGS84 to GCJ02 Converter is written in Swift 3.0 and works on both iOS & macOS platform.

# Usage

`let initialLocation = CLLocation(latitude: 31.18201931, longitude: 121.60227630)`

`let convertedLocation = ELWGS84toGCJ02Converter.el_convert(wgs84Location: initialLocation)`
