import UIKit

public enum SdkDynamicFont: String, SdkFontPackage {
    
    case regular = "Museo"
    case bold = "Museo-Bold"

    public var fontPath: String {
        return ""
    }
    
    public var fontExtension: FontExtension {
        return .ttf
    }
    
}
