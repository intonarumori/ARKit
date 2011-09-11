//
//  ARViewController.m
//  ARKitDemo
//
//  Created by Niels W Hansen on 1/23/10.
//  Copyright 2010 Agilite Software. All rights reserved.
//

#import "ARViewController.h"
#import "AugmentedRealityController.h"

@implementation ARViewController

@synthesize agController;
@synthesize dataSource;
@synthesize cameraController;

- (id)init
{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

-(id)initWithDataSource:(id<ARLocationDataSource>)aDataSource
{
	if ((self = [super init])) {
        self.dataSource = aDataSource;
        self.wantsFullScreenLayout = YES;
    }	
	return self;
}


- (void)loadView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [aView setBackgroundColor:[UIColor darkGrayColor]];
    self.view = aView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera.png"]];
    [aView addSubview:imageView];
    
    [imageView release];
    [aView release];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(agController == nil)
    {
        self.agController = [[[AugmentedRealityController alloc] initWithViewController:self] autorelease];
        self.agController.debugMode = NO;
        self.agController.scaleViewsBasedOnDistance = YES;
        self.agController.minimumScaleFactor = 0.5;
        self.agController.rotateViewsBasedOnPerspective = YES;
    }
    
    if(cameraController == nil)
    {
        self.cameraController = [[[UIImagePickerController alloc] init] autorelease];
        self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraController.cameraViewTransform = CGAffineTransformScale(self.cameraController.cameraViewTransform, 1.23f,  1.23f);
        self.cameraController.showsCameraControls = NO;
        self.cameraController.navigationBarHidden = YES;
        self.cameraController.cameraOverlayView = agController.displayView;
        
        self.cameraController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    
	if ([dataSource.locations count] > 0) {
        for (ARCoordinate *coordinate in dataSource.locations) {
            UIView *coordinateView = [dataSource viewForCoordinate:coordinate];
			[agController addCoordinate:coordinate augmentedView:coordinateView animated:NO];
		}
	}
    
    [self presentModalViewController:cameraController animated:NO];
    
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
