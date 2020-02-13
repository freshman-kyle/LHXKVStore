//
//  LHXMainViewController.m
//  LHXKVDemo
//
//  Created by 李华夏 on 2020/2/9.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import "LHXMainViewController.h"
#import <LHXKVStore/LHXKVStore.h>
#import "LHXTableNameInputViewController.h"
#import "LHXTableDetailViewController.h"

@interface LHXMainViewController ()<NSTableViewDelegate, NSTableViewDataSource, LHXTableNameInputViewControllerDelegate>

@property (weak) IBOutlet NSTableView *dbTableView;
@property (weak) IBOutlet NSButton *addTableButton;
@property (weak) IBOutlet NSButton *deleteTableButton;
@property (weak) IBOutlet NSButton *clearTableButton;
@property (weak) IBOutlet NSButton *showDetailButton;

@property (nonatomic, strong) NSArray *tableNameArray;
@property (nonatomic, strong) NSMutableArray *dataCountArray;

@end

@implementation LHXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.addTableButton setEnabled:NO];
    [self.deleteTableButton setEnabled:NO];
    [self.clearTableButton setEnabled:NO];
    [self.showDetailButton setEnabled:NO];
    self.dbTableView.delegate = self;
    self.dbTableView.dataSource = self;
    self.tableNameArray = [NSArray array];
    self.dataCountArray = [NSMutableArray array];
}

#pragma mark - button actions
- (IBAction)initAndUpdateDB:(id)sender {
    LHXKVStoreInterface *kvStore = [LHXKVStoreInterface sharedInstance];
    [kvStore initDatabase];
    [self reloadTableViewData];
    [self.addTableButton setEnabled:YES];
}

- (IBAction)addTableInDatabase:(id)sender {
    LHXTableNameInputViewController *tableNameVC = [[LHXTableNameInputViewController alloc] initWithNibName:@"LHXTableNameInputViewController" bundle:nil];
    tableNameVC.delegate = self;
    [self presentViewController:tableNameVC asPopoverRelativeToRect:CGRectMake(0, 0, 10, 10) ofView:self.addTableButton preferredEdge:NSRectEdgeMaxY behavior:NSPopoverBehaviorTransient];
}

- (IBAction)removeTableInDatabase:(id)sender {
    LHXKVStoreInterface *kvStore = [LHXKVStoreInterface sharedInstance];
    [kvStore dropTable:[self getTableNameInSelectedRow]];
    [self reloadTableViewData];
}

- (IBAction)clearTableInDatabase:(id)sender {
    LHXKVStoreInterface *kvStore = [LHXKVStoreInterface sharedInstance];
    [kvStore clearTable:[self getTableNameInSelectedRow]];
    [self reloadTableViewData];
}

- (IBAction)showTableDetail:(id)sender {
    LHXTableDetailViewController *detailVc = [[LHXTableDetailViewController alloc] initWithNibName:@"LHXTableDetailViewController" bundle:nil];
    detailVc.tableName = [self getTableNameInSelectedRow];
    [self presentViewControllerAsSheet:detailVc];
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.tableNameArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([tableColumn.identifier isEqualToString:@"tableName"]) {
        cellView.textField.stringValue = self.tableNameArray[row];
    } else if ([tableColumn.identifier isEqualToString:@"dataCount"]) {
        cellView.textField.stringValue = self.dataCountArray[row];
    } else {
        return nil;
    }
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    BOOL buttonState;
    if ([self getTableNameInSelectedRow] == nil) {
        buttonState = NO;
    } else {
        buttonState = YES;
    }
    [self.deleteTableButton setEnabled:buttonState];
    [self.clearTableButton setEnabled:buttonState];
    [self.showDetailButton setEnabled:buttonState];
}

#pragma mark - LHXTableNameInputViewControllerDelegate
- (void)getTableName:(NSString *)tableName {
    LHXKVStoreInterface *kvStore = [LHXKVStoreInterface sharedInstance];
    [kvStore createTableWithTableName:tableName];
    [self reloadTableViewData];
}

#pragma mark - other methods
- (NSString *)getTableNameInSelectedRow {
    NSInteger row = [self.dbTableView selectedRow];
    if (row >= 0 && row < self.tableNameArray.count) {
        return self.tableNameArray[row];
    }
    return nil;
}

- (void)reloadTableViewData {
    LHXKVStoreInterface *kvStore = [LHXKVStoreInterface sharedInstance];
    self.tableNameArray = [kvStore getAllTableNames];
    [self.dataCountArray removeAllObjects];
    for (NSString *tableName in self.tableNameArray) {
        NSUInteger count = [kvStore getDataCountInTable:tableName];
        [self.dataCountArray addObject:[NSString stringWithFormat:@"%lu", count]];
    }
    [self.dbTableView reloadData];
}

@end
