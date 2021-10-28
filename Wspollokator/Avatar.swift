//
//  Avatar.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 28/10/2021.
//

import SwiftUI

struct Avatar: View {
    var image: Image?
    var color: Color?
    var size: CGFloat
    
    var body: some View {
        if image != nil {
            image!
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(color ?? .gray)
        }
    }
}

struct Avatar_Previews: PreviewProvider {
    static var previewSize: CGFloat = 300
    
    static var previews: some View {
        Group {
            Avatar(image: Image("avatar"), size: previewSize)
            Avatar(color: .blue, size: previewSize)
        }
        .previewLayout(.fixed(width: previewSize, height: previewSize))
    }
}
