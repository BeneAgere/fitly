//
//  LoginScreen.swift
//
//  Created by angel zambrano on 2/20/25.
//

import SwiftUI




struct Onbording: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    
    @State private var index = 0
    // State variable to hold the value of the slider
    @State private var sliderValue: Double = 0.0
    @State private var selectedGender: String = "Male"
    @Binding var isOnboardingCompleted: Bool
    
    @State private var name = ""
    
    var body: some View {
        
        
        if !viewModel.isSLiderValueCompleted {
            Text("Tone Of Trainer")
                .bold()
                .font(.system(size: 40))
                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the leading edge
                .padding([.leading,.top])
            
            VStack {
                // Labels for the slider extremes
                
                // Slider goes from -1 to 1
                Slider(value: $sliderValue, in: -1...1, step: 0.01)
                    .accentColor(.green) // Set the color to green
                    .padding()
                
                HStack {
                    Text("Kind")
                        .font(.headline)
                    Spacer()
                    Text("Drill Sergeant")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                
                Spacer()
                CustomButton(title: "Next") {
                    viewModel.sliderValue  = sliderValue
                    viewModel.isSLiderValueCompleted = true
                }
            }
            .padding()
        
        } else if !viewModel.isGender {
            
            Text("Gender")
                .bold()
                .font(.system(size: 40))
                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the leading edge
                .padding([.leading,.top])
    

             VStack(alignment: .leading, spacing: 10) {
                 // Option: Male
                 Button(action: {
                     viewModel.gender = "Male" // Set Male as selected
                 }) {
                     HStack {
                         Circle()
                             .strokeBorder(Color.green, lineWidth: 2) // Circle border
                             .background(Circle().fill(viewModel.gender == "Male" ? Color.green : Color.clear)) // Fill with green when selected
                             .frame(width: 20, height: 20) // Circle size
                         Text("Male")
                             .foregroundColor(viewModel.gender == "Male" ? .green : .gray) // Change text color based on selection
                     }
                 }
                 .padding(.leading)

               
                 // Option: Female
                 Button(action: {
                     viewModel.gender = "Female" // Set Female as selected
                 }) {
                     HStack {
                         Circle()
                             .strokeBorder(Color.green, lineWidth: 2) // Circle border
                             .background(Circle().fill(viewModel.gender == "Female" ? Color.green : Color.clear)) // Fill with green when selected
                             .frame(width: 20, height: 20) // Circle size
                         Text("Female")
                             .foregroundColor(viewModel.gender == "Female" ? .green : .gray) // Change text color based on selection
                     }
                 }
                 .padding(.leading)

                 
                 Spacer()
                 CustomButton(title: "Next") {
                     viewModel.isGender = true
                 }
             }
             
            

            
        } else if !viewModel.isname {
            Text("What is your name")
                 .bold()
                 .font(.system(size: 40))
                 .frame(maxWidth: .infinity, alignment: .leading) // Align text to the leading edge
                 .padding([.leading, .top])
            
            TextField("Enter your name", text: $name)
                       .padding()
                       .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2))) // Gray background
                       .frame(height: 50) // Adjust height if needed
                       .padding([.leading, .trailing]) // Add padding for spacing
            
            
            Spacer()
            CustomButton(title: "Next") {
                viewModel.isname = true
            }
        }
        
        else if !viewModel.DidofTenWorkOut {
            Text("Choose a Voice")
                 .bold()
                 .font(.system(size: 40))
                 .frame(maxWidth: .infinity, alignment: .leading) // Align text to the leading edge
                 .padding([.leading, .top])

             VStack(alignment: .leading, spacing: 10) {
                 // Option: Frequently
                 Button(action: {
                     viewModel.oftenWorkOut = "alloy"
                 }) {
                     HStack {
                         Circle()
                             .strokeBorder(Color.green, lineWidth: 2)
                             .background(Circle().fill(viewModel.oftenWorkOut == "alloy" ? Color.green : Color.clear))
                             .frame(width: 20, height: 20)
                         Text("alloy")
                             .foregroundColor(viewModel.oftenWorkOut == "alloy" ? .green : .gray)
                     }
                     .frame(maxWidth: .infinity, alignment: .leading) // Ensure leading alignment
                 }

                 // Option: Sometimes
                 Button(action: {
                     viewModel.oftenWorkOut = "echo"
                 }) {
                     HStack {
                         Circle()
                             .strokeBorder(Color.green, lineWidth: 2)
                             .background(Circle().fill(viewModel.oftenWorkOut == "echo" ? Color.green : Color.clear))
                             .frame(width: 20, height: 20)
                         Text("echo")
                             .foregroundColor(viewModel.oftenWorkOut == "echo" ? .green : .gray)
                     }
                     .frame(maxWidth: .infinity, alignment: .leading) // Ensure leading alignment
                 }

                 // Option: Never
                 Button(action: {
                     viewModel.oftenWorkOut = "sexy"
                    
                 }) {
                     HStack {
                         Circle()
                             .strokeBorder(Color.green, lineWidth: 2)
                             .background(Circle().fill(viewModel.oftenWorkOut == "sexy" ? Color.green : Color.clear))
                             .frame(width: 20, height: 20)
                         Text("sexy")
                             .foregroundColor(viewModel.oftenWorkOut == "sexy" ? .green : .gray)
                     }
                     .frame(maxWidth: .infinity, alignment: .leading) // Ensure leading alignment
                 }
             }
             .frame(maxWidth: .infinity, alignment: .leading) // Ensure the VStack itself is leading-aligned
             .padding(.leading) // Add some padding if needed
            Spacer()
            CustomButton(title: "Next") {
                isOnboardingCompleted = true
                viewModel.DidofTenWorkOut = true
            }
        }
        
    }
}


#Preview {
    Onbording(isOnboardingCompleted: .constant(false))
}


struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
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
}
