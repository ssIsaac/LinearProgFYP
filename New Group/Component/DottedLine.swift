//
//  DottedLine.swift
//  Linear Programming FYP
//
//  Created by ganeshrajugalla
// https://medium.com/@ganeshrajugalla/creating-dotted-lines-with-swiftui-shapes-2c63ab38572c#
//citation key [15]

import Foundation
import SwiftUI

struct DottedLineHorizontal:Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct DottedLineVertical: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}

