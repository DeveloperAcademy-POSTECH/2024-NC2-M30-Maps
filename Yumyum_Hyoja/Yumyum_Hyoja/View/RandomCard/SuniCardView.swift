//
//  SuniCardView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI
import CoreLocation

struct SuniCardView: View {
    var destinationCoordinate: CLLocationCoordinate2D?
    @State private var walkingTime: String?
    
    
    var body: some View {
        VStack {
            Image("sunicard_view")
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
                DirectionsHelper.calculateWalkingTime(from: CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387), to: destinationCoordinate) { time in
                    self.walkingTime = time
                }
            }
        }
    }
}

//struct SuniCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        SuniCardView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
//    }
//}

