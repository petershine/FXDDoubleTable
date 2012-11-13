//
//  FXDcontrollerMain.h
//  FXDDoubleTable
//
//  Created by petershine on 11/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FXDcontrollerSubTable.h"


@interface FXDcontrollerMain : UIViewController

@property (assign, nonatomic) DOUBLE_TABLE_STATE lastDoubleTableState;

@property (strong, nonatomic) FXDcontrollerSubTable *behindSubTable;
@property (strong, nonatomic) FXDcontrollerSubTable *frontSubTable;


- (void)configureSubTablesForDoubleTableState:(DOUBLE_TABLE_STATE)doubleTableState;

- (CGFloat)frontSubTableOriginYforDoubleTableState:(DOUBLE_TABLE_STATE)doubleTableState;

@end
