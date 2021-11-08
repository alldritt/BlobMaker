//
//  AnimatableCGPointVector.swift
//  BlobMaker
//
//  Created by Mark Alldritt on 2021-11-08.
//
//  Taken from here: https://gist.github.com/mecid/04ab91f45fec501e72e4d5fb02277f3f
//

import SwiftUI


struct AnimatableCGPointVector: VectorArithmetic {
    static var zero = AnimatableCGPointVector(values: [.zero])

    static func - (lhs: AnimatableCGPointVector, rhs: AnimatableCGPointVector) -> AnimatableCGPointVector {
        let values = zip(lhs.values, rhs.values)
            .map { lhs, rhs in lhs.animatableData - rhs.animatableData }
            .map { CGPoint(x: $0.first, y: $0.second) }
        return AnimatableCGPointVector(values: values)
    }

    static func -= (lhs: inout AnimatableCGPointVector, rhs: AnimatableCGPointVector) {
        for i in 0..<min(lhs.count, rhs.count) {
            lhs.values[i].animatableData -= rhs.values[i].animatableData
        }
    }

    static func + (lhs: AnimatableCGPointVector, rhs: AnimatableCGPointVector) -> AnimatableCGPointVector {
        let values = zip(lhs.values, rhs.values)
            .map { lhs, rhs in lhs.animatableData + rhs.animatableData }
            .map { CGPoint(x: $0.first, y: $0.second) }
        return AnimatableCGPointVector(values: values)
    }

    static func += (lhs: inout AnimatableCGPointVector, rhs: AnimatableCGPointVector) {
        for i in 0..<min(lhs.count, rhs.count) {
            lhs.values[i].animatableData += rhs.values[i].animatableData
        }
    }

    var values: [CGPoint]
    var count: Int { values.count }
    var isEmpty: Bool { values.isEmpty }

    mutating func scale(by rhs: Double) {
        for i in 0..<values.count {
            values[i].animatableData.scale(by: rhs)
        }
    }

    var magnitudeSquared: Double {
        values
            .map { $0.animatableData.magnitudeSquared }
            .reduce(0.0, +)
    }
    
}
