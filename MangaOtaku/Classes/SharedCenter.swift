//
//  SharedCenter.swift
//  MangaOtaku
//
//  Created by Vox Long on 1/19/17.
//  Copyright © 2017 Vox Long. All rights reserved.
//

import UIKit

class SharedCenter: NSObject {
    static let sharedInstance = SharedCenter()
    private override init() {}
    var genres : [Genre] =  [Genre]()
}
