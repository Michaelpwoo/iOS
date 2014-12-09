//
//  ViewController.m
//  swipe
//
//  Created by Michael Woo on 8/4/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    _bannerView.adUnitID = @"ca-app-pub-8959594016990189/5049406551";
    _bannerView.rootViewController = self;
    [self.view addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]]; 

    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
