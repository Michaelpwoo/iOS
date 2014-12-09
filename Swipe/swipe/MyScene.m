//
//  MyScene.m
//  swipe
//
//  Created by Michael Woo on 8/4/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "MyScene.h"




//Nodes
SKNode *_worldNode;
SKNode *_HUBDisplay;
SKNode *_mainMenuNode;
SKLabelNode *_score;
SKLabelNode *_highScore;


//Timer
Timer *countDown;


//Constant
static NSString *const kFont = @"AppleSDGothicNeo-Thin";
static int const APP_ID = 916611554;

//GameState
typedef NS_ENUM(int, GameState){
    GameStateMenu,
    GameStatePlay,
    GameStateOver,
    
};
GameState gameState;

typedef NS_ENUM(int, GamePlayMode) {
    GamePlayModeDot,
    GamePlayModeArrow,
    GamePlayModeRandom,
};
GamePlayMode gamePlay;

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        //Set background to white
        self.backgroundColor = [SKColor whiteColor];
        
        
        //Create a node that will holds the gameplay
        _worldNode = [SKNode node];
        [self addChild:_worldNode];
        
   
        //Initialize HUBDisplay
        _HUBDisplay = [SKNode node];
        [_worldNode addChild:_HUBDisplay];
        
        _mainMenuNode = [SKNode node];
        [_worldNode addChild:_mainMenuNode];
        
        //Reset Data
        [[Score sharedGameData] reset];
        
        //Load main menu
        gameState = GameStateMenu;
        [self mainMenu];
    }
    
    return self;
}

#pragma mark - Setup

//Create a new dot
-(void)createDot{
    
    Dot *dot = [[Dot alloc]init];
    [dot spawnDot];
    dot.position = CGPointMake(self.size.width/2, self.size.height/2);
    [_worldNode addChild:dot];
}

//Create a new arrow
-(void)createArrow{
    
    Dot *dot = [[Dot alloc]init];
    [dot spawnArrow];
    dot.position = CGPointMake(self.size.width/2, self.size.height/2);
    [_worldNode addChild:dot];
    
}

//Create a new dot or arrow
-(void)createRandom{
    Dot *dot = [[Dot alloc]init];
    [dot spawnRandom];
    dot.position = CGPointMake(self.size.width/2, self.size.height/2);
    [_worldNode addChild:dot];
}

//Create the mian menu
-(void)mainMenu{
    
    for (int i = 0; i < 5; i++) {
        int random = arc4random()%2;
        NSString *sprite;
        if (random == 0) {
            sprite = @"green";
        } else {
            sprite = @"red";
        }
        
        
        SKSpriteNode *circle = [SKSpriteNode spriteNodeWithImageNamed:sprite];
        CGFloat randomLocX = RandomFloatRange(0, self.size.width);
        CGFloat randomLocY = RandomFloatRange(0, self.size.height);
        circle.position =  CGPointMake(randomLocX, randomLocY);
        [_mainMenuNode addChild:circle];
   
    }
    //Set title
    SKLabelNode *title01 = [SKLabelNode labelNodeWithFontNamed:kFont];
    title01.fontColor = [SKColor blackColor];
    title01.fontSize = 50;
    title01.text = @"One Swipe";
    title01.fontColor = [SKColor blackColor];
    title01.position = CGPointMake(self.size.width*.5, self.size.height*.77);
    [_mainMenuNode addChild:title01];
    
    
   
    //Set dot game label
    SKLabelNode *one = [SKLabelNode labelNodeWithFontNamed:kFont];
    one.fontColor = [SKColor blackColor];
    one.fontSize = 20;
    one.name = @"dot";
    one.text = @"One Dot";
    one.position = CGPointMake(self.size.width/2, self.size.height*.65);
    [_mainMenuNode addChild:one];
    
    //Set arrow game label
    SKLabelNode *arrow = [SKLabelNode labelNodeWithFontNamed:kFont];
    arrow.fontColor = [SKColor blackColor];
    arrow.fontSize = 20;
    arrow.name = @"arrow";
    arrow.text = @"One Arrow";
    arrow.position = CGPointMake(self.size.width/2, self.size.height*.50);
    [_mainMenuNode addChild:arrow];

    //Set random game label
    SKLabelNode *random = [SKLabelNode labelNodeWithFontNamed:kFont];
    random.fontColor = [SKColor blackColor];
    random.fontSize = 20;
    random.name = @"random";
    random.text = @"One Random";
    random.position = CGPointMake(self.size.width/2, self.size.height*.35);
    [_mainMenuNode addChild:random];
    
    //Display highscores
    SKLabelNode *highscoreLabel = [SKLabelNode labelNodeWithFontNamed:kFont];
    highscoreLabel.fontColor = [SKColor blackColor];
    highscoreLabel.fontSize = 20;
    highscoreLabel.name = @"highscorelabel";
    highscoreLabel.text = @"Display Scores";
    highscoreLabel.position = CGPointMake(self.size.width/2, self.size.height*.20);
    [_mainMenuNode addChild:highscoreLabel];
    
    //rate label
    SKLabelNode *rate = [SKLabelNode labelNodeWithFontNamed:kFont];
    rate.fontColor = [SKColor blackColor];
    rate.fontSize = 20;
    rate.name = @"rate";
    rate.text = @"Rate";
    rate.position = CGPointMake(self.size.width/2, self.size.height*.05);
    [_mainMenuNode addChild:rate];
    

    

    
}

//Create HUBDisplay
-(void)setupHUB{
    _score = [SKLabelNode labelNodeWithFontNamed:kFont];
    _score.fontColor = [SKColor blackColor];
    _score.fontSize = 30;
    _score.text = @"Score: 0";
    _score.position = CGPointMake(self.size.width/2, self.size.height*.2);
    [_HUBDisplay addChild:_score];
    
    //Create Timer
    countDown = [[Timer alloc]initWithFontNamed:kFont andTime:6];
    countDown.position = CGPointMake(self.size.width/2-self.size.width*.10, self.size.height*.8);
    [_HUBDisplay addChild:countDown];
}

-(void)displayHighScores{
    
    [_mainMenuNode removeAllChildren];
    
    SKLabelNode* disHighscore = [SKLabelNode labelNodeWithFontNamed:kFont];
    disHighscore.fontSize = 40;
    disHighscore.fontColor = [SKColor blackColor];
    disHighscore.text = @"High Scores";
    disHighscore.position = CGPointMake(self.size.width/2, self.size.height*.75);
    [_worldNode addChild:disHighscore];
    
    SKLabelNode *oneDot = [SKLabelNode labelNodeWithFontNamed:kFont];
    oneDot.fontColor = [SKColor blackColor];
    oneDot.fontSize = 20;
    oneDot.position = CGPointMake(self.size.width/2, self.size.height*.60);
    oneDot.text = [NSString stringWithFormat:@"One Dot: %d",(int)[Score sharedGameData].highScore];
    [_worldNode addChild:oneDot];
    
    SKLabelNode *oneArrow = [SKLabelNode labelNodeWithFontNamed:kFont];
    oneArrow.fontColor = [SKColor blackColor];
    oneArrow.fontSize = 20;
    oneArrow.text = [NSString stringWithFormat:@"One Arrow: %d",(int)[Score sharedGameData].highScoreArrow];
    oneArrow.position = CGPointMake(self.size.width/2, self.size.height*.45);
    [_worldNode addChild:oneArrow];
    
    SKLabelNode *oneRandom = [SKLabelNode labelNodeWithFontNamed:kFont];
    oneRandom.fontColor = [SKColor blackColor];
    oneRandom.fontSize = 20;
    oneRandom.text = [NSString stringWithFormat:@"One Random: %d",(int)[Score sharedGameData].highScoreRandom];
    oneRandom.position = CGPointMake(self.size.width/2, self.size.height*.30);
    [_worldNode addChild:oneRandom];
    
    SKLabelNode *mainmenu = [SKLabelNode labelNodeWithFontNamed:kFont];
    mainmenu.fontColor = [SKColor blackColor];
    mainmenu.fontSize = 20;
    mainmenu.text = @"Return to main menu";
    mainmenu.name = @"mainmenu";
    mainmenu.position = CGPointMake(self.size.width/2, self.size.height*.15);
    [_worldNode addChild:mainmenu];
    

    
}


//Initialize the UIGesture
- (void)didMoveToView:(SKView *)view
{
    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:recognizerDown];
    
    UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[self view] addGestureRecognizer:recognizerUp];
    
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[self view] addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[self view] addGestureRecognizer:recognizerRight];
}

#pragma mark - game play

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Detects Node that was touched
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKLabelNode *touchNode = (SKLabelNode*)[self nodeAtPoint:touchLocation];
    //Touch based on gamestate
    switch (gameState) {
        case GameStateMenu:
            if ([touchNode.name isEqualToString:@"dot"]) {
                gamePlay = GamePlayModeDot;
                [self switchGamePlay];
            } else if ([touchNode.name isEqualToString:@"arrow"]){
                gamePlay = GamePlayModeArrow;
                [self switchGamePlay];
            } else if ([touchNode.name isEqualToString:@"random"]){
                gamePlay = GamePlayModeRandom;
                [self switchGamePlay];
            } else if ([touchNode.name isEqualToString:@"highscorelabel"]){
                [self displayHighScores];
            } else if ([touchNode.name isEqualToString:@"mainmenu"]){
                [self restartGame];
            } else if ([touchNode.name isEqualToString:@"rate"]){
                [self rateApp];
            }
            break;
        case GameStatePlay:
            break;
        case GameStateOver:
                [self restartGame];

            break;
    }
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    switch (gameState) {
        case GameStateMenu:
            //[self mainMenu];
            break;
        case GameStatePlay:
            if ([countDown isOutOfTime]) {
                [self switchGameOverScreen];
            } else {
                [countDown update:currentTime];
            }
            break;
        case GameStateOver:
            
            break;

    }
}


//Determine the swipe direction and handles it
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    //Only listen to swipe in gamestateplay
    if (gameState ==GameStatePlay) {
        
        CGPoint touchLocation = [sender locationInView:sender.view];
        touchLocation = [self convertPointFromView:touchLocation];
        Dot *touchedNode = (Dot*)[self nodeAtPoint:touchLocation];

        CGFloat moveY = 0.00;
        CGFloat moveX = 0.00;
        BOOL isCorrect = FALSE;
        
        //Get size of sprite
        Dot* dot = (Dot*)[_worldNode childNodeWithName:@"dot"];
        CGFloat extraMove = dot.size.width/2;
        //Determine the movement of the swipe
        if([touchedNode.name isEqualToString:@"directionUp"] && sender.direction == UISwipeGestureRecognizerDirectionUp){
            moveY = self.size.height/2 + extraMove;
            isCorrect = TRUE;
            
        }
        else if([touchedNode.name isEqualToString:@"directionDown"] && sender.direction == UISwipeGestureRecognizerDirectionDown){
            moveY = -self.size.height/2 - extraMove;
            isCorrect = TRUE;

        }
        else if ([touchedNode.name isEqualToString:@"directionLeft"] && sender.direction == UISwipeGestureRecognizerDirectionLeft){
            moveX = -self.size.width/2 - extraMove;
            isCorrect = TRUE;
            
        }
        else if ([touchedNode.name isEqualToString:@"directionRight"] && sender.direction == UISwipeGestureRecognizerDirectionRight){
            moveX = self.size.width/2 - extraMove;
            isCorrect = TRUE;
            
        }
        //Check if the correct swipe was applied and game play mode
        if (isCorrect) {
            //Update score
            [Score sharedGameData].currentScore += 1;
            _score.text = [NSString stringWithFormat:@"Score: %d", [Score sharedGameData].currentScore];
            SKAction *moveDot = [self moveDotAction:moveX y:moveY];
            //Run Action
            [_worldNode enumerateChildNodesWithName:@"dot" usingBlock:^(SKNode *node, BOOL *stop) {
                SKSpriteNode *game = (SKSpriteNode*) node;
                [game runAction:moveDot];
            }];

            //Check gameplaymode and create new dot
            switch (gamePlay) {
                case GamePlayModeDot:
                    [self createDot];
                    break;
                case GamePlayModeArrow:
                    [self createArrow];
                    break;
                case GamePlayModeRandom:
                    [self createRandom];
                    break;
            }

            //Add time
            if ([Score sharedGameData].currentScore < 5) {
                [countDown addTime:2.0];
            } else if([Score sharedGameData].currentScore > 5 && [Score sharedGameData].currentScore < 10){
                [countDown addTime:1.5];
            } else if([Score sharedGameData].currentScore > 10 && [Score sharedGameData].currentScore < 15){
                [countDown addTime:1.0];
            } else if([Score sharedGameData].currentScore > 15 && [Score sharedGameData].currentScore < 20){
                [countDown addTime:0.5];
            }
        } else {
            [self switchGameOverScreen];
            
        

            
        }
    }
}

-(void)restartGame{
  
    [_worldNode removeFromParent];
   // [_HUBDisplay removeFromParent];
    SKScene *newScene = [[MyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:1];
    [self.view presentScene:newScene transition:transition];
}

//Called when Game is over
#pragma marl - Switch game state
-(void)switchGameOverScreen{
    
    gameState = GameStateOver;
    //Remove node
    [_worldNode enumerateChildNodesWithName:@"dot" usingBlock:^(SKNode *node, BOOL *stop) {
        Dot *dot =(Dot*)node;
        
        SKAction *fade = [SKAction fadeAlphaTo:0 duration:.3];
        SKAction *scale = [SKAction scaleBy:.5 duration:.3];
        SKAction *group = [SKAction group:@[fade,scale]];
        SKAction* sequence = [SKAction sequence:@[group,[SKAction removeFromParent]]];
        [dot runAction:sequence];
        
    }];
    //Stop timer
    countDown.text = [NSString stringWithFormat:@"%.2f",[countDown getTimeLeft]];
    
    //Save Score
    [[Score sharedGameData] save];
    
    
    //Create label informing they lost
    SKLabelNode *lost = [SKLabelNode labelNodeWithFontNamed:kFont];
    lost.text = @"You Lost!";
    lost.name = @"lost";
    lost.alpha = 0.0;
    lost.fontColor = [SKColor blackColor];
    lost.fontSize = 30;
    lost.position = CGPointMake(self.size.width/2, self.size.height/2);
    [_HUBDisplay addChild:lost];
    [lost runAction:[self appear]];
    
    //Try again
    SKLabelNode *lostSecond = [SKLabelNode labelNodeWithFontNamed:kFont];
    lostSecond.text = @"Tap to Restart";
    lostSecond.alpha = 0.0;
    lostSecond.fontColor = [SKColor blackColor];
    lostSecond.fontSize = 30;
    lostSecond.position = CGPointMake(self.size.width/2, self.size.height/2 *.88);
    [_HUBDisplay addChild:lostSecond];
    [lostSecond runAction:[self appear]];
    
    int currentHighScore;
    //Save max score
    switch (gamePlay) {
        case GamePlayModeDot:
            [Score sharedGameData].highScore = MAX([Score sharedGameData].currentScore, [Score sharedGameData].highScore);
            currentHighScore = [Score sharedGameData].highScore;
            break;
        case GamePlayModeArrow:
            [Score sharedGameData].highScoreArrow= MAX([Score sharedGameData].currentScore, [Score sharedGameData].highScoreArrow);
            currentHighScore = [Score sharedGameData].highScoreArrow;
            break;
        case GamePlayModeRandom:
            [Score sharedGameData].highScoreRandom = MAX([Score sharedGameData].currentScore, [Score sharedGameData].highScoreRandom);
            currentHighScore = [Score sharedGameData].highScoreRandom;
            break;

    }

    
    //Display hight score
    SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:kFont];
    highScore.fontSize = 30;
    highScore.alpha = 0;
    highScore.text = [NSString stringWithFormat:@"High Score: %d", currentHighScore];
    highScore.fontColor = [SKColor blackColor];
    highScore.position = CGPointMake(self.size.width/2, self.size.height*.3);
    [_HUBDisplay addChild:highScore];
    [highScore runAction:[self appear]];
    
}

//Create game base on gameplay
-(void)switchGamePlay{
    gameState = GameStatePlay;
    
    //Remove main menu
    [_mainMenuNode removeFromParent];
    //Type of gameplaymode
    switch (gamePlay) {
        case GamePlayModeDot:
            [self setupHUB];
            [self createDot];
            break;
        case GamePlayModeArrow:
            [self setupHUB];
            [self createArrow];
            break;
        case GamePlayModeRandom:
            [self setupHUB];
            [self createRandom];
            break;

    }

}

#pragma mark - Action
//Move the dot in the correct swipe direction
-(SKAction*) moveDotAction:(CGFloat)moveX y:(CGFloat)moveY{

        //Move the dot and fade it
        SKAction *group = [SKAction group:@[[SKAction moveByX:moveX y:moveY duration:.7],[SKAction fadeAlphaTo:0 duration:.7]]];
        //Set up and return action
        SKAction *sequence = [SKAction sequence:@[group,[SKAction removeFromParent]]];
        return  sequence;
}

//Create the sequence for lost label
-(SKAction*)appear{
    
    SKAction* visible = [SKAction fadeAlphaTo:1 duration:.5];
    SKAction* small = [SKAction scaleTo:.5 duration:0];
    SKAction* normal = [SKAction scaleTo:1 duration:.5];
    SKAction* group = [SKAction group:@[visible,normal]];
    SKAction* sequence = [SKAction sequence:@[small,group]];
    return sequence;
}

#pragma mark - Special


- (void)rateApp {
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8", APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

#pragma mark - Helper
//Helper method
CGFloat RandomFloatRange(CGFloat min, CGFloat max) {
    return ((CGFloat)arc4random() / 0xFFFFFFFFu) * (max - min) + min;
}

@end
