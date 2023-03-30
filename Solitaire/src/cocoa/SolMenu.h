//
//  SolMenu.h
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#ifndef SolMenu_h
#define SolMenu_h

#import "SolMenuItem.h"
#import "SolActionDictionary.h"
#import <gtk/gtk.h>

@interface SolMenu : NSObject {
    NSString *title;
    NSMutableArray *items;
    GMenu *dynamicMenu;
    GMenu *manifestation;
    GtkApplication *app;
}

- (id)initWithTitle:(NSString *)title;

- (GMenu *)dynamicMenu;

- (void)addMenuItem:(SolMenuItem *)item;

- (void)addSeparator;

- (void)addToMenuBar:(GMenu *)menuBar andApplication:(GtkApplication *)application;

@end

@interface FileMenu : SolMenu {
}

- (id)initFromDictionary:(SolActionDictionary *)dict;

@end

@interface EditMenu : SolMenu {
}

- (id)initFromDictionary:(SolActionDictionary *)dict;

@end

@interface ViewMenu : SolMenu {
}

- (id)initFromDictionary:(SolActionDictionary *)dict;

@end

@interface OptionsMenu : SolMenu {
}

- (id)initFromDictionary:(SolActionDictionary *)dict;

@end

@interface HelpMenu : SolMenu {
}

- (id)initFromDictionary:(SolActionDictionary *)dict;

@end

#endif /* SolMenu_h */
