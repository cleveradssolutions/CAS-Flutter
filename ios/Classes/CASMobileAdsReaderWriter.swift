import CleverAdsSolutions
import Flutter

private let valueInitStatus: UInt8 = 128
private let valueAdSize: UInt8 = 129
private let valueSize: UInt8 = 130
private let valueAdError: UInt8 = 131
private let valueTemplateStyle: UInt8 = 132
private let valueColor: UInt8 = 133
private let valueAdContentInfo: UInt8 = 134

class CASMobileAdsReaderWriter: FlutterStandardReaderWriter {
    override func reader(with data: Data) -> FlutterStandardReader {
        CASMobileAdsReader(data: data)
    }

    override func writer(with data: NSMutableData) -> FlutterStandardWriter {
        CASMobileAdsWriter(data: data)
    }
}

class CASMobileAdsWriter: FlutterStandardWriter {
    override func writeValue(_ value: Any) {
        if let config = value as? CASInitialConfig {
            writeByte(valueInitStatus)
            writeValue(config.error ?? NSNull())
            writeValue(config.countryCode ?? NSNull())
            writeValue(config.isConsentRequired)
            writeValue(config.consentFlowStatus.rawValue)
        } else if value is CGSize, let size = value as? CGSize {
            writeByte(valueSize)
            writeValue(Int(round(size.width)))
            writeValue(Int(round(size.height)))
        } else if let error = value as? AdError {
            writeByte(valueAdError)
            writeValue(error.code.rawValue)
            writeValue(error.description)
        } else if let info = value as? AdContentInfo {
            writeByte(valueAdContentInfo)
            writeValue(info.format.value)
            writeValue(info.sourceName)
            writeValue(info.sourceUnitID)
            writeValue(info.creativeID ?? NSNull())
            writeValue(info.revenue)
            writeValue(info.revenuePrecision.rawValue)
            writeValue(info.revenueTotal)
            writeValue(info.impressionDepth)
        } else {
            super.writeValue(value)
        }
    }
}

class CASMobileAdsReader: FlutterStandardReader {
    override func readValue(ofType type: UInt8) -> Any? {
        switch type {
        case valueAdSize:
            let mode = readValue(ofType: readByte()) as! Int
            let width = readValue(ofType: readByte()) as! Int
            let height = readValue(ofType: readByte()) as! Int
            switch mode {
            case 1:
                if width <= 0 {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                        return CASSize.banner
                    }
                    return AdSize.getAdaptiveBanner(inWindow: window)
                } else {
                    return AdSize.getAdaptiveBanner(forMaxWidth: CGFloat(width))
                }

            case 2:
                return AdSize.getInlineBanner(width: CGFloat(width), maxHeight: CGFloat(height))

            default:
                if height >= 250 { return AdSize.mediumRectangle }
                else if height >= 90 { return AdSize.leaderboard }
                else { return AdSize.banner }
            }

        case valueTemplateStyle:
            return NativeTemplateStyle(
                backgroundColor: readValue(ofType: readByte()) as? UIColor,
                primaryColor: readValue(ofType: readByte()) as? UIColor,
                callToActionTextColor: readValue(ofType: readByte()) as? UIColor,
                headlineTextColor: readValue(ofType: readByte()) as? UIColor,
                headlineFontStyle: readValue(ofType: readByte()) as? Int ?? -1,
                secondaryTextColor: readValue(ofType: readByte()) as? UIColor,
                secondaryFontStyle: readValue(ofType: readByte()) as? Int ?? -1
            )

        case valueColor:
            let alpha = readValue(ofType: readByte()) as! Int
            let red = readValue(ofType: readByte()) as! Int
            let green = readValue(ofType: readByte()) as! Int
            let blue = readValue(ofType: readByte()) as! Int
            return UIColor(red: CGFloat(red) / 255.0,
                           green: CGFloat(green) / 255.0,
                           blue: CGFloat(blue) / 255.0,
                           alpha: CGFloat(alpha) / 255.0)

        default:
            return super.readValue(ofType: type)
        }
    }
}
