//
//  ContentView.swift
//
//  Created by angel zambrano on 
//

import SwiftUI


struct ContentView: View {
    @StateObject private var webSocketManager = WebSocketManager()
     @State private var messageToSend: String = ""
    @State var onboardingCompleted = false
     
    var body: some View {
        
        
        if onboardingCompleted {
            HomeScreen(viewModel: .init())
        } else {
            Onbording(isOnboardingCompleted: $onboardingCompleted)
        }
    }
    
}

#Preview {
    ContentView()
}
