//
//  ConditionSetting.swift
//  swf-FMDatabaseDAO-demo
//
//  Created by S.Emoto on 2018/05/12.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import Foundation

enum ConditionType {
    case Equal  // 等しい
    case Not    // 等しくない
    case Under  // 未満
    case Less   // 以下
    case More   // 以上
    case Over   // より大きい
}

enum ConditionRelation {
    case AND
    case OR
    case NOT
}

final class FMDBConditionSetting {
    
    //MARK: - 条件タイプの指定
    func setConditionType(conditionType: ConditionType) -> String {
        
        var conditionTypeStr = ""
        
        switch conditionType {
        case .Equal:
            conditionTypeStr = "="
            break
        case .Not:
            conditionTypeStr = "<>"
            break
        case .Under:
            conditionTypeStr = "<"
            break
        case .Less:
            conditionTypeStr = "<="
            break
        case .More:
            conditionTypeStr = ">="
            break
        case .Over:
            conditionTypeStr = ">"
            break
        }
        
        return conditionTypeStr
    }
    
    //MARK: - 論理演算子の指定
    func setConditionRelation(conditionRelation: ConditionRelation) -> String {
        
        var conditionRelationStr = ""
        
        switch conditionRelation {
        case .AND:
            conditionRelationStr = "AND"
            break
        case .OR:
            conditionRelationStr = "OR"
            break
        case .NOT:
            conditionRelationStr = "NOT"
            break
        }
        
        return conditionRelationStr
    }
}
