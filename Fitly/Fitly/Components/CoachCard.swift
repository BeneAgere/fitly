//
//  CoachCard.swift
//  AnswersAIHackathon
//
//  Created by angel zambrano on 2/22/25.
//

import SwiftUI

struct CoachCard: View {
    var body: some View {
        Image(.siri) // Replace with your image
            .resizable()
            .scaledToFit() // Fills the container
            .clipped() // Ensures it gets clipped by the rounded corners
            .frame(maxWidth: 401, maxHeight: .infinity) // Ensures the image fills the card completely
            .cornerRadius(15) // Rounded corners for the image
            .padding(.horizontal, 20) // Padding for the card's edges
    }
}

#Preview {
    CoachCard()
}
