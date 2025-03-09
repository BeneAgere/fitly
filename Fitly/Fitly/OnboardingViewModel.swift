//
//  OnboardingViewModel.swift
//
//  Created by angel zambrano on 2/22/25.
//

import Foundation

struct User: Codable {
    var name: String?
    var age: Int?
    var goals: String?
    var voiceType: String?
    var runningExperience: String?
    var preferredCoachingStyle: String?
    
    // Initializer to make it easier to create the object
    init() {
      
    }
    
    // Function to print the object for verification
    func printDetails() {
        print("Name: \(name), Age: \(age), Goals: \(goals), Voice Type: \(voiceType), Running Experience: \(runningExperience), Preferred Coaching Style: \(preferredCoachingStyle)")
    }
}

class OnboardingViewModel: ObservableObject {
    @Published var isSLiderValueCompleted: Bool = false
    @Published var sliderValue: Double = 0.0
    @Published var isname: Bool = false
    @Published var name: String?
    @Published var isAge: Bool = false
    @Published var age: Int?
    @Published var isGoals: Bool = false
   @Published var goals: String?
    @Published var isVoiceType: Bool = false
    @Published var voiceType: String?
    @Published var isRunningExperience: Bool = false
    @Published var runningExperience: String?
    @Published var isPreference: Bool = false
    @Published var preferredCoachingStyle: String?
    @Published var isGender = false
    @Published var gender = "MALE"
    
    @Published var oftenWorkOut = ""
    @Published var DidofTenWorkOut = false
    
}


