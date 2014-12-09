//
//  MyScene.m
//  Chicken Dodge
//
//  Created by Michael Woo on 6/10/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "MyScene.h"
#import "PlayerNode.h"
#import "GroundNode.h"
#import "GameScore.h"


typedef NS_ENUM(int, Layer){
    LayerBackground,
    LayerObstacle,
    LayerForeground,
    LayerPlayer,
    LayerUI
    
};
//collision detection bitmask
typedef NS_ENUM(int, CollisionCategory){
    CollisionCategoryPlayer = 1 << 0,
    CollisionCategoryObstacle = 1 << 1
};

// nodes
SKNode *_worldNode;
SKNode *_mainMenuNode;

// obstacle values
static const float kGap =1.35;
static const float kSpeed = 2.0;


// obstacle spawn
static const float kInitialSpawn = 1;
static const float kOtherSpawn = 1.5;

//font
static NSString *const kFont = @"Hurry Up";

//link to the app store
static const int APP_ID = 893474802;

// collision detection
BOOL _hitObstacle;

GameState _gameState;

//player
PlayerNode *_player;

GADBannerView *_banner;

// score label
SKLabelNode *_scoreLabel;

// sounds
SKAction *_gameOverSound;
SKAction *_scoreSound;



@interface MyScene()<UIAccelerometerDelegate, SKPhysicsContactDelegate> {
    
}
@end

@implementation MyScene


-(id)initWithSize:(CGSize)size delegate:(id<MySceneDelegate>)delegate state:(GameState)state{
    
    if (self = [super initWithSize:size]) {
        self.delegate = delegate;
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        _worldNode = [SKNode node];
        [self addChild:_worldNode];
        _mainMenuNode = [SKNode node];
        [self addChild:_mainMenuNode];
    
        
        self.backgroundColor = [SKColor colorWithRed:90.0/255 green:200.0/255 blue:239.0/255 alpha:1.0];
        
        [self switchToMainMenu];
        
        
    }
    return self;
}

#pragma mark - Setup
-(void)setupScore {
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFont];
    _scoreLabel.text = @"0";
    _scoreLabel.position = CGPointMake(self.size.width/2, 60);
    _scoreLabel.zPosition = LayerUI;
    _scoreLabel.fontColor = [UIColor blackColor];
    [_worldNode addChild:_scoreLabel];
}

-(void) setupScoreCard{
    
    [[GameScore shared] saveGame];
    
    float outView = 0;
    
    SKSpriteNode *scoreCard = [SKSpriteNode spriteNodeWithImageNamed:@"score"];
    scoreCard.position = CGPointMake(self.size.width/2, self.size.height/2 - outView);
    scoreCard.zPosition = LayerUI;
    scoreCard.alpha = 0;
    [_worldNode addChild:scoreCard];
    

    SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:kFont];
    highScore.text = [NSString stringWithFormat:@"%d",[GameScore shared].highScore];
    highScore.fontColor = [UIColor blackColor];
    highScore.position = CGPointMake(scoreCard.size.width*.22, -scoreCard.size.height*.05 - outView);
    [scoreCard addChild:highScore];
    
    SKLabelNode *currentScore = [SKLabelNode labelNodeWithFontNamed:kFont];
    currentScore.text = [NSString stringWithFormat:@"%d", [GameScore shared].score];
    currentScore.fontColor = [UIColor blackColor];
    currentScore.position = CGPointMake(-scoreCard.size.width*.22,-scoreCard.size.height*.05 -outView);
    [scoreCard addChild:currentScore];
    
    SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:kFont];
    highScoreLabel.text = @"High Score";
    highScoreLabel.fontSize = 22;
    highScoreLabel.fontColor = [UIColor blackColor];
    highScoreLabel.position = CGPointMake(scoreCard.size.width*.22, scoreCard.size.height*.15 - outView);
    [scoreCard addChild:highScoreLabel];
    
    SKLabelNode * currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:kFont];
    currentScoreLabel.text = @"Score";
    currentScoreLabel.fontSize = 22;
    currentScoreLabel.fontColor = [UIColor blackColor];
    currentScoreLabel.position = CGPointMake(-scoreCard.size.width*.22, scoreCard.size.height*.15 - outView);
    [scoreCard addChild:currentScoreLabel];
    
    SKLabelNode *playLabel = [SKLabelNode labelNodeWithFontNamed:kFont];
    playLabel.text = @"Ok";
    playLabel.name = @"ok";
    playLabel.fontColor = [UIColor blackColor];
    playLabel.position = CGPointMake(-scoreCard.size.width*.22,-scoreCard.size.height*.35-outView);
    [scoreCard addChild:playLabel];
    
    SKLabelNode *shareLabel = [SKLabelNode labelNodeWithFontNamed:kFont];
    shareLabel.text = @"Share";
    shareLabel.name = @"share";
    shareLabel.fontColor = [UIColor blackColor];
    shareLabel.position = CGPointMake(scoreCard.size.width*.22, -scoreCard.size.height*.35-outView);
    [scoreCard  addChild:shareLabel];

    SKAction *group = [SKAction fadeInWithDuration:.5];

    [scoreCard runAction:group];
    [self switchToGameOver];
}

//Load sound when scene is loaded
-(void)setupSounds{
    
    _gameOverSound = [SKAction playSoundFileNamed:@"GameOverSound.wav" waitForCompletion:NO];
    _scoreSound = [SKAction playSoundFileNamed:@"ScoreSound.wav" waitForCompletion:NO];
}

//Display main menu option
-(void)setupMainMenu {
    SKSpriteNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"Title"];
    title.zPosition = LayerUI;
    title.position = CGPointMake(self.size.width/2, self.size.height*.6);
    [_mainMenuNode addChild:title];
    
    SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:@"PlayAndRate"];
    button.position = CGPointMake(self.size.width/2, self.size.height*.18);
    button.zPosition = LayerUI;
    [_mainMenuNode addChild:button];
    
    SKLabelNode *name = [SKLabelNode labelNodeWithFontNamed:kFont];
    name.position = CGPointMake(0, 0);
    name.fontSize = 50;
    name.text = @"Falling";
    name.fontColor = [UIColor blackColor];
    [title addChild:name];
    
    SKLabelNode *name2 = [SKLabelNode labelNodeWithFontNamed:kFont];
    name2.position = CGPointMake(0,-title.size.height*.30);
    name2.fontSize = 50;
    name2.text = @"Chicken";
    name2.fontColor = [UIColor blackColor];
    [name addChild:name2];
    
    SKLabelNode *play = [SKLabelNode labelNodeWithFontNamed:kFont];
    play.name = @"play";
    play.text = @"Play";
    play.position = CGPointMake(-button.size.width*.25, -button.size.height/5);
    [button addChild:play];
    
    SKLabelNode *rate = [SKLabelNode labelNodeWithFontNamed:kFont];
    rate.name = @"rate";
    rate.text = @"Rate";
    rate.position = CGPointMake(button.size.width*.24, -button.size.height/5);
    [button addChild:rate];
    
    SKAction *sequence = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction scaleTo:.95 duration:.5],[SKAction scaleTo:1.05 duration:.5]]]];
    [title runAction:sequence withKey:@"scale"];
    
}

-(void) removeMainMenu{
    [_mainMenuNode removeAllActions];
    [_mainMenuNode removeAllChildren];
}

-(void)setupPlayer{
    
    _player = [[PlayerNode alloc] initWithPosition:CGPointMake(self.size.width/2, self.size.height*.9)];
    [_worldNode addChild:_player];
    _player.zPosition = LayerPlayer;
}
#pragma mark  - Switch Game State
//Switch game state according
-(void) switchToShowScore{
    _gameState = GameStateShowingScore;
    [_player removeAllActions];
    [self stopMovingObstacle];
    [self stopMovingCloud];
    [self setupScoreCard];
}

- (void)switchToNewGame {
    
    [[GameScore shared] scoreReset];
    SKScene *newScene = [[MyScene alloc] initWithSize:self.size delegate:self.delegate state:GameStateMainMenu];
    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.5];
    [self.view presentScene:newScene transition:transition];
}

- (void)switchToGameOver{
    _gameState = GameStateGameOver;
}

-(void) switchToMainMenu{
    _gameState = GameStateMainMenu;
    [self setupMainMenu];
    [self setupSounds];
    [self spawnCloud];
    [self moveCloud];
    [self setupPlayer];
}

-(void) switchToGamePlay{
    _gameState = GameStatePlay;
    [self setupScore];
    [self moveObstacle];
}
#pragma mark - Gameplay
//Spawn clouds during gameplay
-(void) spawnCloud{

    NSString *spriteName;
    double time;
    int rand = arc4random() % 3;
    if (rand == 0) {
        spriteName = @"CloudSmall";
        time = 10.0;
    }
    else if(rand == 1){
        spriteName = @"CloudMedium";
        time = 7.0;
        
    }
    else {
        spriteName = @"CloudBig";
        time = 5.0;
    }
    SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithImageNamed:spriteName];
    sprite.name = @"Cloud";
    sprite.zPosition = LayerBackground;
    [_worldNode addChild:sprite];
    sprite.position = CGPointMake(RandomFloatRange(0, self.size.width), -sprite.size.height/2);
    float moveY = self.size.height + sprite.size.height;
    SKAction *sequence = [SKAction sequence:@[[SKAction moveByX:0 y:moveY duration:time],[SKAction removeFromParent]]];
    [sprite runAction:sequence];
                                

}

-(void) moveCloud{
    SKAction *spawn = [SKAction performSelector:@selector(spawnCloud) onTarget:self];
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *sequenceSpawn = [SKAction sequence:@[spawn,wait]];
    SKAction *forever = [SKAction repeatActionForever:sequenceSpawn];
    [self runAction:forever withKey:@"CloudMove"];
                          
}

-(void) stopMovingCloud{
    [self removeActionForKey:@"CloudMove"];
    [_worldNode enumerateChildNodesWithName:@"Cloud" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeAllActions];
    }];
    
    
}

-(void)startCloud{
    for(int i = 0; i < 6 ; i++){
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"CloudBig"];
        sprite.name = @"Cloud";
        sprite.zPosition = LayerBackground;
        sprite.position = CGPointMake(RandomFloatRange(0 ,self.size.width) , RandomFloatRange(self.size.height/2, self.size.height));
        [_worldNode addChild:sprite];
        
        float moveY = self.size.height + sprite.position.y;
        SKAction *sequence = [SKAction sequence:@[[SKAction moveByX:0 y:moveY duration:3],[SKAction removeFromParent]]];
        [sprite runAction:sequence];
        
    }
    
}


//Spawn the platforms to dodge
-(void) spawnObstacle{
    
    GroundNode *leftSide = [[GroundNode alloc] initWithPosition:CGPointMake(0,0)];
    float min = _player.size.width/2;
    float max = self.size.width - kGap*_player.size.width-min;
    float positionX = RandomFloatRange(min, max);
    NSLog(@"min: %f, max: %f, pos: %f",min,max,positionX);
    [leftSide setPosition:CGPointMake(positionX, -leftSide.size.height)];
    leftSide.name = @"LeftSide";
    leftSide.userData = [NSMutableDictionary dictionary];
    [_worldNode addChild:leftSide];
    
    
    GroundNode *rightSide = [[GroundNode alloc] initWithPosition:CGPointMake(0,0)];
    [rightSide setPosition:CGPointMake(leftSide.position.x+ rightSide.size.width + _player.size.width*kGap ,-rightSide.size.height)];
    rightSide.name = @"RightSide";
    [_worldNode addChild:rightSide];
    
    
    float moveY = self.size.height + 2*rightSide.size.height;
    SKAction *sequence = [SKAction sequence:@[[SKAction moveByX:0 y:moveY duration:kSpeed],[SKAction removeFromParent]]];
    [rightSide runAction:sequence];
    [leftSide runAction:sequence];
    
    
}
//move the platforms vertically
-(void) moveObstacle {
    
    SKAction *initSpawn = [SKAction waitForDuration:kInitialSpawn];
    SKAction *spawn = [SKAction performSelector:@selector(spawnObstacle) onTarget:self];
    SKAction *OtherSpawns = [SKAction waitForDuration:kOtherSpawn];
    SKAction *spawnSequence = [SKAction sequence:@[spawn,OtherSpawns]];
    SKAction *forever = [SKAction repeatActionForever:spawnSequence];
    SKAction *overallSequence = [SKAction sequence:@[initSpawn,forever]];
    [self runAction:overallSequence withKey:@"move"];
}
//called when the player hit the platform
- (void) stopMovingObstacle{
    [self removeActionForKey:@"move"];
    [_worldNode enumerateChildNodesWithName:@"LeftSide" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeAllActions];
    }];
    [_worldNode enumerateChildNodesWithName:@"RightSide" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeAllActions];
    }];
}

-(void) checkHitObstacle{
    if(_hitObstacle){
        _hitObstacle = NO;
        _player.position = CGPointMake(_player.position.x, _player.position.y);
        [self runAction:_gameOverSound];
        [self switchToShowScore];
    }
}


-(void) updateScore{
    [_worldNode enumerateChildNodesWithName:@"LeftSide" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *sprite = (SKSpriteNode*) node;
        NSNumber *passed = sprite.userData[@"Passed"];
        if(passed && passed.boolValue){
            return;
        }
        if(_player.position.y < node.position.y){
            [GameScore shared].score++;
            [_player runAction:_scoreSound];
            _scoreLabel.text = [NSString stringWithFormat:@"%d",[GameScore shared].score];
            node.userData[@"Passed"] = @YES;
        }
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // check what node is being touched
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKLabelNode *touchNode = (SKLabelNode*)[self nodeAtPoint:touchLocation];

    //touch enable according to the gamestate
    switch (_gameState) {
        case GameStateMainMenu:
            if([touchNode.name isEqualToString:@"play"]){
                [self removeMainMenu];
                [self switchToGamePlay];
            }
            else if([touchNode.name isEqualToString:@"rate"])
                [self rateApp];
            break;
        case GameStatePlay:
            break;
        case GameStateShowingScore:
            break;
        case GameStateGameOver:
            if ([touchNode.name isEqualToString:@"ok"] || touchLocation.x < self.size.width*.5) {
                [self switchToNewGame];
            }
            if ([touchNode.name isEqualToString:@"share"]){
                [self shareScore];
            }
            break;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    //method that are called every frame according to the current gamestate
    switch (_gameState) {
        case GameStateMainMenu:
            [_player update:currentTime];
            break;
        case GameStatePlay:
            [self checkHitObstacle];
            [_player update:currentTime];
            [self updateScore];
            break;
        case GameStateShowingScore:
            break;
        case GameStateGameOver:
            break;
    }
}

#pragma mark - Collision Detection
- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *other = (contact.bodyA.categoryBitMask == CollisionCategoryPlayer ? contact.bodyB : contact.bodyA);
 
    if (other.categoryBitMask == CollisionCategoryObstacle) {
        _hitObstacle = YES;
        return;
    }
}

#pragma mark - Special
- (void)shareScore {
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8", APP_ID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    UIImage *screenshot = [self.delegate screenshot];
    
    NSString *initialTextString = [NSString stringWithFormat:@"You scored %d on Falling Chicken", [GameScore shared].score];
    [self.delegate shareString:initialTextString url:url image:screenshot];
}

- (void)rateApp {
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8", APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}



@end
