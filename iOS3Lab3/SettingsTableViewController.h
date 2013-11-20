//
//  SettingsTableViewController.h
//  iOS3Lab3
//
//  Created by James Derry on 11/18/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMaxLettersAccepted 15

@protocol SettingsDelegate <NSObject>

@required
- (void)didChangeSettings:(NSDictionary *)settings;

@end


@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *wordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *rotateSwitch;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIStepper *countStepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *caseSegControl;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;

@property (strong, nonatomic) NSMutableDictionary *settingsDict;

@property(nonatomic, strong) id<SettingsDelegate> delegate;

@end
