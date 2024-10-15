//
//  ImageCache.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 08/10/2024.
//

import UIKit

class ImageCache {

    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    func loadImage(for urlString: String) async -> UIImage? {
        do {
            if let image = self.cache.object(forKey: urlString as NSString) {
                return image
            } else {
                guard let url = URL(string: urlString) else {
                    return nil
                }
                let request = URLRequest(url: url)
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    return nil
                }
                guard let image = UIImage(data: data) else {
                    return nil
                }
                
                cache.setObject(image, forKey: urlString as NSString)

                return image
            }
        } catch {
            print(error)
            return nil
        }
    }
}
