# XCAssetsGen
The swift code generator for asset resources from .xcassets

## Support
- [x] ColorAssets
- [x] ImageAssets

## Installation
### Using [CocoaPods](https://cocoapods.org/)

## Usage
Simply run:
```sh
$ xcassetsgen generate
```
This will look for a `.xcassetsgen.yml` and generate UIAssets definition from `.xcassets`

### Prepare `.xcassets.yml`
```yml
images:
  inputs:
    - Tests/Resources/ImageAssets.xcassets
  output: Tests/UIImage+XCAssetsGen.swift
colors:
  inputs:
    - Tests/Resources/ColorAssets.xcassets
  output: Tests/UIColor+XCAssetsGen.swift
```

### Generated UIAssets definition
#### Assets
![](https://github.com/natmark/XCAssetsGen/blob/master/Resources/image_sample.png?raw=true)
#### Output
```Swift
// Generated by XCAssetsGen - XCAssetsGenKitVersion(value: "0.0.1")

import UIKit
class ImageProvider {
	static func image(named name: String) -> UIImage? {
		let bundle = Bundle(for: ImageProvider.self)
		return UIImage(named: name, in: bundle, compatibleWith: nil)
	}
}
extension UIImage {
	public static var icon: Icon {
		return Icon()
	}
	public struct Icon {
		public var arrow: UIImage {
			return ImageProvider.image(named: "XCAssetsGen/icon/arrow")!
		}
		public var circle: UIImage {
			return ImageProvider.image(named: "XCAssetsGen/icon/circle")!
		}
	}
}
```
#### Using generated definition
```Swift
let arrowImage = UIImage.icon.arrow
let circleImage = UIImage.icon.circle
```

#### Assets
![](https://github.com/natmark/XCAssetsGen/blob/master/Resources/color_sample.png?raw=true)

#### Output
```Swift
// Generated by XCAssetsGen - XCAssetsGenKitVersion(value: "0.0.1")

import UIKit
class ColorProvider {
	static func color(named name: String) -> UIColor? {
		let bundle = Bundle(for: ColorProvider.self)
		return UIColor(named: name, in: bundle, compatibleWith: nil)
	}
}
extension UIColor {
	public static var background: Background {
		return Background()
	}
	public struct Background {
		public var normal: UIColor {
			return ColorProvider.color(named: "background/normal")!
		}
		public var white: UIColor {
			return ColorProvider.color(named: "background/white")!
		}
		public var overlay: UIColor {
			return ColorProvider.color(named: "background/overlay")!
		}
	}
	public static var border: Border {
		return Border()
	}
	public struct Border {
		public var normal: UIColor {
			return ColorProvider.color(named: "border/normal")!
		}
	}
	public static var text: Text {
		return Text()
	}
	public struct Text {
		public var disabled: UIColor {
			return ColorProvider.color(named: "text/disabled")!
		}
	}
}
```
#### Using generated definition
```Swift
let whiteBackgroundColor = UIColor.background.white
let disabledTextColor = UIColor.text.disabled
```

### License
XCAssetsGen is available under the MIT license. See the LICENSE file for more info.
