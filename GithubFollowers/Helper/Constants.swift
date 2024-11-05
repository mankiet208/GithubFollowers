//
//  SFSymbols.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 14/10/2024.
//

import UIKit

enum SFSymbols {
    static let location = "mappin.and.ellipse"
    static let repos = "folder"
    static let gists = "text.alignleft"
    static let followers = "person.2"
    static let followings = "heart"
}

enum Images {
    static let githubLogo = UIImage(named: "gh-logo")
    static let githubAvatar = UIImage(named: "avatar-placeholder")
    static let emptyLogo = UIImage(named: "empty-state-logo")
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    
    static let isiPhoneSEGen3rd = idiom == .phone && ScreenSize.maxLength == 667
    
    // iPhone 15
    static let isiPhone15AndPro = idiom == .phone && ScreenSize.maxLength == 852
    static let isiPhone16PlusAndProMax = idiom == .phone && ScreenSize.maxLength == 932
    
    // iPhone 16
    static let isiPhone16 = idiom == .phone && ScreenSize.maxLength == 852
    static let isiPhone16Pro = idiom == .phone && ScreenSize.maxLength == 874
    static let isiPhone16Plus = idiom == .phone && ScreenSize.maxLength == 932
    static let isiPhone16ProMax = idiom == .phone && ScreenSize.maxLength == 956
    
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
