//
//  MapMarkerAnnotation.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/25/24.
//

import CoreLocation

struct MapMarkerAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var isCurrentLocation: Bool
}
