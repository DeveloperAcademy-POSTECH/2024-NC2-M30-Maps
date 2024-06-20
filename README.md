# 2024-NC2-M30-Maps

![NC2 Act 키노트 양식 001](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M30-Maps/assets/168837565/13ffb18d-a22d-4d78-97dc-66ba340ed67f)

## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Maps
- Mapkit을 통하여 지도에 마커 추가, 지도 범위 지정, 확대 및 축소, 위도 및 경도로 표시, 사용자 위치 설정하는 법을 배우게 되었다.
- UIKit을 활용하여 Maker를 custom하는 방법을 배우게 되었다. 
- Mapkit과 CoreLocation으로 다양한 지도 스타일 변경 및 활용법을 익히게 되었다.
- Lottie로 만든 에니메이션 효과를 적용하는 법을 배우게 되었다.

## 🎯 What we focus on?
- Mapkit과 Core Location을 활용하여 위치 권한 설정, 현재 위치 표시, 출발지와 랜덤카드로 보여주는 식당 위치 정보를 처리한다. 또한 UIkit을 활용하여 Maker를 custom한다. searchedAddress를 통한 출발지 검색, 랜덤카드로 식당을 고르고 해당 장소 위치와 걸어서 시간(expectedTravelTime)을 Map으로 보여주는 전체가 네비게이션 역할을 하는 앱을 구현하였다. 또한, 랜덤카드 전 후에 Lottie로 만든 에니메이션 효과를 추가한다.

## 💼 Use Case
![NC2 Act 키노트 양식 004](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M30-Maps/assets/168837565/b123b349-c8a1-4597-875b-ca7301bce880)

## 🖼️ Prototype
![NC2 Act 키노트 양식 005](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M30-Maps/assets/168837565/380466ae-ba0d-4612-b7c8-3e2ca869cb82)

- LocationMapView 구조체 : 사용자의 현재 위치 및 검색한 위치를 지도에 표시
- Map Marker 커스텀 : SwiftUI 뷰에서 UIKit의 MKMapView를 사용하여 Maker 커스텀
- 경로 계산을 통한 예상 이동 시간 포멧팅 메서드
