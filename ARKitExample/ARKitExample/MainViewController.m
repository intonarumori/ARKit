//
//  MainViewController.m
//  ARKitExample
//
//  Created by Daniel Langh on 9/11/11.
//  Copyright (c) 2011 rumori. All rights reserved.
//

#import "MainViewController.h"

#import "MapViewController.h"
#import "ARViewController.h"


@implementation MainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    MapViewController *viewcontroller = [[MapViewController alloc] init];
    [self setViewControllers:[NSArray arrayWithObject:viewcontroller]];
    [viewcontroller release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCamera) name:@"gotoCamera" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMap) name:@"gotoMap" object:nil];
}

- (void)gotoMap
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)gotoCamera
{
    // hide the status bar, old and new style
    
    UIApplication *app = [UIApplication sharedApplication];
    if([app respondsToSelector:@selector(setStatusBarHidden:withAnimation:)])
    {
        [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    else if([app respondsToSelector:@selector(setStatusBarHidden:animated:)])
    {
        // cast to simple object to prevent compilation warning
        [(id)app setStatusBarHidden:YES animated:YES];
    }
    
     ARViewController *arController = [[ARViewController alloc] init];
    [arController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
     [self presentModalViewController:arController animated:YES];
     [arController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    // show status bar
     UIApplication *app = [UIApplication sharedApplication];
    
    if([app isStatusBarHidden])
    {
        if([app respondsToSelector:@selector(setStatusBarHidden:withAnimation:)])
        {
            [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }
        else if([app respondsToSelector:@selector(setStatusBarHidden:animated:)])
        {
            // cast to simple object to prevent compilation warning
            [(id)app setStatusBarHidden:NO animated:YES];
        }

        [UIView beginAnimations:@"resize" context:nil];
        [UIView setAnimationDuration:0.33];
        [[self view] setFrame:CGRectMake(0, 20, 320, 460)];
        [UIView commitAnimations];
    }
    
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
