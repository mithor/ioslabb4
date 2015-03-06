//
//  ViewController.m
//  Labb4
//
//  Created by IT-Högskolan on 2015-02-15.
//  Copyright (c) 2015 IT-Högskolan. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *mypaddle;
@property (weak, nonatomic) IBOutlet UIView *ball;
@property (weak, nonatomic) IBOutlet UIView *toppaddle;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat speedX;
@property (nonatomic) CGFloat speedY;
@property (nonatomic) int score;
@property (nonatomic) int topscore;
@property (nonatomic) int countdown;
@property (nonatomic) CGPoint ballPoint;
@property (nonatomic) CGPoint paddlePoint;
@property (nonatomic) CGPoint topPaddlePoint;

@end

@implementation ViewController {
    SystemSoundID pingSound;
}

- (IBAction)pan:(UIPanGestureRecognizer*)sender {
    static CGFloat origin;
    if (sender.state == UIGestureRecognizerStateBegan) {
        origin = self.mypaddle.center.x;
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint transpoint = [sender translationInView:self.view];
        transpoint.y = self.mypaddle.center.y;
        transpoint.x = transpoint.x + origin;
        self.mypaddle.center = transpoint;
    }
}

- (IBAction)pushedPlay:(id)sender {
    self.playButton.hidden=YES;
    self.labelText.hidden=YES;
    self.mypaddle.hidden=NO;
    self.toppaddle.hidden=NO;
    self.score = 0;
    self.topscore = 0;
    self.scoreLabel.text = [NSString stringWithFormat: @"%d", self.score];
    self.scoreLabelTop.text = [NSString stringWithFormat: @"%d", self.topscore];
    [self playBall];
}

-(void)playBall {
    self.speedX = (float)(arc4random()%21)/10-1;
    self.speedY = (float)(arc4random()%11)/10+1;
    self.ball.center = CGPointMake(self.view.center.x, self.view.center.y/2);
    self.toppaddle.center = CGPointMake(self.toppaddle.superview.frame.size.width/2, self.toppaddle.center.y);
    self.ball.hidden=NO;
    self.labelText.hidden=YES;
    [self startTimer];
}

-(void)gameOver {
    [self stopTimer];
    if (self.score>self.topscore) {
        self.labelText.text = [NSString stringWithFormat:@"You win! Score was %d to %d. Play again?", self.score, self.topscore];
    } else {
        self.labelText.text = [NSString stringWithFormat:@"You Lose! Score was %d to %d. Play again?", self.score, self.topscore];
    }
    self.labelText.hidden=NO;
    self.playButton.hidden=NO;
    self.mypaddle.hidden=YES;
    self.toppaddle.hidden=YES;
}

-(void)interval {
    if (self.countdown>0) {
        self.countdown--;
        if (!self.countdown==0) {
            self.labelText.text = [NSString stringWithFormat:@"%d", self.countdown];
        } else {
            self.labelText.text = [NSString stringWithFormat:@"GO!"];
        }
    } else {
        [self stopTimer];
        [self playBall];
    }
}

-(void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.01
                  target:self
                  selector:@selector(dance)
                  userInfo:nil repeats:YES];
}

-(void)intervalTimer {
    [self stopTimer];
    self.ball.hidden=YES;
    if (self.score>4 || self.topscore>4) {
        [self gameOver];
    } else {
        self.labelText.hidden=NO;
        self.countdown=3;
        self.labelText.text = [NSString stringWithFormat:@"%d", self.countdown];
        self.timer = [NSTimer
                      scheduledTimerWithTimeInterval:1
                      target:self
                      selector:@selector(interval)
                      userInfo:nil repeats:YES];
    }
}

- (void) stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)dance {
    self.ball.center = CGPointMake(self.ball.center.x + self.speedX, self.ball.center.y + self.speedY);
    self.toppaddle.center = CGPointMake(self.toppaddle.center.x + self.speedX/2, self.toppaddle.center.y);
    
    if (self.ball.center.y+self.ball.bounds.size.height/2 > self.mypaddle.center.y-self.mypaddle.bounds.size.height/2 && self.ball.center.x-self.ball.bounds.size.width/2 < self.mypaddle.center.x+self.mypaddle.bounds.size.width/2 && self.ball.center.x+self.ball.bounds.size.width/2 > self.mypaddle.center.x-self.mypaddle.bounds.size.width/2) {
        AudioServicesPlaySystemSound(pingSound);
        self.speedY = -self.speedY*1.1;
        if (self.ball.center.x < self.mypaddle.center.x-self.mypaddle.bounds.size.width/5) {
            self.speedX = self.speedX-(arc4random()%21)/10;
        } else if (self.ball.center.x > self.mypaddle.center.x+self.mypaddle.bounds.size.width/5) {
            self.speedX = self.speedX+(arc4random()%21)/10;
        }
    }
    if (self.ball.center.y-self.ball.bounds.size.height/2 < self.toppaddle.center.y+self.toppaddle.bounds.size.height/2 && self.ball.center.x-self.ball.bounds.size.width/2 < self.toppaddle.center.x+self.toppaddle.bounds.size.width/2 && self.ball.center.x+self.ball.bounds.size.width/2 > self.toppaddle.center.x-self.toppaddle.bounds.size.width/2) {
        AudioServicesPlaySystemSound(pingSound);
        self.speedY = -self.speedY*1.1;
        if (self.ball.center.x < self.toppaddle.center.x-self.toppaddle.bounds.size.width/5) {
            self.speedX = self.speedX-(arc4random()%21)/10;
        } else if (self.ball.center.x > self.toppaddle.center.x+self.toppaddle.bounds.size.width/5) {
            self.speedX = self.speedX+(arc4random()%21)/10;
        }
    }
    if (self.ball.center.y-self.ball.bounds.size.height/2 < 0) {
        self.score++;
        self.scoreLabel.text = [NSString stringWithFormat: @"%d", self.score];
        [self intervalTimer];
    }
    if (self.ball.center.x-self.ball.bounds.size.width/2 < 0 || self.ball.center.x+self.ball.bounds.size.width/2 > self.ball.superview.frame.size.width) {
        AudioServicesPlaySystemSound(pingSound);
        self.speedX = -self.speedX;
    }
    if (self.ball.center.y-self.ball.bounds.size.height/2 > self.ball.superview.frame.size.height) {
        self.topscore++;
        self.scoreLabelTop.text = [NSString stringWithFormat: @"%d", self.topscore];
        [self intervalTimer];
    }
    
}
-(void)viewWillLayoutSubviews {
    self.ballPoint = self.ball.center;
    self.paddlePoint = self.mypaddle.center;
    self.topPaddlePoint = self.toppaddle.center;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ball.hidden=YES;
    self.mypaddle.center = CGPointMake(self.mypaddle.center.x, self.mypaddle.superview.frame.size.height-35);
    
    NSURL *pingURL = [[NSBundle mainBundle] URLForResource:@"ping" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pingURL, &pingSound);
}

- (void)viewDidLayoutSubviews {
    self.mypaddle.frame = CGRectMake(self.mypaddle.superview.frame.size.width/2 - self.mypaddle.superview.frame.size.width/8, self.mypaddle.superview.frame.size.height - self.mypaddle.superview.frame.size.height/10, self.mypaddle.superview.frame.size.width/4, self.mypaddle.superview.frame.size.height/30);
    self.toppaddle.frame = CGRectMake(self.toppaddle.superview.frame.size.width/2 - self.toppaddle.superview.frame.size.width/8, self.toppaddle.superview.frame.size.height - self.toppaddle.superview.frame.size.height/10, self.toppaddle.superview.frame.size.width/4, self.toppaddle.superview.frame.size.height/30);
    self.ball.center = self.ballPoint;
    self.mypaddle.center = self.paddlePoint;
    self.toppaddle.center = self.topPaddlePoint;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
