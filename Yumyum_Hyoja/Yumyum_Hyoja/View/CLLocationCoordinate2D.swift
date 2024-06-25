//
//  CLLocationCoordinate2D.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/19/24.
//
//
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
