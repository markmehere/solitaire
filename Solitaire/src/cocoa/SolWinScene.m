//
//  SolFailedView.m
//  Marc Solitaire
//
//  Created by Mark Pazolli on 27/3/2023.
//

#import "SolWinScene.h"
#import "Cocoa/Cocoa.h"
#import "CoreImage/CoreImage.h"

@implementation SolWinScene

- (void)sceneDidLoad {
    [self setBackgroundColor:[NSColor clearColor]];
    count = 10;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.4
        target:self
        selector:@selector(increment:)
        userInfo:nil
        repeats:YES];
}

- (void)increment:(id)sender {
    count--;
    if (count == 0) {
        [timer invalidate];
        timer = nil;
        [[NSAlert alertWithMessageText:@"Congratulations!" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"You won the game."] runModal];
        if (callback) (*callback)();
    }
    else if (count > 2) {
        NSString *fireworkPath = [[NSBundle mainBundle] pathForResource:@"Firework" ofType:@"sks"];
        SKEmitterNode *fireworkEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:fireworkPath];
        NSRect frame = [self frame];
        int rand1 = rand() % ((int)frame.size.width - 120) + 60;
        int rand2 = rand() % ((int)frame.size.height - 120) + 60;
        int rand3 = rand() % 4;
        [fireworkEmitter setParticleColorSequence:nil];
        [fireworkEmitter setParticleColorBlendFactor:1.0];
        if (rand3 == 0) {
            [fireworkEmitter setParticleColor:[SKColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0]];
        }
        else if (rand3 == 1) {
            [fireworkEmitter setParticleColor:[SKColor colorWithRed:0.3 green:0.9 blue:0.3 alpha:1.0]];
        }
        else if (rand3 == 2) {
            [fireworkEmitter setParticleColor:[SKColor colorWithRed:0.3 green:0.3 blue:0.9 alpha:1.0]];
        }
        [fireworkEmitter setPosition:NSMakePoint(rand1, rand2)];
        
        [self addChild:fireworkEmitter];
    }
}

- (void)runCallbackOnComplete:(SOL_CALLBACK)onComplete {
    callback = onComplete;
}

@end
