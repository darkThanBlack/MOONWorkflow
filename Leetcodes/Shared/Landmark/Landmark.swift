//
//  Landmark.swift
//  Leetcodes (iOS)
//
//  Created by 徐一丁 on 2021/8/20.
//

import Foundation
import SwiftUI
import MapKit

struct Landmark: Hashable, Codable {
    
    var id: Int
    
    var name: String
    
    var park: String
    
    var state: String
    
    var desc: String
    
    private var imageName: String
    var image: Image {
        return Image(imageName)
    }
    
    private var coords: Coordinates
    var coord: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coords.latitude,
            longitude: coords.longitude
        )
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        
        var longitude: Double
    }
    
}


