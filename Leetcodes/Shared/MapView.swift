//
//  MapView.swift
//  Leetcodes (iOS)
//
//  Created by 徐一丁 on 2021/8/20.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 30.150_000, longitude: 120.100_000),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
