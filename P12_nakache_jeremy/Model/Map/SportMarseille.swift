//
//  SportMarseille.swift
//  P12_nakache_jeremy
//
//  Created by user on 04/02/2022.
//

import Foundation
import MapKit
import Contacts

class Sport : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    let title: String?
    private  let locationName: String?
    private  let postalCode : String?
    private let categorie: String?
    
    var mapItem: MKMapItem? {
        guard let location = locationName else {
            return nil
        }
        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    init(title: String?,locationName: String?,postalCode: String?, categorie: String?,coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.coordinate = coordinate
        self.categorie = categorie
        self.locationName = locationName
        self.postalCode = postalCode
        
        super.init()
    }
    var subtitle: String? {
        guard let location = locationName, let postalCode = postalCode else {
            return ""
        }
        return "\(location) \(postalCode)"
    }
    init?(feature: MKGeoJSONFeature) {
        // 1
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any]
        else {
            return nil
        }
        
        // 3
        title = properties["Nom du site"] as? String
        locationName = properties["Adresse 1"] as? String
        categorie = properties["Categorie"] as? String
        coordinate = point.coordinate
        postalCode = properties["Code Postal"] as? String
        super.init()
    }
}
