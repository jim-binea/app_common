//
//  DeviceSupport.swift
//  GradingTest
//
//  Created by Leo on 2016/10/10.
//  Copyright © 2016年 DoSoMi. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import RxSwift

public enum AuthorityStatus {
    case allAuthorized
    case audioNotDetermined
    case videoNotDetermined
    case audioDenied
    case videoDenied
}


public class DeviceSupport {
    static public let `default` = DeviceSupport()
    
    public func cameraAuthorityStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    }
    
    public func requestCameraAuthority(completionHandler handler: ((Bool) -> Void)?) {
        return AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (sucess) in
            DispatchQueue.main.async {
                handler?(sucess)
            }
        })
    }
    
    public func microphoneAuthorityStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
    }
    
    public func requestMicrophoneAuthority(completionHandler handler: ((Bool) -> Void)?) {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (sucess) in
            DispatchQueue.main.async {
                handler?(sucess)
            }
        })
    }
    
    public func photoAuthorityStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    public func checkDeviceRecordAuthority() -> Observable<AuthorityStatus> {
        let cameraAuth = cameraAuthorityStatus()
        let micAuth = microphoneAuthorityStatus()
        if cameraAuth == .denied || cameraAuth == .restricted {
            return Observable<AuthorityStatus>.just(.videoDenied)
        }
        if micAuth == .notDetermined {
            return Observable<AuthorityStatus>.just(.audioNotDetermined)
        }
        if cameraAuth == .notDetermined {
            return Observable<AuthorityStatus>.just(.videoNotDetermined)
        }
        if micAuth == .denied || micAuth == .restricted {
            return Observable<AuthorityStatus>.just(.audioDenied)
        }
        return Observable<AuthorityStatus>.just(.allAuthorized)
    }
    
    public func openSystemSetting() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [String: AnyObject](), completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
}
