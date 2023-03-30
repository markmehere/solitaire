//
//  SolFailedView.m
//  Marc Solitaire
//
//  Created by Mark Pazolli on 27/3/2023.
//

#import "SolFinishEffects.h"
#import "Cocoa/Cocoa.h"
#import "CoreImage/CoreImage.h"

SolFinishEffects *finishEffects = nil;

static void removeFromView() {
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    NSArray *array = [[window contentView] subviews];
    NSView *view = [array firstObject];
    [view removeFromSuperview];
}

@implementation SolFinishEffects

- (id)init {
    self = [super init];
    window = [[NSApplication sharedApplication] mainWindow];
    lostEffect = [[SolLostEffect alloc] initWithWindow:window];
    return self;
}

- (void)showLost {
    if (![[window contentView] contentFilters] || [[[window contentView] contentFilters] count] == 0) {
        [lostEffect run];
    }
}

- (void)showWin {
    if ([[[window contentView] subviews] count] == 0) {
        SKView *view = [[SKView alloc] initWithFrame:NSMakeRect(0, 0, [window frame].size.width, [window frame].size.height)];
        [view setAllowsTransparency:YES];
        SolWinScene *scene = [[SolWinScene alloc] initWithSize:NSMakeSize([window frame].size.width, [window frame].size.height)];
        [view presentScene:scene];
        [scene runCallbackOnComplete:removeFromView];
        [[window contentView] addSubview:view];
    }
}


- (void)clear {
    [[window contentView] setContentFilters:[[NSArray alloc] init]];
}

@end

void createFinishEffects(void) {
    if (!finishEffects) {
        finishEffects = [[SolFinishEffects alloc] init];
    }
}

void showWin(void) {
    if (finishEffects) [finishEffects showWin];
    else NSLog(@"Finish effects was not created!");
}

void showLost(void) {
    if (finishEffects) [finishEffects showLost];
    else NSLog(@"Finish effects was not created!");
}

void clearFinishEffects(void) {
    if (finishEffects) [finishEffects clear];
}
