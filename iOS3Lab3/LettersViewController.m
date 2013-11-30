//
//  LettersViewController.m
//  iOS3Lab3
//
//  Created by James Derry on 11/18/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import "LettersViewController.h"

@interface LettersViewController ()
{
    NSMutableString *currentWord;
}

@property(nonatomic, strong) NSMutableDictionary *settingsDict;

@end

@implementation LettersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendWords)];
    [[self view] addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    // set a default to currentWord upon first run
    if (!currentWord) {
        currentWord = [NSMutableString stringWithString:@"hello"];
    }
    // set default settings upon first run
    if (!self.settingsDict) {
        self.settingsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"lower", @"case",
                             currentWord, @"word",
                             [NSNumber numberWithBool:NO], @"rotate",
                             [NSNumber numberWithInt:2], @"speed",
                             nil];
    }
    [self sendWords];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendWords
{
    [self removeAllLetterTiles]; // clear the old tiles away
    
    //if no default word exists, use 'welcome'
    NSString *word = [currentWord isEqualToString:@""]?@"welcome":[NSString stringWithString:currentWord];
    CGRect frame;
    UIImageView *thisView;
    
    // iterate through every letter in the word
    for (int i=0; i < [word length]; i++) {
        int xpoint = arc4random() % 300; // random number between 0 and 300 sets initial x position
        
        frame = CGRectMake(xpoint, 0.0, 67.0, 67.0); // each tile set to 67x67 pixels
        thisView = [[UIImageView alloc] init];
        thisView.frame = frame;
        thisView.tag = i+1; //add a tag number to the view so we can remove view later
        
        if ([[self.settingsDict valueForKey:@"case"] isEqualToString:@"lower"])
        {
            NSString *imageName = [NSString stringWithFormat:@"tile1_%@_lower_268.png", [[word substringWithRange:NSMakeRange(i, 1)] uppercaseString]];
            //NSLog(@"imageName = %@", imageName);
            thisView.image = [UIImage imageNamed:imageName];
            
            /*
            [UIView animateWithDuration:2.0 animations:^{
                thisView.center = CGPointMake(140.0, (i * 67.0) + 80 + 67.0/2 );
            }];
            */
            
        } else {
            NSString *imageName = [NSString stringWithFormat:@"tile1_%@_268.png", [[word substringWithRange:NSMakeRange(i, 1)] uppercaseString]];
            thisView.image = [UIImage imageNamed:imageName];
        }
        [self.view addSubview:[self makeBezierPathForView:thisView index:i]];
    }
}

- (UIView *)makeBezierPathForView:(UIView *)view index:(int)i
{
    UIBezierPath *itemPath; // declare variable
    
    CGFloat verticalOffset = 80.0;  // vertical position of top-most letter tile in word
    CGFloat finalxposition = 160.0; // horizontal position of all tiles in word
    CGFloat finalyposition =(i*67.0) + verticalOffset + 67.0/2; // must add 67/2 to account for center of letter tile
    
    CGPoint currentPosition = view.layer.position;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, currentPosition.x, currentPosition.y);
    int sh = [[UIScreen mainScreen] bounds].size.height; //screen height

    //create arc path
    CGPathAddCurveToPoint(curvedPath, NULL, arc4random() % 320, arc4random() % sh,
                          arc4random() % 320, arc4random() % sh,
                          arc4random() % 320, arc4random() % sh); // 320 and 568 refer to 4" iphone screen width and height
    //create arc path
    CGPathAddCurveToPoint(curvedPath, NULL, arc4random() % 320, arc4random() % sh,
                          arc4random() % 320, arc4random() % sh,
                          finalxposition, finalyposition);
    
    //create bezier curve
    itemPath = [UIBezierPath bezierPathWithCGPath:curvedPath];
    
    //Animate letter position using Core Animation class CAKeyframAnimation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = 3.0f;
    pathAnimation.path = itemPath.CGPath;
    pathAnimation.fillMode = kCAFillModeForwards;
    
    //create animation transaction to disable auto animations long enough to set final x and y position
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    view.layer.position = CGPointMake(finalxposition, finalyposition);
    [[view layer] addAnimation:pathAnimation forKey:@"position"];// attach animation to view
    [CATransaction commit];
    
    //Core Graphics functions not handled by ARC.  Must manually release memory.
    CGPathRelease(curvedPath);
    return view;
}

- (void)removeAllLetterTiles
{
    //remove existing letters from view
    for (int x=1; x < (kMaxLettersAccepted+1); x++) {
        [[[self view] viewWithTag:x] removeFromSuperview];
    }
}

#pragma mark Segue preparation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self removeAllLetterTiles]; // clear the letters away (cease animations)
    
    // set the delegate of the incoming settings controller to this controller
    SettingsTableViewController *vc = (SettingsTableViewController *)segue.destinationViewController;
    vc.delegate = self;
    NSLog(@"settingsDict = %@", self.settingsDict);
    
    vc.settingsDict = self.settingsDict;
}

#pragma mark SettingsDelegate methods

- (void)didChangeSettings:(NSDictionary *)settings
{
    self.settingsDict = [NSMutableDictionary dictionaryWithDictionary:settings];
    currentWord = [self.settingsDict objectForKey:@"word"];
}

@end
