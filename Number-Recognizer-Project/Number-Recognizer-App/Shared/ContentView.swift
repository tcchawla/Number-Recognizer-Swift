//
//  ContentView.swift
//  Shared
//
//  Created by Tarun Chawla on 7/19/22.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State var showingAlert = false
    @State var eraserOn = false
    @State var pixels: [Double] = Array(repeating: 1, count: 28 * 28)
    
    var body: some View {
        VStack{
            DrawingArea(showAlert: $showingAlert, eraserOn: $eraserOn, pixels: $pixels)
            HStack{
                Button(action: {
                    showingAlert = true
                }) {
                    Image(systemName: "questionmark.diamond")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Prediction from Image"), message: Text("\(predictNumber(from: pixels))"),
                        dismissButton: .default(Text("Okay!")))
                }
                Button(action: {
                    eraserOn.toggle()
                }) {
                    Image(systemName: "pencil.slash")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
                
                Button(action: {
                    for index in 0..<pixels.count {
                        pixels[index] = 1
                    }
                }) {
                     Image(systemName: "trash")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.blue)
        .ignoresSafeArea()
    }
        private func predictNumber(from pixels: [Double]) -> Int {
            let model = MNIST_IMG_RECOGNIZER()
            guard let tensorInput = try? MLMultiArray(shape: [1, 28, 28, 1], dataType: .float32) else {
                print("Could not create TensorInput")
                return -1
            }
            for i in 1..<pixels.count {
                tensorInput[i] = NSNumber(value: Float32(1 - pixels[i]))
            }
            do {
                let prediction = try model.prediction(conv2d_input: tensorInput)
                return findMax(of: prediction.Identity)
            } catch {
                print("Error making prediction")
                return -1
            }
    }
    
    private func findMax(of tensor: MLMultiArray) -> Int {
        var max: Float = 0
        var maxIndex: Int = 0
        for i in 0..<tensor.count {
            if tensor[i].floatValue > max {
                max = tensor[i].floatValue
                maxIndex = i
            }
        }
        return maxIndex
    }
}


