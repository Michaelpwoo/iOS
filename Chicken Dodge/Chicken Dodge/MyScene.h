//
//  MyScene.h
//  Chicken Dodge
//

//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GADBannerView.h"

typedef NS_ENUM(int, GameState) {
    GameStateMainMenu,
    GameStatePlay,
    GameStateShowingScore,
    GameStateGameOver
};

@protocol MySceneDelegate
-(UIImage*) screenshot;
-(void)shareString:(NSString*)string url:(NSURL*)url image:(UIImage*)image;
@end

@interface MyScene : SKScene

@property (strong, nonatomic) id <MySceneDelegate> delegate;
-(id)initWithSize:(CGSize)size delegate:(id<MySceneDelegate>)delegate state:(GameState)state;


@end
