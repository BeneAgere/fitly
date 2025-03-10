//
//  DidFinish.swift
//  AnswersAIHackathon
//
//  Created by angel zambrano on
//

import SwiftUI


struct DidFinish: View {
    
    @Binding var distance: String
    @Binding var time: String
    @Binding var pace: String
    
    let doneButtonPressed: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            
            VStack(spacing: 20) {
                Image(.stars)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 50)
                    .foregroundStyle(Color(red: 80/255, green: 218/255, blue: 115/255))
                
                VStack {
                    Text("Run Completed")
                        .font(.system(size: 45, weight: .bold))
                    
                }
            }
            
            HStack(spacing: 50) {
                
                VStack(spacing: 10 ) {
                    Text("Distance")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 150/255, green: 150/255, blue: 150/255))
                    Text(distance)
                        .font(.system(size: 20, weight: .bold))
                }
                
                VStack(spacing: 10 ) {
                    Text("Time")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 150/255, green: 150/255, blue: 150/255))
                    Text(time)
                        .font(.system(size: 20, weight: .bold))
                }
                
                VStack(spacing: 10 ) {
                    Text("Pace")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(red: 150/255, green: 150/255, blue: 150/255))
                    Text(pace)
                        .font(.system(size: 20, weight: .bold))
                }
               
            }
            
            continueButton
            
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
    

    
    private var continueButton: some View {
        Button(action: {
            doneButtonPressed()
        }) {
            Text("Continue")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 50)
                .padding(.vertical, 16)
                .background(
                    Color(red: 82/255, green: 218/255, blue: 117/255)
                        .blur(radius: 8)
                )
                .cornerRadius(15) // Rounded corners for the button
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 1) // White border
                )
                .shadow(color: Color.white.opacity(1), radius: 33, x: 0, y: 4)
        }
    }
    
   
    
}

#Preview {
    DidFinish(distance: .constant("1.12"), time: .constant("5:00"), pace: .constant("5'11"), doneButtonPressed: {
        
    })
   
}
