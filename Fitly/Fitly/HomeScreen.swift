//
//  HomeScreen.swift
//
//  Created by angel zambrano on 2/20/25.
//

import SwiftUI

struct Message: Codable {
    var type: String
    var content: String
}

struct HomeScreen: View {
    @State var runStarted = false
    @State var runIsPaused = false
    @State private var elapsedTime: Int = 0
    @State private var timer: Timer? = nil
    
    @State private var distance = "1.00"
    
    @State private var time = "20:00"
    let increment: Float = 0.05 // Represents 5 seconds
    @State private var distanceTime = 0.00
    @State private var pace = "5:00"
    @State private var isTalking = false
    @State private var isDoneSheetPresented = false
    @StateObject var viewModel: HomescreenViewModel
    
    let paces = ["17:00", "16:55", "16:50", "15:50",
                 "15:45", "15:30", "15:15", "15:00",
                 "14:50", "14:45", "14:30", "14:15",
                 "14:00", "13:55", "13:50", "13:45",
                 "13:30", "13:15", "13:00", "12:50",
                 "12:45", "12:30", "12:15", "12:00",
                 "11:50", "11:30", "11:15", "11:00",
                 "10:45", "10:30", "10:15", "10:00",
                 "9:45", "9:30", "9:15", "9:00",
                 "8:45", "8:30", "8:15", "8:00",
                 "7:45", "7:30", "7:15", "7:00",
                 "6:45", "6:30", "6:15", "6:00",
                 "5:45", "5:30", "5:15", "5:00",
                 "4:45", "4:30", "4:15", "4:00"]
    
    @StateObject private var webSocketManager = WebSocketManager()
    
    
    var body: some View {
        ZStack {
            
            Image(.background) // Replace with your image name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            if !runStarted {
                StartCard {
                    runStarted = true
                    webSocketManager.connect()
                    startTimer()
                }
                
            } else if webSocketManager.isConnected  {
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
                        webSocketManager.send(message: "STOP")
                        
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
    
        
        .onChange(of: webSocketManager.receivedMessage, { oldValue, newValue in
            
       
            
            if let data = newValue.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       var content = json["content"] as? String {
                        let base64String = content.replacingOccurrences(of: "data:audio/wav;base64,", with: "")
                        
                        if let audioData = Data(base64Encoded:base64String) {
                            
                            viewModel.playResponse(audioData)
                        } else {
                            print("dd")
                        }
                       
                        
                    }
                }
                catch {
                        print("Error parsing JSON: \(error)")
                    
                }
            }

        })
        
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
        timer?.invalidate()
        elapsedTime = 0
        distance = "0:00"
        updateTime()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
            updateTime()
            
            if elapsedTime % 5 == 0 {
                DispatchQueue.main.async {
                    pace =  paces.randomElement() ?? "15"
                }
            }
            if elapsedTime % 10 == 0 {
                DispatchQueue.main.async {
                    distanceTime += 0.05
                    distance  = String(format: "%.2f", distanceTime)
                }
            }
            
            if elapsedTime % 20 == 0 {
                let minutes = (elapsedTime % 3600) / 60
                let seconds = elapsedTime % 60
                webSocketManager.send(message: "PACE: \(pace), TIME: \(time), DISTANCE:\(distance)")
            }
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
    HomeScreen(viewModel: .init())
}
