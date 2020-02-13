//
//  LHXTableNameInputViewController.h
//  LHXKVDemo
//
//  Created by 李华夏 on 2020/2/12.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LHXTableNameInputViewControllerDelegate <NSObject>

- (void)getTableName:(NSString *)tableName;

@end

@interface LHXTableNameInputViewController : NSViewController

@property (nonatomic, weak) id <LHXTableNameInputViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
