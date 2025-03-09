//
//  LoginScreen.swift
//  AnswersAIHackathon
//
//  Created by angel zambrano on 2/20/25.
//

import SwiftUI


struct Onbording: View {

    var body: some View {
        
        Text("What are you hoping to achieve with fastic?")
        getHealthierButton
        
        
    }
    
    
    private var getHealthierButton: some View {
        Button(action: {
            print("Get Healthier tapped!")
        }) {
            Text("Get Healthier")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(Color.green)
                )
            
        }
        .padding(.horizontal, 20)
    }
    
    
}

#Preview {
    Onbording()
}
