//
//  BlobShape.swift
//  BlobMaker
//
//  Created by Mark Alldritt on 2021-11-08.
//
//  This SwiftUI view is adapted from:
//
//  https://github.com/lokesh-coder/blobshape
//

import SwiftUI


extension CGPoint {
    fileprivate func scale(x xScale: CGFloat, y yScale: CGFloat) -> CGPoint {
        return CGPoint(x: x * xScale, y: y * yScale)
    }
}


struct BlobShape: Shape {
    static let size = CGFloat(300)
    
    var controlPoints: AnimatableCGPointVector
    
    var animatableData: AnimatableCGPointVector {
        set { self.controlPoints = newValue }
        get { return self.controlPoints }
    }

    static func createPoints(minGrowth: Int, edges: Int) -> AnimatableCGPointVector {
        func toRad(deg: CGFloat) -> CGFloat {
            deg * (.pi / 180.0);
        }

        func divide(count: Int) -> [CGFloat] {
            let deg = 360 / CGFloat(count);
            
            return (0..<count).map { i in
                CGFloat(i) * deg
            }
        }

        func magicPoint(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
            let radius = min + value * (max - min);
            if (radius > max) {
                return radius - min;
            } else if (radius < min) {
                return radius + min;
            }
            return radius;
        }

        func point(origin: CGFloat, radius: CGFloat, degree: CGFloat) -> CGPoint {
            let x = (origin + radius * cos(toRad(deg: degree))).rounded()
            let y = (origin + radius * sin(toRad(deg: degree))).rounded()
            return CGPoint(x: x, y: y)
        }


        let outerRad = Self.size / 2
        let innerRad = CGFloat(minGrowth) * (outerRad / 10)
        let center = Self.size / 2;
        let slices = divide(count: edges);
        let points: [CGPoint] = slices.map { degree in
            let O = magicPoint(value: CGFloat.random(in: 0...1),
                               min: innerRad,
                               max: outerRad)
          
            return point(origin: center,
                         radius: O,
                         degree: degree);
        }

        return AnimatableCGPointVector(values: points)
    }

    func path(in rect: CGRect) -> Path {
        let count = controlPoints.count
        guard count > 1 else { return Path() }
        let xScale = rect.width / Self.size
        let yScale = rect.height / Self.size
        let scaledPoints = controlPoints.values.map { p in
            return p.scale(x: xScale, y: yScale)
        }

        var p = Path()
        p.move(to: CGPoint(x: (scaledPoints[0].x + scaledPoints[1].x) / 2,
                           y: (scaledPoints[0].y + scaledPoints[1].y) / 2))
        
        (0..<count).forEach { i in
            let p1 = scaledPoints[(i + 1) % count]
            let p2 = scaledPoints[(i + 2) % count]
            let midX = (p1.x + p2.x) / 2
            let midY = (p1.y + p2.y) / 2
            
            p.addQuadCurve(to: CGPoint(x: midX, y: midY), control: p1)
        }

        return p
    }
}

