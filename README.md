# LHXKVStore

#### 使用说明

##### 1.前言

- 本项目采用sqlite3进行存储，通过FMDB操作sqlite
- 适用于MacOS开发
- 支持字符串、数字、图片等类型
- 提供了demo 
- 支持cocoapods

#####2.导入

- 通过cocoapods导入

```shell
pod 'LHXKVStore'
```

- 手动导入：将LHXKVStore和FMDB直接拖入工程

##### 3. 使用

- 导入头文件

```objective-c
#import <LHXKVStore/LHXKVStore.h>		
```

- 数据库初始化

```objective-c
// 创建数据库 
LHXKVStoreInterface *kvStore = [LHXKVStoreInterface sharedInstance];
[kvStore initDatabase];

// 关闭数据库
[kvStore close];
```

- 表操作

```objective-c
// 创建表
- (void)createTableWithTableName:(NSString *)tableName;

// 清空表
- (void)clearTable:(NSString *)tableName;

// 删除表
- (void)dropTable:(NSString *)tableName;
```

- 数据操作

```objective-c
// 存储
- (void)saveObject:(id)object withKey:(NSString *)objectKey inTable:(NSString *)tableName;
- (void)saveString:(NSString *)string withKey:(NSString *)stringKey inTable:(NSString *)tableName;
- (void)saveNumber:(NSNumber *)number withKey:(NSString *)numberKey inTable:(NSString *)tableName;
- (void)saveImage:(NSImage *)image withKey:(NSString *)imageKey inTable:(NSString *)tableName;

// 删除
- (void)deleteObjectWithKey:(NSString *)objectKey fromTable:(NSString *)tableName;

// 修改
- (void)updateObject:(id)object WithKey:(NSString *)objectKey inTable:(NSString *)tableName;
- (void)updateString:(id)string WithKey:(NSString *)stringKey inTable:(NSString *)tableName;
- (void)updateNumber:(id)number WithKey:(NSString *)numberKey inTable:(NSString *)tableName;
- (void)updateImage:(NSImage *)image WithKey:(NSString *)imageKey inTable:(NSString *)tableName;

// 查询
- (id)getObjectWithKey:(NSString *)objectKey fromTable:(NSString *)tableName;
- (NSString *)getStringWithKey:(NSString *)stringKey fromTable:(NSString *)tableName;
- (NSNumber *)getNumberWithKey:(NSString *)numberKey fromTable:(NSString *)tableName;
- (NSImage *)getImageWithKey:(NSString *)imageKey fromTable:(NSString *)tableName;
- (NSArray *)getAllTableNames;
- (NSUInteger)getDataCountInTable:(NSString *)tableName;
- (NSArray *)getAllDataFromTable:(NSString *)tableName;
```



> 本项目参考了https://github.com/yuantiku/YTKKeyValueStore的实现，在此表示感谢！
>
> 有问题欢迎留言~

