//
//  Hongun_spotCardView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/18/24.
//

import SwiftUI
import CoreLocation

struct HongunSpotCardView: View {
    var destinationCoordinate: CLLocationCoordinate2D?
    @State private var walkingTime: String?

    var body: some View {
        VStack {
            Image("hongun_spot_card")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            if let walkingTime = walkingTime {
                Text("예상 도보 시간: \(walkingTime)")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onAppear {
            if let destinationCoordinate = destinationCoordinate {
                DirectionsHelper.calculateWalkingTime(from: CLLocationCoordinate2D(latitude: 36.0087180836111, longitude: 129.332544437547), to: destinationCoordinate) { time in
                    self.walkingTime = time
                }
            }
        }
    }
}

struct HongunSpotCardView_Previews: PreviewProvider {
    static var previews: some View {
        HongunSpotCardView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.0087180836111, longitude: 129.332544437547)) // 적절한 좌표를 전달해주세요
    }
}
