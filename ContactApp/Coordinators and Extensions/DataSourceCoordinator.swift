//
//  DataSourceCoordinator.swift
//  ContactApp
//
//  Created by Anil Telaich on 30/11/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import Foundation

protocol DataSourceDelegate : class {
    func dataSource(dataSourceInfo:Any?) -> [Any]
}

class DataSourceCoordinator {
    var dataSourceInfo : Any?
    init(withDataSourceInfo dataSourceInfo:Any?) {
        self.dataSourceInfo = dataSourceInfo
    }
}

extension DataSourceCoordinator : DataSourceDelegate {
    func dataSource(dataSourceInfo: Any?) -> [Any] {
        return ContactDataSource(dataSourceInfo: dataSourceInfo).contactsList()
    }
}
