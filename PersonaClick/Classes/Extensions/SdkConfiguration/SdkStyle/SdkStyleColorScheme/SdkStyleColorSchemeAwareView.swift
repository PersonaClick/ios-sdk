import UIKit

protocol SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme)

    var shouldDowncastColorScheme: Bool { get }
}


extension SdkStyleColorSchemeAwareView {
    var shouldDowncastColorScheme: Bool {
        return false
    }
}


extension UILabel: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let labelColorScheme = colorScheme as? SdkStyleLabelColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        textColor = labelColorScheme.labelTextColor
    }
}


extension UIButton: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let buttonColorScheme = colorScheme as? SdkStyleButtonColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        tintColor = buttonColorScheme.buttonTintColor
    }
}


extension UITableView: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let tableViewColorScheme = colorScheme as? SdkStyleTableViewColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        backgroundColor = tableViewColorScheme.tableViewBackgroundColor
    }

    var shouldDowncastColorScheme: Bool {
        return true
    }
}


extension UICollectionView: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let collectionViewColorScheme = colorScheme as? SdkStyleCollectionViewColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        backgroundColor = collectionViewColorScheme.collectionViewBackgroundColor
    }

    var shouldDowncastColorScheme: Bool {
        return true
    }
}


extension UITableViewCell: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let tableViewColorScheme = colorScheme as? SdkStyleTableViewColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        backgroundColor = tableViewColorScheme.cellBackgroundColor
        textLabel?.textColor = tableViewColorScheme.cellTextColorColor
        detailTextLabel?.textColor = tableViewColorScheme.cellSubTextColorColor
    }

    var shouldDowncastColorScheme: Bool {
        return true
    }
}


extension UITableViewHeaderFooterView: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let tableViewColorScheme = colorScheme as? SdkStyleTableViewColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        backgroundView?.backgroundColor = tableViewColorScheme.headerBackgroundColor
        textLabel?.textColor = tableViewColorScheme.headerTextColorColor
    }
}


extension UIDatePicker: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let datePickerColorScheme = colorScheme as? SdkStyleDatePickerColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        setValue(datePickerColorScheme.datePickerTextColor, forKey: "textColor")
    }
}


extension UIRefreshControl: SdkStyleColorSchemeAwareView {
    func applyColorScheme(_ colorScheme: SdkStyleColorScheme) {
        guard let refreshControlColorScheme = colorScheme as? SdkStyleRefreshControlColorScheme else {
            return
        }

        if skipColorScheme {
            return
        }

        tintColor = refreshControlColorScheme.refreshControlTintColor
        titleColor = refreshControlColorScheme.refreshControlTextColor

        updateTitle()
    }

    private struct AssociatedKey {
        static var key = "titleColor"
    }

    public var titleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, AssociatedKey.key) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, AssociatedKey.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateTitle()
        }
    }

    public var title: String? {
        get {
            return attributedTitle?.string
        }
        set {
            guard let newTitle = newValue else {
                attributedTitle = nil
                return
            }

            attributedTitle = NSAttributedString(string: newTitle)
            updateTitle()
        }
    }

    private func updateTitle() {
        guard let titleColor = titleColor,
            let title = attributedTitle?.string else {
                return
        }

        let attrTitle = NSAttributedString(string: title,
                                           attributes: [NSAttributedString.Key.foregroundColor: titleColor])
        attributedTitle = attrTitle
    }
}
