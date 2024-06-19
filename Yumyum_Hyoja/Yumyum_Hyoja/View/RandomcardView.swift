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
    // destinationCoordinate 변수는 선택된 목적지의 좌표를 저장
    @State private var selectedCard: String = ""
    // @State 속성인 selectedCard는 무작위로 선택된 카드의 이름을 저장
    
    var body: some View {
        VStack {
            if selectedCard == "SuniCardView" {
                Image("SuniCard")
                    .resizable()
                     // 이미지를 크기 조절 가능
                    .aspectRatio(contentMode: .fit)
                    // 이미지의 종횡비를 유지하면서 화면에 맞게 조정
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
        .cornerRadius(12) // 카드 모서리를 둥글게
        .shadow(radius: 4) // 카드에 그림자를 추가
        .onAppear {
            selectRandomCard()
        }
         // onAppear는 뷰가 나타날 때 selectRandomCard() 메서드를 호출하여 무작위 카드를 선택
    }
    
    private func selectRandomCard() {
        let cards = ["SuniCardView", "HongunSpotCard", "DeoksuPastaCard", "SeaweedKimbapCard"]
        // selectRandomCard() 메서드는 카드 배열에서 무작위로 하나의 카드를 선택하여 selectedCard에 저장
        selectedCard = cards.randomElement() ?? ""
        // cards 배열에는 네 가지 카드 이름이 포함, randomElement() 메서드는 배열에서 무작위 요소를 반환, ?? ""는 무작위 요소가 nil인 경우 빈 문자열을 반환
    }
}

//struct RandomCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        RandomCardView(destinationCoordinate: CLLocationCoordinate2D(latitude: 36.0079529582591, longitude: 129.329425672387))
//    }
//}
