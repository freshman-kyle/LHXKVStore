//
//  LHXTableNameInputViewController.m
//  LHXKVDemo
//
//  Created by 李华夏 on 2020/2/12.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import "LHXTableNameInputViewController.h"

@interface LHXTableNameInputViewController ()

@property (weak) IBOutlet NSTextField *tableNameTextField;

@end

@implementation LHXTableNameInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)confirmButtonClicked:(id)sender {
    if (self.tableNameTextField.stringValue.length > 0) {
        [self.delegate getTableName:self.tableNameTextField.stringValue];
        [self dismissViewController:self];
    }
}

@end
