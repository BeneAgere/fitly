//
//  WebSocketManager.swift
//  AnswersAIHackathon
//
//  Created by angel zambrano on 2/20/25.
//

import Foundation

import Foundation
import Combine

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession = URLSession(configuration: .default)
    
    @Published var receivedMessage: String = ""
    
    // Connect to WebSocket
    func connect() {
        guard let url = URL(string: "ws://localhost:8000/ws") else {
            print("Invalid URL")
            return
        }
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        
        listenForMessages()
    }
    
    // Listen for messages from the WebSocket
    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.receivedMessage = text
                    }
                default:
                    break
                }
                self?.listenForMessages() // Keep listening for more messages
            }
        }
    }
    
    // Send a message to the WebSocket
    func send(message: String) {
        let textMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(textMessage) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }
    
    // Disconnect WebSocket
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
