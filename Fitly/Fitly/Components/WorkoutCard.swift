//
//  WorkoutCard.swift
//
//  Created by angel zambrano on 
//

import SwiftUI

struct WorkoutCard: View {
    
    @Binding var distance: String
    @Binding var time: String
    @Binding var pace: String
    @Binding var isPaused: Bool
    
    let stopPressed:() -> Void
    let pausePressed:() -> Void
    let continueRunning: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            
            VStack(spacing: 20) {
                Image(systemName: "figure.run")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color(red: 80/255, green: 218/255, blue: 115/255))
                
                VStack {
                    Text(distance)
                        .font(.system(size: 90, weight: .bold))
                    Text("Miles")
                        .font(.system(size: 20, weight: .bold))
                }
            }
            
            HStack(spacing: 90) {
                
              
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
            
            HStack(spacing: 20) {
                if !isPaused {
                    stopCardbtn
                    pause
                } else {
                    continueButton
                    stopCardbtn
                }
               
            }
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
    
    private var stopCardbtn: some View {
        Button(action: {
            
            stopPressed()
        }) {
            Text("Stop")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 50)
                .padding(.vertical, 16)
                .background(
                    Color(red: 242/255, green: 45/255, blue: 11/255)
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
    
    private var continueButton: some View {
        Button(action: {
            continueRunning()
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
    
    private var pause: some View {
        Button(action: {
            pausePressed()
        }) {
            Text("Pause")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 50)
                .padding(.vertical, 16)
                .background(
                    Color(red: 244/255, green: 133/255, blue: 35/255)
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
    WorkoutCard(distance: .constant("1.12"), time: .constant("5:00"), pace: .constant("5'11"), isPaused: .constant(false), stopPressed: {
        
    }, pausePressed: {
        
    }, continueRunning: {
        
    })
   
}
