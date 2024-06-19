////
////  RandomcardViewPilot.swift
////  Yumyum_Hyoja
////
////  Created by 이찬유 on 6/19/24.
////
//
//import SwiftUI
//import CoreLocation
//
//struct CardView: Identifiable {
//    var id = UUID()
//    var CardImage: String
//    var CardName: String
//    var CardType: String
//    var CardMenu: String
//    var CardTime: String
//    var CardRest: String?
//    var CardNumber: String
//}
//
//var CardList: [CardView] = [
//CardView(CardImage: "Hongun_Card", CardName: "홍운반점", CardType: "중식당", CardMenu: "간짜장\n탕수육", CardTime: "11:00 ~ 20:00", CardRest: "매주 화 휴무", CardNumber: "054-283-2727"),
//
//CardView(CardImage: "Pasta_Card", CardName: "덕수파스타", CardType: "이탈리안", CardMenu: "땡초크림파스타", CardTime: "10:30 ~ 21:00", CardRest: "라스트오더 20:00" ,CardNumber: "010-7742-3193"),
//
//CardView(CardImage: "Kimbab_Card", CardName: "김고미김밥", CardType: "분식", CardMenu: "묵은지삼겹김밥", CardTime: "08:30 ~ 20:00", CardNumber: "054-282-0808")
//]
//
//struct RandomcardViewPilot: View {
//    var destinationCoordinate: CLLocationCoordinate2D?
//    // destinationCoordinate 변수는 선택된 목적지의 좌표를 저장
//    @State private var selectedCard: String = ""
//    // @State 속성인 selectedCard는 무작위로 선택된 카드의 이름을 저장
//    
//    @State private var card = CardList.randomElement()!
////    @State var Rendomcard: CardView
//    
//    var body: some View {
//        VStack {
//            
//            ZStack {
//                Rectangle()
//                    .frame(width: 345, height: 535)
//                    .cornerRadius(20)
//                    .foregroundStyle(.white)
//                    .shadow(radius: 4)
//                
//                VStack {
//                    
//                    HStack {
//                        Text(card.CardType)
//                            .font(Font.custom("Cafe24SsurroundairOTF", size: 16))
//                        
//                        Spacer()
//                    } .padding(.horizontal, 50)
//                    
//                    HStack {
//                        Text(card.CardName)
//                            .font(Font.custom("LOTTERIACHAB", size: 48))
//                        
//                        Spacer()
//                    } 
//                    .padding(.horizontal, 50)
//                    
//                    Image(card.CardImage)
//                        .resizable()
//                        .frame(width: 200, height: 200)
//                    
//                    HStack {
//                        Text("추천\n메뉴")
//                            .font(Font.custom("Cafe24SsurroundairOTF", size: 16))
//                            .foregroundStyle(Color(red: 0.3, green: 0.5, blue: 1))
//                        
//                        Text(card.CardMenu)
//                            .font(.custom("Cafe24SsurroundairOTF", size: 26))
//                        
//                        Spacer()
//                    } 
//                    .padding(.horizontal, 50)
//                    .padding(.bottom, 4)
//                    
//                    HStack {
//                        Text(card.CardTime)
//                            .font(.custom("Cafe24SsurroundairOTF", size: 18))
//                        Text(card.CardRest ?? "")
//                            .font(.custom("Cafe24SsurroundairOTF", size: 18))
//                            .foregroundStyle(.red)
//                        
//                        Spacer()
//                    } 
//                    .padding(.horizontal, 50)
//                    .padding(.bottom, 10)
//                    
//                    HStack {
//                        Text(card.CardNumber)
//                            .font(.custom("Cafe24SsurroundairOTF", size: 20))
//                            .foregroundStyle(.gray)
//                        
//                        Spacer()
//                    } .padding(.horizontal, 50)
//                    
//                }
//            }
//            
//            HStack {
//                Button(action: {
//                    var newCard: CardView
//                    repeat {
//                        newCard = CardList.randomElement()!
//                    } while newCard.id == card.id
//                    self.card = newCard
//                }) {
//                    Rectangle()
//                        .frame(width: 80, height: 80)
//                        .cornerRadius(20)
//                        .overlay {
//                            Image(systemName: "arrow.clockwise")
//                                .foregroundColor(.white)
//                                .font(.title)
//                                .bold()
//                        }
//                }
//                
//                NavigationLink {
//                    
//                } label: {
//                    Rectangle()
//                        .frame(width: 274, height: 80)
//                        .cornerRadius(20)
//                        .foregroundStyle(Color(red: 1, green: 0.5,blue: 0.3))
//                        .overlay {
//                        Text("길 안내 시작")
//                                .font(.custom("Cafe24SsurroundairOTF", size: 24))
//                                .foregroundStyle(.white)
//                    }
//                    
//                }
//
//            }
//            .padding(.top, 40)
//        }
//    }
//}
//
//#Preview {
//    RandomcardViewPilot()
//}
