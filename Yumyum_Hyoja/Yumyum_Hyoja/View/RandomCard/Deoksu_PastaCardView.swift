//
//  Deoksu_PastaCardView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/18/24.
//

import SwiftUI
import CoreLocation

struct DeoksuPastaCardView: View {
    var destinationCoordinate: CLLocationCoordinate2D?
    @State private var walkingTime: String?

    var body: some View {
        VStack {
            Image("Deoksu_PastaCardView")
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
                DirectionsHelper.calculateWalkingTime(from: CLLocationCoordinate2D(latitude: 36.007853673717, longitude: 129.330398930981), to: destinationCoordinate) { time in
                    self.walkingTime = time
                }
            }
        }
    }
}

struct DeoksuPastaCardView_Previews: PreviewProvider {
    static var previews: some View {
        DeoksuPastaCardView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.007853673717, longitude: 129.330398930981)) // 적절한 좌표를 전달해주세요
    }
}
