//
//  Avatar.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 28/10/2021.
//

import SwiftUI

struct Avatar: View {
    var image: Image?
    var size: CGFloat
    
    var body: some View {
        if image != nil {
            image!
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size, alignment: .center)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .background(Color.white, in: Circle())
        }
    }
}

struct Avatar_Previews: PreviewProvider {
    static let previewSize: CGFloat = 100
    
    static var previews: some View {
        Group {
            Avatar(image: Image("avatar1"), size: previewSize)
            Avatar(size: previewSize)
        }
        .previewLayout(.fixed(width: previewSize, height: previewSize))
    }
}
