//
//  SolWinScene.h
//  Solitaire
//
//  Created by Mark Pazolli on 27/3/2023.
//

#ifndef SolWinScene_h
#define SolWinScene_h

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

typedef void (*SOL_CALLBACK)(void);

@interface SolWinScene : SKScene {
        
    NSTimer *timer;

    int count;
    
    SOL_CALLBACK callback;
    
}

- (void)sceneDidLoad;

- (void)increment:(id)sender;

- (void)runCallbackOnComplete:(SOL_CALLBACK)onComplete;

@end


#endif /* SolWinScene_h */
