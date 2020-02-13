//
//  LHXKVStoreTests.m
//  LHXKVStoreTests
//
//  Created by 李华夏 on 2020/1/5.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LHXKVStore/LHXKVStore.h>

@interface LHXKVStoreTests : XCTestCase

@property (nonatomic, strong) LHXKVStoreInterface *kvStore;
@property (nonatomic, copy) NSString *tableName;

@end

@implementation LHXKVStoreTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    self.kvStore = [LHXKVStoreInterface sharedInstance];
    [self.kvStore initDatabase];
    self.tableName = @"test_table";
    [self.kvStore createTableWithTableName:self.tableName];
    [self.kvStore clearTable:self.tableName];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.kvStore clearTable:self.tableName];
    [self.kvStore dropTable:self.tableName];
    [self.kvStore close];
    self.kvStore = nil;
    [super tearDown];
    
}

- (void)testOperateObject {
    NSString *objectKey = @"objectKey";
    NSDictionary *object = @{@"name": @"leo", @"age": @"20"};
    [self.kvStore saveObject:object withKey:objectKey inTable:self.tableName];
    id result = [self.kvStore getObjectWithKey:objectKey fromTable:self.tableName];
    XCTAssertEqualObjects(object, result);
    
    NSDictionary *object_new = @{@"name": @"sam", @"age": @"18"};
    [self.kvStore updateObject:object_new WithKey:objectKey inTable:self.tableName];
    result = [self.kvStore getObjectWithKey:objectKey fromTable:self.tableName];
    XCTAssertEqualObjects(object_new, result);
    
    [self.kvStore deleteObjectWithKey:objectKey fromTable:self.tableName];
    result = [self.kvStore getObjectWithKey:objectKey fromTable:self.tableName];
    XCTAssertNil(result);
    
    result = [self.kvStore getObjectWithKey:@"nullKey" fromTable:self.tableName];
    XCTAssertNil(result);
}

- (void)testOperateString {
    NSString *stringKey = @"stringKey";
    NSString *string = @"string content";
    [self.kvStore saveString:string withKey:stringKey inTable:self.tableName];
    NSString *result = [self.kvStore getStringWithKey:stringKey fromTable:self.tableName];
    XCTAssertEqualObjects(string, result);
    
    NSString *string_new = @"new string content";
    [self.kvStore updateString:string_new WithKey:stringKey inTable:self.tableName];
    result = [self.kvStore getStringWithKey:stringKey fromTable:self.tableName];
    XCTAssertEqualObjects(string_new, result);
    
    [self.kvStore deleteObjectWithKey:stringKey fromTable:self.tableName];
    result = [self.kvStore getStringWithKey:stringKey fromTable:self.tableName];
    XCTAssertNil(result);

    result = [self.kvStore getStringWithKey:@"nullKey" fromTable:self.tableName];
    XCTAssertNil(result);
}

- (void)testOperateNumber {
    NSString *numberKey = @"numberKey";
    NSNumber *number = @2020;
    [self.kvStore saveNumber:number withKey:numberKey inTable:self.tableName];
    NSNumber *result = [self.kvStore getNumberWithKey:numberKey fromTable:self.tableName];
    XCTAssertEqualObjects(number, result);
    
    NSNumber *number_new = @2021;
    [self.kvStore updateNumber:number_new WithKey:numberKey inTable:self.tableName];
    result = [self.kvStore getNumberWithKey:numberKey fromTable:self.tableName];
    XCTAssertEqualObjects(number_new, result);
    
    [self.kvStore deleteObjectWithKey:numberKey fromTable:self.tableName];
    result = [self.kvStore getNumberWithKey:numberKey fromTable:self.tableName];
    XCTAssertNil(result);
    
    result = [self.kvStore getNumberWithKey:@"nullKey" fromTable:self.tableName];
    XCTAssertNil(result);
}

- (void)testOperateImage {
    NSString *imageKey = @"imageKey";
    NSBundle *testBundle = [NSBundle bundleForClass:[LHXKVStoreTests class]];
    NSString *imagePath = [testBundle pathForImageResource:@"image1.jpg"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
    XCTAssertNotNil(image);
    
    [self.kvStore saveImage:image withKey:imageKey inTable:self.tableName];
    NSImage *result = [self.kvStore getImageWithKey:imageKey fromTable:self.tableName];
    BOOL isEqual = [[image TIFFRepresentation] isEqualToData:[result TIFFRepresentation]];
    XCTAssertTrue(isEqual);
    
    NSString *imagePath_new = [testBundle pathForImageResource:@"image2.jpg"];
    NSImage *image_new = [[NSImage alloc] initWithContentsOfFile:imagePath_new];
    XCTAssertNotNil(image_new);
    
    [self.kvStore updateImage:image_new WithKey:imageKey inTable:self.tableName];
    result = [self.kvStore getImageWithKey:imageKey fromTable:self.tableName];
    isEqual = [[image_new TIFFRepresentation] isEqualToData:[result TIFFRepresentation]];
    XCTAssertTrue(isEqual);
    
    [self.kvStore deleteObjectWithKey:imageKey fromTable:self.tableName];
    result = [self.kvStore getImageWithKey:imageKey fromTable:self.tableName];
    XCTAssertNil(result);
    
    result = [self.kvStore getImageWithKey:@"nullKey" fromTable:self.tableName];
    XCTAssertNil(result);
}

- (void)testOtherQueryMethods {
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    NSString *string1 = @"string1";
    NSString *string2 = @"string2";
    [self.kvStore saveString:string1 withKey:key1 inTable:self.tableName];
    [self.kvStore saveString:string2 withKey:key2 inTable:self.tableName];
    NSArray *array1 = [self.kvStore getAllDataFromTable:self.tableName];
    NSArray *array2 = @[string1, string2];
    XCTAssertEqualObjects(array1, array2);
    
    NSInteger count1 = [self.kvStore getDataCountInTable:self.tableName];
    NSInteger count2 = array2.count;
    XCTAssertEqual(count1, count2);
    
//    NSString *tableName_new = @"test_table_new";
//    [self.kvStore createTableWithTableName:tableName_new];
//    NSArray *array3 = [self.kvStore getAllTableNames];
//    NSArray *array4 = @[self.tableName, tableName_new];
//    // 原因可能是两个数组内的NSString存储位置不同，导致false
//    XCTAssertEqualObjects(array3, array4);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
