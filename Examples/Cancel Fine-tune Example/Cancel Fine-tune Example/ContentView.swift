//
//  ContentView.swift
//  OpenAIKit
//
//  Copyright (c) 2022 MarcoDotIO
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

import SwiftUI
import OpenAIKit

struct ContentView: View {
    @State private var fineTune: FineTune?

    var body: some View {
        VStack {
            if let fineTune {
                Text("Fine Tune Result:").bold().font(.title)
                Text("ID: \(fineTune.id)")
                Text("Object: \(fineTune.object.rawValue)")
                Text("Model: \(fineTune.model)")
                Text("Created At: \(String(fineTune.createdAt))")
                Text("Orgainization ID: \(fineTune.organizationId)")
                Text("Status: \(fineTune.status.rawValue)")

                VStack {
                    Text("Events").bold().font(.title2)

                    if fineTune.events.isEmpty {
                        Text("No Events logged")
                    } else {
                        ScrollView {
                            ForEach(fineTune.events, id: \.self) { event in
                                VStack {
                                    Text("Object: \(event.object.rawValue)")
                                    Text("Created At: \(event.createdAt)")
                                    Text("Level: \(event.level.rawValue)")
                                    Text("Message: \(event.message)")
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }

                VStack {
                    Text("Hyperparameters").bold().font(.title2)
                    Text("Batch Size: \(String(describing: fineTune.hyperparams.batchSize))")
                    Text("Learning Rate Multiplier: \(fineTune.hyperparams.learningRateMultiplier)")
                    Text("n Epochs: \(fineTune.hyperparams.nEpochs)")
                    Text("Prompt Loss Weight: \(fineTune.hyperparams.promptLossWeight)")
                }

                VStack {
                    VStack {
                        Text("Training Files").bold().font(.title2)
                        Text("ID: \(fineTune.trainingFiles[0].id)")
                    }

                    Text("Updated At: \(String(fineTune.updatedAt))")
                }
            } else {
                Text("Cancelling fine-tune...")
            }
        }
        .padding()
        .task {
            do {
                let config = Configuration(organization: "INSERT-ORGANIZATION-ID", apiKey: "INSERT-API-KEY")
                let openAI = OpenAI(config)

                self.fineTune = try await openAI.cancelFineTune(fineTune: "INSERT-FINE-TUNE-ID")
            } catch {
                print("ERROR - \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
