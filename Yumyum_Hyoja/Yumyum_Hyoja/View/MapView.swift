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
    var destinationCoordinate: CLLocationCoordinate2D
    
    @State private var region: MKCoordinateRegion
    @State private var directions: [MKRoute] = []
    @State private var showDirections = false
    @State private var navigationActive = false // NavigationLink 활성화 여부를 나타내는 상태 변수 추가
    
    init(destinationCoordinate: CLLocationCoordinate2D) {
        self.destinationCoordinate = destinationCoordinate
        self._region = State(initialValue: MKCoordinateRegion(
            center: destinationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: destinationCoordinate)]) { location in
                MapMarker(coordinate: location.coordinate, tint: .red)
            }
            .onAppear {
                calculateDirections()
            }
            
            if showDirections {
                Text("도보 예상 시간: \(formattedTravelTime())")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    navigationActive = true // 도착 버튼을 누르면 NavigationLink 활성화
                }) {
                    Text("도착")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline) // 이 부분을 추가하여 Navigation Bar 타이틀을 inline으로 설정
        .background(
            NavigationLink(destination: UghView(), isActive: $navigationActive) {
                EmptyView()
            }
        )
    }
    
    private func calculateDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.01403091416389, longitude: 129.32595552359552)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print("경로를 찾을 수 없음: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            self.directions = [route]
            self.showDirections = true
            
            // Adjust map region to fit route
//            self.region = MKCoordinateRegion(route.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    private func formattedTravelTime() -> String {
        guard let route = directions.first else { return "" }
        let travelTime = Int(route.expectedTravelTime / 60)
        return "\(travelTime)분"
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.0083109245033, longitude: 129.331608703121))
    }
}
