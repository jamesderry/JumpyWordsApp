//
//  SettingsTableViewController.m
//  iOS3Lab3
//
//  Created by James Derry on 11/18/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

{
    NSString *word;
}

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.countLabel.text = @"00";
    self.wordTextField.delegate = self;
    
    if (!self.settingsDict) {
        self.settingsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    } else {
        [self restoreSettings];
    }
    
    [self.caseSegControl addTarget:self action:@selector(changedCase:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)restoreSettings
{
    // update display of controls to match current settings
    self.wordTextField.text = [self.settingsDict objectForKey:@"word"];
    self.caseSegControl.selectedSegmentIndex = [[self.settingsDict objectForKey:@"case"] isEqualToString:@"upper"]?0:1;
}

- (IBAction)dismissViewController:(id)sender {
    [self.delegate didChangeSettings:self.settingsDict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// selector for segmented control
- (void)changedCase:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    NSInteger index = [control selectedSegmentIndex];
    if ([[[control titleForSegmentAtIndex:index] lowercaseString] isEqualToString:@"lowercase"]) {
        [self.settingsDict setObject:@"lower" forKey:@"case"];
    } else {
        [self.settingsDict setObject:@"upper" forKey:@"case"];
    }
    NSLog(@"case set to %@", [self.settingsDict objectForKey:@"case"]);
}

#pragma mark UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter a real word!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    } else {
        [self.settingsDict setObject:textField.text forKey:@"word"];
        [textField resignFirstResponder];
        return YES;
    }
}


@end
