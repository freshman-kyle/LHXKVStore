//
//  LHXKVStoreInterface.m
//  LHXKVStore
//
//  Created by 李华夏 on 2020/1/5.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import "LHXKVStoreInterface.h"
#import <FMDB/FMDB.h>

#define BASE_PATH   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface LHXKVStoreInterface()

@property(nonatomic, strong)FMDatabaseQueue *dbQueue;

@end

@implementation LHXKVStoreInterface

static NSString *const dbName = @"KVDatabase.sqlite";

static NSString *const CREATE_TABLE_SQL =  @"CREATE TABLE IF NOT EXISTS %@ (id TEXT NOT NULL, json TEXT, image BLOB, PRIMARY KEY(id))";

static NSString *const INSERT_DATA_SQL = @"INSERT OR REPLACE INTO %@ (id, json) VALUES (?, ?)";

static NSString *const INSERT_IMAGE_SQL = @"INSERT OR REPLACE INTO %@ (id, image) VALUES (?, ?)";

static NSString *const DELETE_DATA_SQL = @"DELETE FROM %@ WHERE id = ?";

static NSString *const UPDATE_DATA_SQL = @"UPDATE %@ SET json = ? WHERE id = ?";

static NSString *const UPDATE_IAMGE_SQL = @"UPDATE %@ SET image = ? WHERE id = ?";

static NSString *const QUERY_DATA_SQL = @"SELECT json FROM %@ WHERE id = ?";

static NSString *const QUERY_IMAGE_SQL = @"SELECT image FROM %@ WHERE id = ?";

static NSString *const QUERY_TABLE_NAMES_SQL = @"SELECT * FROM sqlite_master WHERE type = 'table'";

static NSString *const QUERY_ALL_SQL = @"SELECT * FROM %@";

static NSString *const COUNT_IN_TABLE_SQL = @"SELECT count(*) as num from %@";

static NSString *const CLEAR_TABLE_SQL = @"DELETE FROM %@";

static NSString *const DROP_TABLE_SQL = @"DROP TABLE '%@'";

#pragma mark - database methods
+ (instancetype)sharedInstance {
    static LHXKVStoreInterface *instance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[LHXKVStoreInterface alloc] init];
    });
    return instance;
}

- (void)initDatabase {
    NSString *dbPath = [BASE_PATH stringByAppendingPathComponent:dbName];
    NSLog(@"dnPath:%@", dbPath);
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
}

- (BOOL)checkTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        return NO;
    }
    return YES;
}

- (void)createTableWithTableName:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    __block BOOL isExisting;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        isExisting = [db tableExists:tableName];
    }];
    if (isExisting) {
        NSLog(@"table %@ exists", tableName);
        return;
    }
    NSString *createTableSql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:createTableSql];
        if (result) {
            NSLog(@"create table success");
        } else {
            NSLog(@"create table fail");
        }
    }];
}

- (void)clearTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSString *clearTableSql = [NSString stringWithFormat:CLEAR_TABLE_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:clearTableSql];
        if (result) {
            NSLog(@"clear table success");
        } else {
            NSLog(@"clear table fail");
        }
    }];
}

- (void)dropTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSString *dropTableSql = [NSString stringWithFormat:DROP_TABLE_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:dropTableSql];
        if (result) {
            NSLog(@"drop table success");
        } else {
            NSLog(@"drop table fail");
        }
    }];
}

- (void)close {
    [self.dbQueue close];
    self.dbQueue = nil;
}

#pragma mark - data operation methods
- (void)saveObject:(id)object withKey:(NSString *)objectKey inTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *insertDataSql = [NSString stringWithFormat:INSERT_DATA_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:insertDataSql, objectKey, jsonString];
        if (result) {
            NSLog(@"save object success");
        } else {
            NSLog(@"save object fail");
        }
    }];
}

- (void)saveString:(NSString *)string withKey:(NSString *)stringKey inTable:(NSString *)tableName {
    if (string == nil) {
        NSLog(@"string is nil");
        return;
    }
    [self saveObject:@[string] withKey:stringKey inTable:tableName];
}

- (void)saveNumber:(NSNumber *)number withKey:(NSString *)numberKey inTable:(NSString *)tableName {
    if (number == nil) {
        NSLog(@"number is nil");
        return;
    }
    [self saveObject:@[number] withKey:numberKey inTable:tableName];
}

- (void)saveImage:(NSImage *)image withKey:(NSString *)imageKey inTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSData *imageData = [image TIFFRepresentation];
    NSString *insertImageSql = [NSString stringWithFormat:INSERT_IMAGE_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:insertImageSql, imageKey, imageData];
        if (result) {
            NSLog(@"save image success");
        } else {
            NSLog(@"save image fail");
        }
    }];
}

- (void)deleteObjectWithKey:(NSString *)objectKey fromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSString *deleteDataSql = [NSString stringWithFormat:DELETE_DATA_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:deleteDataSql, objectKey];
        if (result) {
            NSLog(@"delete data success");
        } else {
            NSLog(@"delete data fail");
        }
    }];
}

- (void)updateObject:(id)object WithKey:(NSString *)objectKey inTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *updateDataSql = [NSString stringWithFormat:UPDATE_DATA_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:updateDataSql, jsonString, objectKey];
        if (result) {
            NSLog(@"update data success");
        } else {
            NSLog(@"update data fail");
        }
    }];
}

- (void)updateString:(id)string WithKey:(NSString *)stringKey inTable:(NSString *)tableName {
    if (string == nil) {
        NSLog(@"string is nil");
        return;
    }
    [self updateObject:@[string] WithKey:stringKey inTable:tableName];
}

- (void)updateNumber:(id)number WithKey:(NSString *)numberKey inTable:(NSString *)tableName {
    if (number == nil) {
        NSLog(@"number is nil");
        return;
    }
    [self updateObject:@[number] WithKey:numberKey inTable:tableName];
}

-(void)updateImage:(NSImage *)image WithKey:(NSString *)imageKey inTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return;
    }
    NSData *imageData = [image TIFFRepresentation];
    NSString *updateImageSql = [NSString stringWithFormat:UPDATE_IAMGE_SQL, tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:updateImageSql, imageData, imageKey];
        if (result) {
            NSLog(@"update image success");
        } else {
            NSLog(@"update image fail");
        }
    }];
}

- (id)getObjectWithKey:(NSString *)objectKey fromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return nil;
    }
    NSString *queryDataSql = [NSString stringWithFormat:QUERY_DATA_SQL, tableName];
    __block NSString *json = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:queryDataSql, objectKey];
        if ([rs next]) {
            json = [rs stringForColumn:@"json"];
        }
        [rs close];
    }];
    if (json) {
        id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingAllowFragments) error:nil];
        return result;
    } else {
        return nil;
    }
}

- (NSString *)getStringWithKey:(NSString *)stringKey fromTable:(NSString *)tableName {
    NSArray *array = [self getObjectWithKey:stringKey fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

- (NSNumber *)getNumberWithKey:(NSString *)numberKey fromTable:(NSString *)tableName {
    NSArray *array = [self getObjectWithKey:numberKey fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

- (NSImage *)getImageWithKey:(NSString *)imageKey fromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return nil;
    }
    NSString *queryImageSql = [NSString stringWithFormat:QUERY_IMAGE_SQL, tableName];
    __block NSData *imageData = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:queryImageSql, imageKey];
        while ([rs next]) {
            imageData = [rs dataForColumn:@"image"];
        }
    }];
    if (imageData) {
        NSImage *image = [[NSImage alloc] initWithData:imageData];
        return image;
    }
    return nil;
}

- (NSArray *)getAllTableNames {
    __block NSMutableArray *result = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:QUERY_TABLE_NAMES_SQL];
        while ([rs next]) {
            NSString *tableName = [rs stringForColumnIndex:1];
            [result addObject:tableName];
        }
    }];
    return result;
}

- (NSUInteger)getDataCountInTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return 0;
    }
    NSString *countDataSql = [NSString stringWithFormat:COUNT_IN_TABLE_SQL, tableName];
    __block NSUInteger count = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:countDataSql];
        if ([rs next]) {
            count = [rs unsignedLongLongIntForColumn:@"num"];
        }
        [rs close];
    }];
    return count;
}

- (NSArray *)getAllDataFromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) {
        return nil;
    }
    NSString *queryAllSql = [NSString stringWithFormat:QUERY_ALL_SQL, tableName];
    __block NSMutableArray *result = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:queryAllSql];
        while ([rs next]) {
            NSString *json = [rs stringForColumn:@"json"];
            [result addObject:json];
        }
    }];
    return result;
}

@end
