//
//  ChartView.swift
//
//  Created by angel zambrano on 
//

import SwiftUI

struct StartCard: View {
    
    var startBtnWasPressed: () -> Void
    
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Image(systemName: "figure.run")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color(red: 80/255, green: 218/255, blue: 115/255))
                
                Text("Running!")
                    .font(.system(size: 40, weight: .bold))
            }
            
            HStack(spacing: 50) {
                
                VStack(spacing: 10 ) {
                    Text("Distance")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 150/255, green: 150/255, blue: 150/255))
                    Text("1 Mile")
                        .font(.system(size: 20, weight: .bold))
                }
                VStack(spacing: 10 ) {
                    Text("Time")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 150/255, green: 150/255, blue: 150/255))
                    Text("5 min")
                        .font(.system(size: 20, weight: .bold))
                }
                VStack(spacing: 10 ) {
                    Text("Pace")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 150/255, green: 150/255, blue: 150/255))
                    Text("6’11")
                        .font(.system(size: 20, weight: .bold))
                }
                
            }
            
            
            Button(action: {
                startBtnWasPressed()
            }) {
                Text("Start")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity) // Full width
                    .background(
                        Color(red: 80/255, green: 218/255, blue: 115/255) // Button color
                            .blur(radius: 8)
                    )
                    .cornerRadius(15) // Rounded corners for the button
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 1) // White border
                    )
                    .shadow(color: Color.white.opacity(1), radius: 33, x: 0, y: 4)
                
            }
            .padding(.horizontal, 20)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white) // Container background color
        .cornerRadius(15) // Rounded corners for the container
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(red: 177/255, green: 188/255, blue: 217/255), lineWidth: 0.5) // Border color
        )
        .padding(.horizontal, 20) // Adds spacing on the screen
        
    }
}

#Preview {
    
    
    StartCard(startBtnWasPressed: {
        
    })
}
