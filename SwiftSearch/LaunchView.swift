//
//  LaunchView.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/14/21.
//

import SwiftUI

struct LaunchView: View {
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

