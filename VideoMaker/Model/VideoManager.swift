//
//  VideoManager.swift
//  VideoMaker
//
//  Created by Vladimir Orlov on 19.12.2017.
//  Copyright © 2017 Иван Свиридов. All rights reserved.
//

import Foundation
import Photos

struct VideoManager {
  
  static func fetchVideosFromCameraRoll() -> PHFetchResult<PHAsset> {
    let options = PHFetchOptions()
    options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
    options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
    
    return PHAsset.fetchAssets(with: options)
  }
}
