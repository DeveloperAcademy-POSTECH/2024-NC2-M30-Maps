//
//  DirectionsHelper.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/19/24.
//

import Foundation
import CoreLocation
import MapKit

class DirectionsHelper {
    
    static func calculateWalkingTime(from startCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let request = MKDirections.Request()
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                if let error = error {
                    print("Error calculating directions: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            
            let travelTime = route.expectedTravelTime
            let formattedTime = formatTime(seconds: travelTime)
            completion(formattedTime)
        }
    }
    
    private static func formatTime(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        return formatter.string(from: seconds) ?? ""
    }
}

