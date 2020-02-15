//
//  LHXTableDetailViewController.m
//  LHXKVDemo
//
//  Created by 李华夏 on 2020/2/12.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import "LHXTableDetailViewController.h"
#import <LHXKVStore/LHXKVStore.h>

@interface LHXTableDetailViewController ()

@property (nonatomic, strong) LHXKVStoreInterface *kvStore;

@property (weak) IBOutlet NSTextField *textLabel;
@property (weak) IBOutlet NSImageView *imageView;

@end

@implementation LHXTableDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.kvStore = [LHXKVStoreInterface sharedInstance];
}

#pragma mark - button actions
- (IBAction)insertText:(id)sender {
    NSString *key = @"textKey";
    NSString *string = @"This is old string";
    [self.kvStore saveString:string withKey:key inTable:self.tableName];
}

- (IBAction)queryText:(id)sender {
    NSString *key = @"textKey";
    NSString *text = [self.kvStore getStringWithKey:key fromTable:self.tableName];
    if (text) {
        self.textLabel.stringValue = text;
    } else {
        self.textLabel.stringValue = @"无数据";
    }
}

- (IBAction)updateText:(id)sender {
    NSString *key = @"textKey";
    NSString *newString = @"This is new string";
    [self.kvStore updateString:newString WithKey:key inTable:self.tableName];
}

- (IBAction)deleteText:(id)sender {
    NSString *key = @"textKey";
    [self.kvStore deleteObjectWithKey:key fromTable:self.tableName];
}

- (IBAction)insertImage:(id)sender {
    NSImage *image = [NSImage imageNamed:@"image1.jpg"];
    NSString *key = @"imageKey";
    [self.kvStore saveImage:image withKey:key inTable:self.tableName];
}

- (IBAction)queryImage:(id)sender {
    NSString *key = @"imageKey";
    NSImage *image = [self.kvStore getImageWithKey:key fromTable:self.tableName];
    if (image) {
        self.imageView.image = image;
    } else {
        self.imageView.image = [NSImage imageNamed:@"image0.jpg"];
    }
}

- (IBAction)updateImage:(id)sender {
    NSString *key = @"imageKey";
    NSImage *image = [NSImage imageNamed:@"image2.jpg"];
    [self.kvStore updateImage:image WithKey:key inTable:self.tableName];
}

- (IBAction)deleteImage:(id)sender {
    NSString *key = @"imageKey";
    [self.kvStore deleteObjectWithKey:key fromTable:self.tableName];
}

- (IBAction)backToLastVC:(id)sender {
    [self dismissViewController:self];
}

@end
