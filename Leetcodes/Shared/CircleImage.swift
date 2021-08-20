//
//  CircleImage.swift
//  Leetcodes (iOS)
//
//  Created by 徐一丁 on 2021/8/20.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("logo")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4.0))
            .shadow(radius: 7.0)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
