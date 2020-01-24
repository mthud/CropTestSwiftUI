//
//  ContentView.swift
//  CropTestSwiftUI
//
//  Created by Doug on 2020-01-24.
//  Copyright © 2020 dot3 Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var scale: CGFloat = 1.0
    @State var currentPosition: CGSize = CGSize.zero
    @State var newPosition: CGSize = CGSize.zero
    @State var photoIsFinished: Bool = false
    @State var croppedImage: UIImage? = nil
    @State var frameSize: CGSize = CGSize(width: 320, height: 570)
    @State var frameIsSquare: Bool = false
    
    var body: some View {

        VStack{
            HStack{
                Button(action: {
                    if self.frameIsSquare{
                        self.frameSize = CGSize(width: 320, height: 570)
                        self.frameIsSquare.toggle()
                    }else{
                        self.frameSize = CGSize(width: 400, height: 400)
                        self.frameIsSquare.toggle()
                    }
                    
                }, label: {
                    if self.frameIsSquare {
                        Image("story-size-icon")
                        .resizable()
                        .frame(width: 45.0, height: 45.0)
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                    }else{
                        Image("square-size-icon")
                        .resizable()
                        .frame(width: 45.0, height: 45.0)
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                    }
                }).buttonStyle(PlainButtonStyle())
                 .padding(.top, 20)
                .padding(.trailing, 20)
                
                Button(
                    action: {
                        self.photoIsFinished = false
                        self.croppedImage = nil
                        self.frameSize = CGSize(width: 320, height: 570)
                        self.frameIsSquare = false
                        self.currentPosition = CGSize.zero
                        self.newPosition = CGSize.zero
                        self.scale = 1.0
                }){
                    Text("Reset")
                }.buttonStyle(PlainButtonStyle())
                .padding(.top, 20)
                .padding(.trailing, 20)
                
                Button(
                    action: {
                        self.prepareImage()
                }){
                    Image("down-button")
                        .resizable()
                        .frame(width: 45.0, height: 45.0)
                }.buttonStyle(PlainButtonStyle())
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            
            GeometryReader { metrics in
                ZStack {
                    Rectangle()
                    .foregroundColor(.white)
                    .frame(width:self.frameSize.width, height:self.frameSize.height, alignment: .top)
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    if !self.photoIsFinished {
                        Image("landscape")
                            .resizable()
                            .scaleEffect(self.scale)
                            .aspectRatio(contentMode: .fill)
                            .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                            .frame(width: self.frameSize.width, height: self.frameSize.height, alignment: .top)
                            .clipped()
                    }
                    // This is the template "frame"
                    if self.photoIsFinished {
                        Image(uiImage: self.croppedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.frameSize.width, height: self.frameSize.height, alignment: .top)
                    }
                }
            }.gesture(MagnificationGesture()
                .onChanged { value in
                    self.scale = value.magnitude
                }
                .onEnded { value in
                    self.scale = value.magnitude
                }
            .simultaneously(with: DragGesture()
                .onChanged({ value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
               // print(self.newPosition)
                })
                .onEnded ({ value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    self.newPosition = self.currentPosition
            })))
        }
    }
    
    func prepareImage( ) {
        
        let imageToManipulate =  UIImage(named: "landscape")
        let zoomScale = self.scale
        let imsize = imageToManipulate!.size

        var scale : CGFloat = self.frameSize.width / imsize.width
        if imsize.height * scale < self.frameSize.height {
            scale = self.frameSize.height / imsize.height
        }
        let currentPositionWidth = self.currentPosition.width / scale
        let currentPositionHeight = self.currentPosition.height / scale
        let croppedImsize = CGSize(width: (self.frameSize.width/scale) / zoomScale, height: (self.frameSize.height/scale) / zoomScale)
        let xOffset = (( imsize.width - croppedImsize.width ) / 2.0) - (currentPositionWidth / zoomScale)
        let yOffset = (( imsize.height - croppedImsize.height) / 2.0) - (currentPositionHeight / zoomScale)
        let croppedImrect: CGRect = CGRect(x: xOffset, y: yOffset, width: croppedImsize.width, height: croppedImsize.height)
              
        let r = UIGraphicsImageRenderer(size:croppedImsize)
        let croppedIm = r.image { _ in
            imageToManipulate!.draw(at: CGPoint(x:-croppedImrect.origin.x, y:-croppedImrect.origin.y))
        }
        self.croppedImage = croppedIm
        self.photoIsFinished = true
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
