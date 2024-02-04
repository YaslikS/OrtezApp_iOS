//
//  UserDevicesStatus+CoreDataProperties.swift
//  
//
//  Created by Александр Александрович on 24.08.2022.
//
//

import Foundation
import CoreData


extension UserDevicesStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDevicesStatus> {
        return NSFetchRequest<UserDevicesStatus>(entityName: "UserDevicesStatus")
    }

    @NSManaged public var code: String?
    @NSManaged public var firmwareNumber: Int16
    @NSManaged public var powerFirst: Int16
    @NSManaged public var powerSecond: Int16
    @NSManaged public var rssi: Int16
    @NSManaged public var type: String?
    @NSManaged public var program: Int32
    @NSManaged public var device: UserDevices?

}
