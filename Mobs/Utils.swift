//
//  Utils.swift
//  Mobs
//
//  Created by Erik Moqvist on 2023-08-30.
//

import Foundation
import UIKit

extension String: Error {}

extension String {
    func trim() -> String {
        return trimmingCharacters(in: .whitespaces)
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
}

func makeRtmpUri(url: String) -> String {
    guard var url = URL(string: url) else {
        return ""
    }
    var components = url.pathComponents
    if components.count < 2 {
        return ""
    }
    components.removeFirst()
    components.removeLast()
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    let path = components.joined(separator: "/")
    urlComponents.path = "/\(path)"
    url = urlComponents.url!
    return "\(url)"
}

func makeRtmpStreamName(url: String) -> String {
    let parts = url.split(separator: "/")
    if parts.isEmpty {
        return ""
    }
    return String(parts[parts.count - 1])
}

func replaceSensitive(value: String, sensitive: Bool) -> String {
    if sensitive {
        return value.replacing(/./, with: "*")
    } else {
        return value
    }
}

func widgetImage(widget: SettingsWidget) -> String {
    switch widget.type {
    case "Image":
        return "photo"
    case "Video effect":
        return "camera.filters"
    case "Camera":
        return "camera"
    default:
        return ""
    }
}
