//
//  MapOverlay.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/20/24.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation

struct MapOverlay: View {
    var route: MKRoute
    
    var body: some View {
        MapPolyline(route: route)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [5, 10]))
    }
}

struct MapPolyline: Shape {
    var route: MKRoute

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Transform MKPolyline coordinates into the SwiftUI coordinate space
        let polyline = route.polyline
        let points = polyline.points()
        for i in 0..<polyline.pointCount {
            let coordinate = points[i].coordinate
            let point = MKMapPoint(coordinate)
            let cgPoint = CGPoint(
                x: point.x,
                y: point.y
            )

            if i == 0 {
                path.move(to: cgPoint)
            } else {
                path.addLine(to: cgPoint)
            }
        }

        return path
    }
}
