//
//  DemoFeature.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.4
//
// Edited by: Kee Sern Chua

import Foundation

class DemoFeature: NSObject {
    
    var displayName: String
    var detailText: String
    var icon: String
    var storyboard: String
    
    init(name: String, detail: String, icon: String, storyboard: String) {
        self.displayName = name
        self.detailText = detail
        self.icon = icon
        self.storyboard = storyboard
        super.init()
    }
}
