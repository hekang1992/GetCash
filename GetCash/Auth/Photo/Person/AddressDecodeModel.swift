//
//  AddressDecodeModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/21.
//

import Foundation
import BRPickerView

struct AddressDecodeModel {
    static func getAddressModelArray(dataSourceArr: [settledModel]) -> [BRTextModel] {
        return dataSourceArr.enumerated().map { provinceIndex, provinceDic in
            let provinceModel = BRTextModel()
            provinceModel.code = String(provinceDic.suspended ?? 0)
            provinceModel.text = provinceDic.planet
            provinceModel.index = provinceIndex
            
            let cityList = provinceDic.settled ?? []
            provinceModel.children = cityList.enumerated().map { cityIndex, cityDic in
                let cityModel = BRTextModel()
                cityModel.code = String(cityDic.suspended ?? 0)
                cityModel.text = cityDic.planet
                cityModel.index = cityIndex
                
                let areaList = cityDic.settled ?? []
                cityModel.children = areaList.enumerated().map { areaIndex, areaDic in
                    let areaModel = BRTextModel()
                    areaModel.code = String(areaDic.suspended ?? 0)
                    areaModel.text = areaDic.planet
                    areaModel.index = areaIndex
                    return areaModel
                }
                
                return cityModel
            }
            
            return provinceModel
        }
    }
}

class AppCityModel {
    static let shared = AppCityModel()
    private init() {}
    var modelArray: [settledModel]?
}
