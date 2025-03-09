//
//  HomeScreen.swift
//  AnswersAIHackathon
//
//  Created by angel zambrano on 2/20/25.
//

import SwiftUI

struct HomeScreen: View {
    @State var runStarted = false
    @State var runIsPaused = false
    @State private var elapsedTime: Int = 0
    @State private var timer: Timer? = nil
    
    @State private var distance = "1.12"
    
    @State private var time = "5:00"
    
    @State private var pace = "5'11"
    @State private var isTalking = false
    @State private var isDoneSheetPresented = false
    
    
    
    var body: some View {
        ZStack {
            
            Image(.background) // Replace with your image name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            if !runStarted {
                
                StartCard(startBtnWasPressed: {
                    
                    runStarted = true
                    startTimer()
                })
            } else {
                VStack(spacing: 0) {
                    if isTalking {
                        Image(.siri)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity) // First set the frame
                            .padding(.horizontal, 10) // Then add padding
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    WorkoutCard(distance: $distance, time: $time, pace: $pace, isPaused: $runIsPaused, stopPressed: {
                        stopTimer()
                        runIsPaused = false
                        isDoneSheetPresented = true
                        
                    }, pausePressed: {
                        runIsPaused = true
                        pauseTimer()
                    }, continueRunning: {
                        runIsPaused = false
                        continueRunningTimer()
                    })
                    
                }
            }
            
            
        }
        
        .sheet(isPresented: $isDoneSheetPresented) {
            ZStack {
                Image(.background) // Replace with your image name
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                DidFinish(distance:  $distance, time: $time, pace: $pace) {
                    
                }
            }
        }
        
        
    }
    
    func continueRunningTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if !runIsPaused {
                elapsedTime += 1
                updateTime()
            }
        }
    }
    
    
    // Start the timer and format elapsed time
    func startTimer() {
        timer?.invalidate() // Invalidate any previous timers
        elapsedTime = 0 // Reset elapsed time
        updateTime() // Update time immediately
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
            updateTime()
        }
    }
    
    // Pause the timer
    func pauseTimer() {
        timer?.invalidate()
    }
    
    // Stop the timer
    func stopTimer() {
        timer?.invalidate()
        runStarted = false
    }
    
    // Update the time format (min:sec or hh:mm:ss)
    func updateTime() {
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        
        if hours > 0 {
            time = String(format: "%02d:%02d:%02d", hours, minutes, seconds) // hh:mm:ss format
        } else {
            time = String(format: "%02d:%02d", minutes, seconds) // mm:ss format
        }
    }
    
}

#Preview {
    HomeScreen()
}
