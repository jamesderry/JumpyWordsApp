//
//  SettingsTableViewController.h
//  iOS3Lab3
//
//  Created by James Derry on 11/18/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate <NSObject>

@required
- (void)didChangeSettings:(NSDictionary *)settings;

@end


@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic, strong) id<SettingsDelegate> delegate;

@end
