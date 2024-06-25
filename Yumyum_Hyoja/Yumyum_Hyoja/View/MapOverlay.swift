import SwiftUI
import UIKit
import MapKit
import CoreLocation

struct MapOverlay: View {
    var coordinates: [CLLocationCoordinate2D]
    
    var body: some View {
        MapPolyline(coordinates: coordinates)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [5, 10]))
    }
}

struct MapPolyline: Shape {
    var coordinates: [CLLocationCoordinate2D]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Transform CLLocationCoordinate2D coordinates into the SwiftUI coordinate space
        for (index, coordinate) in coordinates.enumerated() {
            let point = MKMapPoint(coordinate)
            let cgPoint = CGPoint(
                x: point.x,
                y: point.y
            )

            if index == 0 {
                path.move(to: cgPoint)
            } else {
                path.addLine(to: cgPoint)
            }
        }

        return path
    }
}
