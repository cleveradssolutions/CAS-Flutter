import CleverAdsSolutions

private let fontNormal = 0
private let fontBold = 1
private let fontItalic = 2
private let fontMonospace = 3

class NativeTemplateStyle {
    let backgroundColor: UIColor?
    let primaryColor: UIColor?
    let callToActionTextColor: UIColor?
    let headlineTextColor: UIColor?
    let headlineFontStyle: Int
    let secondaryTextColor: UIColor?
    let secondaryFontStyle: Int

    init(backgroundColor: UIColor?,
         primaryColor: UIColor?,
         callToActionTextColor: UIColor?,
         headlineTextColor: UIColor?,
         headlineFontStyle: Int,
         secondaryTextColor: UIColor?,
         secondaryFontStyle: Int) {
        self.backgroundColor = backgroundColor
        self.primaryColor = primaryColor
        self.callToActionTextColor = callToActionTextColor
        self.headlineTextColor = headlineTextColor
        self.headlineFontStyle = headlineFontStyle
        self.secondaryTextColor = secondaryTextColor
        self.secondaryFontStyle = secondaryFontStyle
    }

    func applyToView(_ view: CASNativeView) {
        if let backgroundColor {
            view.backgroundColor = backgroundColor
        }

        if let primaryColor {
            if let it = view.adLabelView {
                it.layer.borderColor = primaryColor.cgColor
                it.textColor = primaryColor
            }

            let starRating = view.starRatingView as? CASStarRatingView
            starRating?.tintColor = primaryColor
        }

        if let button = view.callToActionView {
            if #available(iOS 15.0, *), var config = button.configuration {
                if let primaryColor {
                    config.baseBackgroundColor = primaryColor
                }
                if let callToActionTextColor {
                    config.baseForegroundColor = callToActionTextColor
                }
                button.configuration = config
                button.setNeedsUpdateConfiguration()
            } else {
                if let primaryColor {
                    button.backgroundColor = primaryColor
                }
                if let callToActionTextColor {
                    button.setTitleColor(callToActionTextColor, for: .normal)
                }
            }
        }

        if let it = view.headlineView {
            if let headlineTextColor {
                it.textColor = headlineTextColor
            }
            updateFontStyle(headlineFontStyle, label: it)
        }

        if let secondaryTextColor {
            view.bodyView?.textColor = secondaryTextColor
            view.advertiserView?.textColor = secondaryTextColor
            view.storeView?.textColor = secondaryTextColor
            view.priceView?.textColor = secondaryTextColor
            view.reviewCountView?.textColor = secondaryTextColor
        }

        if secondaryFontStyle >= 0 {
            updateFontStyle(secondaryFontStyle, label: view.bodyView)
            updateFontStyle(secondaryFontStyle, label: view.advertiserView)
            updateFontStyle(secondaryFontStyle, label: view.storeView)
            updateFontStyle(secondaryFontStyle, label: view.priceView)
            updateFontStyle(secondaryFontStyle, label: view.reviewCountView)
        }
    }

    private func updateFontStyle(_ style: Int, label: UILabel?) {
        guard let label else { return }

        let fontSize = label.font.pointSize
        let font: UIFont
        switch style {
        case fontNormal:
            font = UIFont.systemFont(ofSize: fontSize)
        case fontBold:
            font = UIFont.boldSystemFont(ofSize: fontSize)
        case fontItalic:
            font = UIFont.italicSystemFont(ofSize: fontSize)
        case fontMonospace:
            font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        default:
            return
        }
        label.font = font
    }
}
