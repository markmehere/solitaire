//
//  SolMenuItem.h
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#ifndef SolMenuItem_h
#define SolMenuItem_h

#import <gtk/gtk.h>

typedef void (*SOL_ACTION_CALLBACK)(GAction *action, void *window);

typedef NS_ENUM(NSInteger, SolMenuItemType) {
    ActionEntry,
    ToggleActionEntry,
    RadioActionEntry,
    RecentGameEntry,
    SubmenuEntry,
    MockEntry,
    DynamicPlaceholder,
    Separator
};

@interface SolMenuItem : NSObject {
    NSString *name;
    NSString *stock_id;
    NSString *label;
    NSString *accelerator;
    NSString *tooltip;
    NSString *payload;
    GMenu *submenu;
    GSimpleAction *simpleAction;
    GVariant *actionPayload;
    SolMenuItemType type;
    bool is_active;
    bool value;
    GCallback callback;
    GCallback callbackNoProxy;
}

- (id)initWithActionEntry:(GtkActionEntry *)entry;

- (id)initWithName:(NSString *)name label:(NSString *)label andAccelerator:(NSString *)accelerator;

- (id)initWithName:(NSString *)name label:(NSString *)label value:(bool)value andCallback:(GCallback)callback;

- (id)initAsHelp;

- (id)initAsGameHelp;

- (id)initAsSourceCode;

- (id)initPlaceholderWithName:(NSString *)name label:(NSString *)label;

- (id)initWithToggleActionEntry:(GtkToggleActionEntry *)entry;

- (id)initWithRecentGame:(NSString *)gameName fullName:(NSString *)fullName callback:(GCallback)callback;

- (id)initAsSeparator;

- (bool)isSeparator;

- (bool)isDynamicPlaceholder;

- (NSString *)name;

- (GMenu *)submenu;

- (GSimpleAction *)action;

- (SOL_ACTION_CALLBACK)original;

- (void)addToMenu:(GMenu *)menu andApplication:(GtkApplication *)application;

@end

#endif /* OActionEntry_h */
