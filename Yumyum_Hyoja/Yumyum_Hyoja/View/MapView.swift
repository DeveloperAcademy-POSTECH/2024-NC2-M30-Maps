//
//  MapView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    var location: CLLocationCoordinate2D
    
    @State private var region: MKCoordinateRegion
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
        self._region = State(initialValue: MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [LocationAnnotation(coordinate: location)]) { location in
            MapMarker(coordinate: location.coordinate, tint: .red)
        }
        .navigationTitle("Map View")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationAnnotation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: CLLocationCoordinate2D(latitude: 36.0083109245033, longitude: 129.331608703121))
    }
}
