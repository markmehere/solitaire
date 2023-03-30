//
//  SolFinishEffects.h
//  Solitaire
//
//  Created by Mark Pazolli on 27/3/2023.
//

#ifndef SolFinishEffects_h
#define SolFinishEffects_h

#import <Cocoa/Cocoa.h>
#import "SolLostEffect.h"
#import "SolWinScene.h"

@interface SolFinishEffects : NSObject {
        
    NSWindow *window;
    
    SolLostEffect *lostEffect;
    
    SolWinScene *winScene;
    
}

- (id)init;

@end

extern void createFinishEffects(void);
extern void showWin(void);
extern void showLost(void);
extern void clearFinishEffects(void);

#endif /* SolFinishEffects_h */
