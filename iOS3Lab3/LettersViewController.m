//
//  LettersViewController.m
//  iOS3Lab3
//
//  Created by James Derry on 11/18/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import "LettersViewController.h"

#define kMaxLettersAccepted 15

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
    
    //manually set the currentWord until we get the settings hooked up
    currentWord = [NSMutableString stringWithString:@"Christmas"];
    
    //set default settings
    self.settingsDict = [NSMutableDictionary dictionaryWithObject:@"lower" forKey:@"case"];
    [self sendWords];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendWords
{
    //remove existing letters from view before proceeding
    for (int x=1; x < (kMaxLettersAccepted+1); x++) {
        [[[self view] viewWithTag:x] removeFromSuperview];
    }
    
    NSString *word = [currentWord isEqualToString:@""]?@"welcome":[NSString stringWithString:currentWord];
    CGRect frame;
    UIImageView *thisView;
    
    
    for (int i=0; i < [word length]; i++) {
        int xpoint = arc4random() % 300;
        
        frame = CGRectMake(xpoint, 0.0, 67.0, 67.0);
        thisView = [[UIImageView alloc] init];
        thisView.frame = frame;
        thisView.tag = i+1;
        
        if ([[self.settingsDict valueForKey:@"case"] isEqualToString:@"lower"])
        {
            NSString *imageName = [NSString stringWithFormat:@"tile1_%@_lower_268.png", [[word substringWithRange:NSMakeRange(i, 1)] uppercaseString]];
            NSLog(@"imageName = %@", imageName);
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
    UIBezierPath *itemPath;
    
    CGFloat verticalOffset = 80.0;  // vertical position of topmost letter tile in word
    CGFloat finalxposition = 160.0; // horizontal position of all tiles in word
    CGFloat finalyposition =(i*67.0) + verticalOffset + 67.0/2;
    
    CGPoint currentPosition = view.layer.position;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, currentPosition.x, currentPosition.y);
    
    //create arc path
    CGPathAddCurveToPoint(curvedPath, NULL, arc4random() % 320, arc4random() % 568,
                          arc4random() % 320, arc4random() % 568,
                          arc4random() % 320, arc4random() % 568);
    //create arc path
    CGPathAddCurveToPoint(curvedPath, NULL, arc4random() % 320, arc4random() % 568,
                          arc4random() % 320, arc4random() % 568,
                          finalxposition, finalyposition);
    
    //create bezier curve
    itemPath = [UIBezierPath bezierPathWithCGPath:curvedPath];
    
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = 3.0f;
    pathAnimation.path = itemPath.CGPath;
    pathAnimation.fillMode = kCAFillModeForwards;
    
    //create animation transaction to disable auto animations long enough to set final x and y position
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    view.layer.position = CGPointMake(finalxposition, finalyposition);
    [[view layer] addAnimation:pathAnimation forKey:@"position"];
    [CATransaction commit];
    
    //Core Graphics functions not handled by ARC.  Must manually release memory.
    CGPathRelease(curvedPath);
    return view;
}

#pragma mark SettingsDelegate methods

- (void)didChangeSettings:(NSDictionary *)settings
{
    self.settingsDict = [NSMutableDictionary dictionaryWithDictionary:settings];
}

@end
