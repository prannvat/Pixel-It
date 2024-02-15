//
//  PIXEL_ITApp.swift
//  PIXEL-IT
//
//  Created by Prannvat Singh on 15/02/2024.
//

import SwiftUI

@main
struct PIXEL_ITApp: App {
    @State private var isActive: Bool = false
    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
                    .preferredColorScheme(.light)
                
            }
            else{
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
            
        }
    }
}

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            Image("AppLogo")
                .resizable()
                .scaledToFit()
            
        }
        
    }
}
#Preview{
    SplashView()
}
