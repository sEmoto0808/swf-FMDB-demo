//
//  ViewController.swift
//  swf-FMDatabaseDAO-demo
//
//  Created by S.Emoto on 2018/05/12.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(SwiftyFMDBDaoHelper.dao.dbPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

