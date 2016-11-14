//
//  ELWGS84toGCJ02Converter.swift
//  WGS84toGCJ02Converter
//
//  Created by Eli Lien on 11/14/16.
//  Copyright © 2016 Eli Lien. All rights reserved.
//

import CoreLocation

class ELWGS84toGCJ02Converter: NSObject {

    static let pi = 3.14159265358979324
    
    // MARK: - Krasovsky 1940
    //
    // a = 6378245.0, 1/f = 298.3
    // b = a * (1 - f)
    // ee = (a^2 - b^2) / a^2;
    
    static let a = 6378245.0
    static let ee = 0.00669342162296594323
    
    // MARK: - Check location is out of China
    
    private static func el_outOfChina(location: CLLocation) -> Bool {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        if lat < 0.8293 || lat > 55.8271 {
            return true
        }
        if lon < 72.004 || lon > 137.8347 {
            return true
        }
        return false
    }
    
    // MARK: - World Geodetic System -> Mars Geodetic System
    
    public static func el_convert(wgs84Location: CLLocation) -> CLLocation {
        var gcj02Location = CLLocation(latitude: 0.0, longitude: 0.0)
        if el_outOfChina(location: wgs84Location) {
            gcj02Location = wgs84Location
            return gcj02Location
        }
        let wgs84Lat = wgs84Location.coordinate.latitude
        let wgs84Lon = wgs84Location.coordinate.longitude
        var dLat = el_convertLat(x: wgs84Lon - 105.0, y: wgs84Lat - 35.0)
        var dLon = el_convertLon(x: wgs84Lon - 105.0, y: wgs84Lat - 35.0)
        let radLat = wgs84Lat / 180.0 * M_PI
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        let sqrtMagic = sqrt(magic)
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI)
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI)
        let gcj02Lat = wgs84Lat + dLat
        let gcj02Lon = wgs84Lon + dLon
        gcj02Location = CLLocation(latitude: gcj02Lat, longitude: gcj02Lon)
        return gcj02Location
    }
    
    private static func el_convertLat(x: Double, y: Double) -> Double {
        var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
        ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0
        return ret
    }
    
    private static func el_convertLon(x: Double, y: Double) -> Double {
        var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
        ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0
        return ret
    }
}
