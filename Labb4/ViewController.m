//
//  ViewController.m
//  Labb4
//
//  Created by IT-Högskolan on 2015-02-15.
//  Copyright (c) 2015 IT-Högskolan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *mypaddle;
@property (weak, nonatomic) IBOutlet UIView *ball;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat speedX;
@property (nonatomic) CGFloat speedY;
@property (nonatomic) int score;

@end

@implementation ViewController

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
    self.score = 0;
    self.speedX = (float)(arc4random()%21)/10-1;
    self.speedY = (float)(arc4random()%11)/10+1;
    self.ball.center = CGPointMake(self.view.center.x, self.view.center.y/2);
    self.ball.hidden=NO;
    [self startTimer];
}

-(void)gameOver {
    [self stopTimer];
    self.ball.hidden=YES;
    self.labelText.text = [NSString stringWithFormat:@"Your score was %d. Play again?", self.score];
    self.labelText.hidden=NO;
    self.playButton.hidden=NO;
}


-(void)startTimer {
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.01
                  target:self
                  selector:@selector(dance)
                  userInfo:nil repeats:YES];
}

- (void) stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)dance {
    self.ball.center = CGPointMake(self.ball.center.x + self.speedX, self.ball.center.y + self.speedY);
    if (self.ball.center.y+self.ball.bounds.size.height/2 > self.mypaddle.center.y-self.mypaddle.bounds.size.height/2 && self.ball.center.x-self.ball.bounds.size.width/2 < self.mypaddle.center.x+self.mypaddle.bounds.size.width/2 && self.ball.center.x+self.ball.bounds.size.width/2 > self.mypaddle.center.x-self.mypaddle.bounds.size.width/2) {
        self.speedY = -self.speedY;
        if (self.ball.center.x < self.mypaddle.center.x-self.mypaddle.bounds.size.width/5) {
            self.speedX = self.speedX-(arc4random()%21)/10;
        } else if (self.ball.center.x > self.mypaddle.center.x+self.mypaddle.bounds.size.width/5) {
            self.speedX = self.speedX+(arc4random()%21)/10;
        }
    }
    if (self.ball.center.y-self.ball.bounds.size.height/2 < 0) {
        self.speedY = -self.speedY*1.5;
        self.score++;
    }
    if (self.ball.center.x-self.ball.bounds.size.width/2 < 0 || self.ball.center.x+self.ball.bounds.size.width/2 > self.ball.superview.frame.size.width) {
        self.speedX = -self.speedX;
    }
    if (self.ball.center.y-self.ball.bounds.size.height/2 > self.ball.superview.frame.size.height) {
        [self gameOver];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ball.hidden=YES;
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidLayoutSubviews {
    self.mypaddle.frame = CGRectMake(self.mypaddle.superview.frame.size.width/2 - self.mypaddle.superview.frame.size.width/8, self.mypaddle.superview.frame.size.height - self.mypaddle.superview.frame.size.height/10, self.mypaddle.superview.frame.size.width/4, self.mypaddle.superview.frame.size.height/30);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
