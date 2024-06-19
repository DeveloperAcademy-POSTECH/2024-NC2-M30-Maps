//
//  RandomcardView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/19/24.
//


import SwiftUI
import CoreLocation

struct RandomCardView: View {
    var destinationCoordinate: CLLocationCoordinate2D?
    @State private var selectedCard: String = ""

    var body: some View {
        VStack {
            if selectedCard == "SuniCardView" {
                Image("SuniCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else if selectedCard == "HongunSpotCard" {
                Image("HongunSpotCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else if selectedCard == "DeoksuPastaCard" {
                Image("DeoksuPastaCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else if selectedCard == "SeaweedKimbapCard" {
                Image("SeaweedKimbapCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onAppear {
            selectRandomCard()
        }
    }
    
    private func selectRandomCard() {
        let cards = ["SuniCardView", "HongunSpotCard", "DeoksuPastaCard", "SeaweedKimbapCard"]
        selectedCard = cards.randomElement() ?? ""
    }
}

struct RandomCardView_Previews: PreviewProvider {
    static var previews: some View {
        RandomCardView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
    }
}
