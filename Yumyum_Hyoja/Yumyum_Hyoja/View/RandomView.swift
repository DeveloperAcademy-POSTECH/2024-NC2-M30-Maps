//
//  RandomView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/17/24.
//

import SwiftUI
import CoreLocation

struct RandomView: View {
    @State private var images: [(name: String, image: UIImage, location: CLLocationCoordinate2D)] = [
            ("Sunicard", UIImage(named: "Sunicard")!, CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
//            ("Sunicard", UIImage(named: "Sunicard")!, CLLocationCooㅇrdinate2D(latitude: 36.0079529582591, longitude: 129.329425672387)),
//            ("Hongun_spot", UIImage(named: "Hongun_spot")!, CLLocationCoordinate2D(latitude: 36.0087180836111, longitude: 129.332544437547)),
//            ("Home_Sushi", UIImage(named: "Home_Sushi")!, CLLocationCoordinate2D(latitude: 36.0080964116588, longitude: 129.330458752437)),
//            ("Deoksu_Pasta", UIImage(named: "Deoksu_Pasta")!, CLLocationCoordinate2D(latitude: 36.007853673717, longitude: 129.330398930981))
        ]
    @State private var selectedImage: (name: String, image: UIImage, location: CLLocationCoordinate2D)?
    @State private var showImage = false
    @State private var showMapView = false

    var body: some View {
        NavigationView {
             VStack {
                 if showImage, let selectedImage = selectedImage {
                     Image(uiImage: selectedImage.image)
                         .resizable()
                         .aspectRatio(contentMode: .fit)

                         .padding()
                     
                     HStack {
                         Button(action: {
                             withAnimation {
                                 showImage = false
                             }
                         }) {
                             Image(systemName:"gobackward")
                                 .padding()
                                 .background(Color.blue)
                                 .foregroundColor(.white)
                                 .cornerRadius(8)
                         }
                         .padding()
                         
                         NavigationLink(destination: MapView(location: selectedImage.location)) {
                                 Text("길안내 시작")
                                     .padding()
                                     .background(Color.green)
                                     .foregroundColor(.white)
                                     .cornerRadius(8)
                             
                         }
                         .padding()
                     }
                 } else {
                     ZStack {
                         LottieView(filename: "Animation - test")
                     }
                 }
             }
         }
     }
     
     private func selectRandomImage() {
         selectedImage = images.randomElement()
     }
 }

 struct RandomView_Previews: PreviewProvider {
     static var previews: some View {
         RandomView()
     }
 }
