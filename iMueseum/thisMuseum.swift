//
//  thisMuseum.swift
//  iMueseum
//
//  Created by Samuel MCDONALD on 2/25/17.
//  Copyright © 2017 Samuel MCDONALD. All rights reserved.
//

import UIKit

class ThisMuseum: UITableViewCell {

    @IBOutlet var showMuseum    :UILabel!
    @IBOutlet var showAddress   :UILabel!
    @IBOutlet var showCity      :UILabel!
    @IBOutlet var showStateZip  :UILabel!
    
        var museumName:String = ""
        var locationAddress:String = ""
        var locationCity:String = ""
        var locationStateZip:String = ""
    
}


 extension ThisMuseum{
    
    convenience init(museumName:String, locationAddress: String, locationCity:String, locationStateZip:String ){
        self.init()
        
        self.museumName = museumName
        self.locationAddress = locationAddress
        self.locationCity = locationCity
        self.locationStateZip = locationStateZip
        
    }
}

        //var lastLine: String
    /*init (museumName:String, locationAddress: String, locationCity:String, locationState:String, locationZip:String ){
        self.museumName = museumName
        self.locationAddress = locationAddress
        self.locationCity = locationCity
        self.locationState = locationState
        self.locationZip = locationZip
    
    
    required super.init?(coder, aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    


