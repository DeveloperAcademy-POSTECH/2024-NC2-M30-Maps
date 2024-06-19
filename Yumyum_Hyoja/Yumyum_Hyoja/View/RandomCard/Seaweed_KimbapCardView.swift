//
//  Seaweed_KimbapCardView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/18/24.
//



import SwiftUI
import CoreLocation

struct SeaweedKimbapCardView: View {
    var destinationCoordinate: CLLocationCoordinate2D?
    @State private var walkingTime: String?

    var body: some View {
        VStack {
            Image("Seaweed_KimbapCardView")
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
                DirectionsHelper.calculateWalkingTime(from: CLLocationCoordinate2D(latitude: 36.0080964116588, longitude: 129.330458752437), to: destinationCoordinate) { time in
                    self.walkingTime = time
                }
            }
        }
    }
}

struct SeaweedKimbapCardView_Previews: PreviewProvider {
    static var previews: some View {
        SeaweedKimbapCardView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.0080964116588, longitude: 129.330458752437)) // 적절한 좌표를 전달해주세요
    }
}
