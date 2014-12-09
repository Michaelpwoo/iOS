//
//  GameScore.h
//  Chicken Dodge
//
//  Created by Michael Woo on 6/19/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameScore : NSObject

@property (nonatomic) int highScore;
@property (nonatomic) int score;

+ (instancetype)shared;
- (void)saveGame;
- (void) scoreReset;

@end
