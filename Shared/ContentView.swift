//
//  ContentView.swift
//  Shared
//
//  Created by Mark Alldritt on 2021-11-06.
//

import Foundation
import SwiftUI


struct ContentView: View {
    static let animationDuration = TimeInterval(1.0 / 4.0)
    let timer = Timer.publish(every: Self.animationDuration, on: .main, in: .common).autoconnect()

    @State var minGrowth = 6
    var minGrowthProxy: Binding<Double>{
        Binding<Double>(get: {
            return Double(minGrowth)
        }, set: {
            minGrowth = Int($0.rounded())
        })
    }

    @State var edges = 6
    var edgesProxy: Binding<Double>{
        Binding<Double>(get: {
            return Double(edges)
        }, set: {
            edges = Int($0.rounded())
        })
    }
    
    @State var blobVector1 = AnimatableCGPointVector.zero
    @State var blobVector2 = AnimatableCGPointVector.zero
    @State var blobVector3 = AnimatableCGPointVector.zero
    @State var blobVector4 = AnimatableCGPointVector.zero

    var body: some View {

        VStack {
            Text("The Blobs")
                .padding()
            Spacer()
            HStack {
                let shape3 = BlobShape(controlPoints: blobVector3)
                let shape4 = BlobShape(controlPoints: blobVector4)

                shape3
                    .fill(Color.orange.opacity(0.5))
                    .overlay( // overlay the shape with the same shape to create outline
                        shape3
                            .stroke(Color.orange, lineWidth: 3)
                    )
                    .aspectRatio(1, contentMode: .fit)
                shape4
                    .fill(Color.purple.opacity(0.5))
                    .overlay( // overlay the shape with the same shape to create outline
                        shape4
                            .stroke(Color.purple, lineWidth: 3)
                    )
                    .aspectRatio(1, contentMode: .fit)
            }
            ZStack {
                let shape1 = BlobShape(controlPoints: blobVector1)
                let shape2 = BlobShape(controlPoints: blobVector2)

                shape1
                    .fill(Color.blue.opacity(0.5))
                    .overlay( // overlay the shape with the same shape to create outline
                        shape1
                            .stroke(Color.blue, lineWidth: 3)
                    )
                shape2
                    .fill(Color.green.opacity(0.5))
                    .overlay( // overlay the shape with the same shape to create outline
                        shape2
                            .stroke(Color.green, lineWidth: 3)
                    )
            }
            .aspectRatio(1, contentMode: .fit)
            Spacer()
            VStack {
                Text("minGrowth - \(minGrowth)")
                Slider(value: minGrowthProxy, in: 1...10)
            }
            .padding()
            VStack {
                Text("edges - \(edges)")
                Slider(value: edgesProxy, in: 3...10)
            }
            .padding()
        }
        .onAppear {
            blobVector1 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
            blobVector2 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
            blobVector3 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
            blobVector4 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
        }
        .onReceive(timer) { _ in
            withAnimation(.linear) {
                blobVector1 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
                blobVector2 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
                blobVector3 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
                blobVector4 = BlobShape.createPoints(minGrowth: minGrowth, edges: edges)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
