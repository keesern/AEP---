//
//  UserProfileDB.swift
//  MySampleApp
//
//  Created by xuxiak on 2016/10/26.
//
//

import Foundation
import AWSDynamoDB
import UIKit
import AWSCore

class UserProfileTableRow : AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {

    
    var EmailAddress:String?
    var LastName:String?
    var FirstName:String?
    
    
    
    class func dynamoDBTableName() -> String! {
        return "UserProfile"
    }
    
    
    class func hashKeyAttribute() -> String! {
        return "EmailAddress"
    }
    
    
    
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object)
    }
    
    override func `self`() -> Self {
        return self
    }
    
}
