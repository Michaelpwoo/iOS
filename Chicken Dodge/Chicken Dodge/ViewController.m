//
//  ViewController.m
//  Chicken Dodge
//
//  Created by Michael Woo on 6/10/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@interface ViewController () <MySceneDelegate>
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // configure the view
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-50, 320, 50)];
    _bannerView.adUnitID = @"ca-app-pub-8959594016990189/1368561352";
    _bannerView.rootViewController = self;
    [self.view addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    SKScene * scene = [[MyScene alloc] initWithSize:skView.bounds.size delegate:self state:GameStateMainMenu];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
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

-(UIImage*) screenshot{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1.0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)shareString:(NSString*)string url:(NSURL*)url image:(UIImage*)image{
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[string, url, image] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];

}

@end
