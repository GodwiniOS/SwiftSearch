//
//  SwiftSearchApp.swift
//  SwiftSearch
//
//  Created by Godwin A on 04/12/21.
//

import SwiftUI

@main
struct SwiftSearchApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
            }
        }
    }
}
