//
//  SwiftyFMDBDaoHelper.swift
//  swf-FMDatabaseDAO-demo
//
//  Created by S.Emoto on 2018/05/12.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import Foundation
import FMDB

final class SwiftyFMDBDaoHelper {
    
    static let dao = SwiftyFMDBDaoHelper()
    private let conditionSetting = FMDBConditionSetting()
    
    // DBのパス
    var dbPath: String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths[0] as String
        
        // DB名は任意で変更可
        return dir + "/app.db"
    }
    
    // DB
    var db: FMDatabase {
        
        return FMDatabase(path: dbPath)
    }
    
    private init() {}
    
    //MARK: - DB ExecuteUpdate (Create, Insert, Update, Delete)
    func executeUpdate(sql: String) -> Bool {
        db.open()
        let result = db.executeUpdate(sql, withArgumentsIn: [])
        db.close()
        
        return result
    }
    
    //MARK: - DB ExecuteQuery (Select)
    func executeQuery(sql: String) -> FMResultSet? {
        db.open()
        let result = db.executeQuery(sql, withArgumentsIn: [])
        db.close()
        
        guard let resultCheck = result else {
            return nil
        }
        return resultCheck
    }
    
    //MARK: - CreateSQL
    // テーブル作成SQL
    func createTableSQL(tableName: String, primaryColumn: [String:String], columnList:[[String:String]]) -> String {
        
        let primaryColumnName = primaryColumn["name"] ?? ""
        let primaryColumnType = primaryColumn["type"] ?? ""
        
        // Primary Key まで指定
        var tableSql =
            "CREATE TABLE IF NOT EXISTS \(tableName) (" +
            "\(primaryColumnName) \(primaryColumnType) PRIMARY KEY AUTOINCREMENT"
        
        // 任意の数分カラムを追加
        for column in columnList {
            
            let columnName = column["name"] ?? ""
            let columnType = column["type"] ?? ""
            
            tableSql += ", \(columnName) \(columnType)"
        }
        
        tableSql += ");"
        return tableSql
    }
    
    //MARK: - InsertSQL
    // レコードをInsertする
    func insertDataSQL(tableName: String, dataSetList:[[String:String]]) -> String{
        // 対象カラム指定
        var insertSql =
            "INSERT INTO \(tableName) ("
        // 任意のデータ分だけ対象カラムを追加
        for dataSet in dataSetList {
            
            let columnName = dataSet["name"] ?? ""
            insertSql += "\(columnName), "
        }
        // 不要な「, 」を削除
        insertSql = String(insertSql.prefix(insertSql.count - 2))
        print("insertSql: " + insertSql + "\n")
        
        // 対象データ指定
        insertSql += ") VALUES ("
        // 任意のデータ分だけ登録データを追加
        for dataSet in dataSetList {
            
            let columnData = dataSet["data"] ?? ""
            insertSql += "\(columnData), "
        }
        // 不要な「, 」を削除
        insertSql = String(insertSql.prefix(insertSql.count - 2))
        print(insertSql)
        
        insertSql += ");"
        return insertSql
    }
    
    //MARK: - UpdateSQL
    // レコードをUpdateする
    func updateDataSQL(tableName: String, dataSetList:[[String:String]], conditions:[[String:String]]?) -> String{
        //  対象カラム指定
        var updateSql =
        "UPDATE \(tableName) SET "
        // 任意のデータ分だけ対象カラムを追加
        for dataSet in dataSetList {
            
            let columnName = dataSet["name"] ?? ""
            let columnData = dataSet["data"] ?? ""
            updateSql += "\(columnName) = \(columnData) AND "
        }
        // 不要な「AND 」を削除
        updateSql = String(updateSql.prefix(updateSql.count - 4))
        print("updateSql: " + updateSql + "\n")
        
        guard let conditions = conditions else {
            // 条件がない場合はここでreturn
            updateSql += ";"
            return updateSql
        }
        
        // 条件指定
        updateSql += "WHERE "
        // 任意のデータ分だけ登録データを追加
        for condition in conditions {
            
            let conditionColumnName = condition["name"] ?? ""
            let conditionColumnData = condition["data"] ?? ""
            updateSql += "\(conditionColumnName) == \(conditionColumnData) AND "
        }
        // 不要な「AND 」を削除
        updateSql = String(updateSql.prefix(updateSql.count - 4))
        print("updateSql: " + updateSql + "\n")
        
        updateSql += ";"
        return updateSql
    }
    
    //MARK: - SelectSQL
    // レコードをSelectする
    func selectDataSQL(tableName: String, dataSetList:[[String:String]]?, conditions:[[String:String]]?, conditionType: ConditionType, conditionRelation: ConditionRelation) -> String{
        
        //  対象カラム指定
        var selectSql = "SELECT "
        // 任意のデータ分だけ対象カラムを追加
        guard let dataSetList = dataSetList else {
            // カラム指定がない場合はここでreturn
            selectSql += "* FROM \(tableName);"
            return selectSql
        }
        for dataSet in dataSetList {
            
            let columnName = dataSet["name"] ?? ""
            selectSql += "\(columnName), "
        }
        // 不要な「, 」を削除
        selectSql = String(selectSql.prefix(selectSql.count - 2))
        print("selectSql: " + selectSql + "\n")
        
        selectSql += " FROM \(tableName)"
        
        guard let conditions = conditions else {
            // 条件がない場合はここでreturn
            selectSql += ";"
            return selectSql
        }
        
        // 条件指定
        selectSql += "WHERE "
        
        // 条件タイプの指定
        let conditionTypeStr = conditionSetting.setConditionType(conditionType: conditionType)
        
        // 論理演算子の指定
        let conditionRelationStr = conditionSetting.setConditionRelation(conditionRelation: conditionRelation)
        
        // 任意のデータ分だけ登録データを追加
        for condition in conditions {
            
            let conditionColumnName = condition["name"] ?? ""
            let conditionColumnData = condition["data"] ?? ""
            
            if conditionRelation == .NOT {
                // 「NOT」の場合は条件式よりも先に論理演算子がくる
                selectSql += "\(conditionRelationStr) "
            }
            
            selectSql += "\(conditionColumnName) \(conditionTypeStr) \(conditionColumnData) \(conditionRelationStr) "
        }
        // 末尾の不要な「論理演算子 」を削除
        selectSql = String(selectSql.prefix(selectSql.count - (conditionRelationStr.count + 1)))
        print("selectSql: " + selectSql + "\n")
        
        selectSql += ";"
        return selectSql
    }
    
    //MARK: - DeleteSQL
    // レコードをDeleteする
    func deleteDataSQL(tableName: String, conditions:[[String:String]]?) -> String{
        
        var deleteSql =
        "DELETE FROM \(tableName) "
        
        guard let conditions = conditions else {
            // 条件がない場合はここでreturn
            deleteSql += ";"
            return deleteSql
        }
        
        //  条件指定
        deleteSql += "WHERE "
        // 任意の条件分だけ削除条件を追加
        for condition in conditions {
            
            let conditionColumnName = condition["name"] ?? ""
            let conditionColumnData = condition["data"] ?? ""
            deleteSql += "\(conditionColumnName) = \(conditionColumnData) AND "
        }
        // 不要な「AND 」を削除
        deleteSql = String(deleteSql.prefix(deleteSql.count - 4))
        print("deleteSql: " + deleteSql + "\n")
        
        deleteSql += ";"
        return deleteSql
    }
    
}
