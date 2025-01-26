//
//  MapView.swift
//  DVT Weather
//
//  Created by GICHUKI on 27/01/2025.
//

import UIKit
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinates: CLLocationCoordinate2D?
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = MKCoordinateRegion(
                center: mapView.centerCoordinate,
                span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta, longitudeDelta: mapView.region.span.longitudeDelta)
            )
        }
        
        @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let locationInView = gestureRecognizer.location(in: mapView)
            let tappedCoordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
            parent.selectedCoordinates = tappedCoordinates
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Add tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(gestureRecognizer:)))
        tapGestureRecognizer.delegate = context.coordinator
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }
}
