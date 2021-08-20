//
//  ContentView.swift
//  Shared
//
//  Created by 徐一丁 on 2021/8/19.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            MapView()
                .frame(height: 300.0)
            
            CircleImage()
                .frame(width: 300.0, height: 300.0)
                .offset(y: -150.0)
                .padding(.bottom, -150.0)
            
            VStack(alignment: .leading) {
                Text("MoonShdaow")
                    .font(.title)
                
                HStack {
                    Text("my current loc.")
                        .font(.subheadline)
                    Spacer()
                    Text("HangZhou")
                        .font(.subheadline)
                        .foregroundColor(.pink)
                }
                
                Divider()
                
                Text("About moon shadow")
                    .font(.title2)
                Text("Descriptive text goes here.")
            }
            .padding(.all, 16.0)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
