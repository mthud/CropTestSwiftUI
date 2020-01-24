//
//  PhotoPositionData.swift
//  ABDL-frames
//
//  Created by Doug on 2020-01-09.
//  Copyright © 2020 dot3 Ltd. All rights reserved.
//

import SwiftUI
import UIKit

final class PhotoPositionData: NSObject, ObservableObject {
    // Position of image and scale
    @Published var scale: CGFloat = 1.0
    @Published var currentPosition: CGSize = CGSize.zero
    @Published var newPosition: CGSize = CGSize.zero
}
