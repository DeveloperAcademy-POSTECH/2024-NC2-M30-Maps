//
//  CustomMapView.swift
//  Yumyum_Hyoja
//
//  Created by 박고운 on 6/20/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct CustomMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var annotations: [MapAnnotation]
    var isDestinationMapView: Bool
    let currentLocationImage = UIImage(named: "Gam")!
    let destinationLocationImage = UIImage(named: "Hyorang")!
// CustomMapView는 SwiftUI의 뷰. UIViewRepresentable을 채택하여 UIKit의 MKMapView를 사용.
// @Binding var region: MKCoordinateRegion: 맵의 현재 지역을 바인딩하여 SwiftUI와 동기화
//var annotations: [MapAnnotation]: 맵에 표시할 어노테이션(핀) 배열.
//var isDestinationMapView: Bool: 이 맵이 목적지 맵인지 여부
//currentLocationImage와 destinationLocationImage는 현재 위치와 목적지 위치를 나타내는 이미지를 정의
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
// makeCoordinator 함수는 Coordinator 객체를 생성. 이 객체는 맵의 델리게이트 역할
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        return mapView
    }
// makeUIView 함수는 MKMapView 객체를 생성하고 설정
//mapView.delegate는 Coordinator 객체로 설정되어 델리게이트 메서드를 처리
//mapView.setRegion(region, animated: true)를 사용하여 초기 지역을 설정
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        let mapAnnotations = annotations.map { annotation -> MKPointAnnotation in
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = annotation.coordinate
            return pointAnnotation
        }
        uiView.addAnnotations(mapAnnotations)
        uiView.setRegion(region, animated: true)
    }
    // updateUIView 함수는 SwiftUI에서 데이터가 변경될 때마다 호출
    //기존 어노테이션을 제거하고, 새로운 어노테이션을 추가
    //맵의 지역을 업데이트

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }
// Coordinator 클래스는 MKMapViewDelegate를 구현하여 맵의 델리게이트 메서드를 처리
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "CustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true

                let isCurrentLocation = annotation.coordinate.latitude == parent.region.center.latitude && annotation.coordinate.longitude == parent.region.center.longitude
                let image = isCurrentLocation ? parent.currentLocationImage : parent.destinationLocationImage
                annotationView?.image = resizeImage(image: image, targetSize: CGSize(width: 30, height: 30))
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
// mapView(_:viewFor:) 메서드는 어노테이션에 대한 뷰를 반환. 새로운 어노테이션 뷰를 생성하거나 재사용 가능한 뷰를 재활용
    // isCurrentLocation 변수는 어노테이션이 현재 위치를 나타내는지 확인
    // 어노테이션 이미지 크기를 조정하여 표시
// resizeImage(image:targetSize:) 메서드는 이미지를 주어진 크기로 조정
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            }

            let rect = CGRect(origin: .zero, size: newSize)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!
        }
    }
}
