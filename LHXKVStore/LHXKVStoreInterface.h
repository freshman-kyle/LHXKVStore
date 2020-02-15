//
//  LHXKVStoreInterface.h
//  LHXKVStore
//
//  Created by 李华夏 on 2020/1/5.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHXKVStoreInterface : NSObject

+ (instancetype)sharedInstance;

- (void)initDatabase;

- (void)createTableWithTableName:(NSString *)tableName;

- (void)clearTable:(NSString *)tableName;

- (void)dropTable:(NSString *)tableName;

- (void)close;

- (void)saveObject:(id)object withKey:(NSString *)objectKey inTable:(NSString *)tableName;

- (void)saveString:(NSString *)string withKey:(NSString *)stringKey inTable:(NSString *)tableName;

- (void)saveNumber:(NSNumber *)number withKey:(NSString *)numberKey inTable:(NSString *)tableName;

- (void)saveImage:(NSImage *)image withKey:(NSString *)imageKey inTable:(NSString *)tableName;

- (void)deleteObjectWithKey:(NSString *)objectKey fromTable:(NSString *)tableName;

- (void)updateObject:(id)object WithKey:(NSString *)objectKey inTable:(NSString *)tableName;

- (void)updateString:(id)string WithKey:(NSString *)stringKey inTable:(NSString *)tableName;

- (void)updateNumber:(id)number WithKey:(NSString *)numberKey inTable:(NSString *)tableName;

- (void)updateImage:(NSImage *)image WithKey:(NSString *)imageKey inTable:(NSString *)tableName;

- (id)getObjectWithKey:(NSString *)objectKey fromTable:(NSString *)tableName;

- (NSString *)getStringWithKey:(NSString *)stringKey fromTable:(NSString *)tableName;

- (NSNumber *)getNumberWithKey:(NSString *)numberKey fromTable:(NSString *)tableName;

- (NSImage *)getImageWithKey:(NSString *)imageKey fromTable:(NSString *)tableName;

- (NSArray *)getAllTableNames;

- (NSUInteger)getDataCountInTable:(NSString *)tableName;

- (NSArray *)getAllDataFromTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
