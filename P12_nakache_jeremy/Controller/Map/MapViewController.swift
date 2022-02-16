//
//  MapViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 04/02/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!
    private var sports: [Sport] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Set initial location in Marseille
        let initialLocation = CLLocation(latitude: 43.2698535148153, longitude: 5.39588994384273)
        mapView.centerToLocation(initialLocation)
        let marseilleCenter = CLLocation(latitude: 43.2698535148153, longitude: 5.39588994384273)
        let region = MKCoordinateRegion(
            center: marseilleCenter.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        // Do any additional setup after loading the view.
        loadInitialData()
        mapView.addAnnotations(sports)
    }
    
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Sport else {
            return nil
        }
        // 3
        let identifier = "sport"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation,reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func  mapView (_  mapView : MKMapView ,annotationView  view : MKAnnotationView,calloutAccessoryControlTapped  control : UIControl) {
        
        guard let sport = view.annotation as? Sport else {
            return
        }
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving
        ]
        sport.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
    private func loadInitialData() {
        guard let fileName = Bundle.main.url(forResource: "Marseille", withExtension: "geojson"), let sportData = try? Data(contentsOf: fileName) else {
            return
        }
        
        do {
            let features = try MKGeoJSONDecoder().decode(sportData).compactMap { $0 as? MKGeoJSONFeature }
            
            let validWorks = features.compactMap(Sport.init)
            sports.append(contentsOf: validWorks)
        }
        catch {
            print ("Unexpected error: \(error).")
        }
    }
}
