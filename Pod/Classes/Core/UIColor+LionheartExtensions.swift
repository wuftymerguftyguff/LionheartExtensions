//
//  Copyright 2016 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import UIKit

/**
`UIColor` extension.
*/
public extension UIColor {
    /**
     Initialize a `UIColor` object with any number of methods. E.g.
     
     Integer literals:

     ```
     UIColor(0xF00)
     UIColor(0xFF0000)
     UIColor(0xFF0000FF)
     ```
     
     String literals:

     ```
     UIColor("f00")
     UIColor("FF0000")
     UIColor("rgb(255, 0, 0)")
     UIColor("rgba(255, 0, 0, 0.15)")
     ```
     
     Or (preferably), if you want to be a bit more explicit:
     
     ```
     UIColor(.hex(0xF00))
     UIColor(.rgb(255, 0, 0))
     UIColor(.rgba(255, 0, 0, 0.5))
     ```
     
     If a provided value is invalid, the color will be white with an alpha value of 0.
     
     - parameter color: a `ColorRepresentation`
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 17, 2016
     */
    convenience init(_ color: ColorRepresentation) {
        switch color {
        case .hex(let value):
            var r: CGFloat!
            var g: CGFloat!
            var b: CGFloat!
            var a: CGFloat!

            value.toRGBA(&r, &g, &b, &a)
            self.init(red: r, green: g, blue: b, alpha: a)

        case .rgb(let r, let g, let b):
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)

        case .rgba(let r, let g, let b, let a):
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a))

        case .invalid:
            self.init(white: 0, alpha: 0)
        }
    }
    
    /**
     Lighten a color by a specified ratio.
     
     - parameter ratio: the ratio by which to lighten the color by.
     - returns: A new `UIColor`.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 17, 2016
     */
    func lighten(_ ratio: CGFloat) -> UIColor {
        var rgba = [CGFloat](repeating: 0, count: 4)
        getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])

        let r = Float(min(rgba[0] + ratio, 1))
        let g = Float(min(rgba[1] + ratio, 1))
        let b = Float(min(rgba[2] + ratio, 1))
        let a = Float(min(rgba[3] + ratio, 1))
        return UIColor(colorLiteralRed: r, green: g, blue: b, alpha: a)
    }

    /**
     Darken a color by a specified ratio.
     
     - parameter ratio: the ratio by which to darken the color by.
     
     - returns: A new `UIColor`.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 17, 2016
     */
    func darken(_ ratio: CGFloat) -> UIColor {
        var rgba = [CGFloat](repeating: 0, count: 4)
        getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])

        let r = Float(max(rgba[0] - ratio, 0))
        let g = Float(max(rgba[1] - ratio, 0))
        let b = Float(max(rgba[2] - ratio, 0))
        let a = Float(max(rgba[3] - ratio, 0))
        return UIColor(colorLiteralRed: r, green: g, blue: b, alpha: a)
    }

    /**
     Indicate whether a given color is dark.

     - returns: A `Bool` indicating if the given `UIColor` is dark.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: February 17, 2016
     */
    var isDark: Bool {
        var rgba = [CGFloat](repeating: 0, count: 4)
        
        let converted = getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])
        if !converted {
            return false
        }

        let R = Float(rgba[0])
        let G = Float(rgba[1])
        let B = Float(rgba[2])
        let A = Float(rgba[3])

        // Formula derived from here:
        // http://www.w3.org/WAI/ER/WD-AERT/#color-contrast

        // Alpha blending:
        // http://stackoverflow.com/a/746937/39155
        let newR: Float = (255 * (1 - A) + 255 * R * A) / 255
        let newG: Float = (255 * (1 - A) + 255 * G * A) / 255
        let newB: Float = (255 * (1 - A) + 255 * B * A) / 255
        let newR1: Float = (newR * 255 * 299)
        let newG1: Float = (newG * 255 * 587)
        let newB1: Float = (newB * 255 * 114)
        return ((newR1 + newG1 + newB1) / 1000) < 200
    }
}
