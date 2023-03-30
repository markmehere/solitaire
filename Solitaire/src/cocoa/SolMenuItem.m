//
//  SolMenuItem.m
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "SolMenuItem.h"
#import <gtk/gtk.h>
#import "SolLostEffect.h"
#import "SolWinScene.h"
#import "window.h"

extern NSString *curGameModule;

extern AisleriotWindow *active_win;

NSMutableDictionary *loadedLabels = nil;

NSMutableDictionary *proxiedCallbacks = nil;


void addStockTranslation(const char *stock_id, const char *label) {
    if (!loadedLabels) {
        loadedLabels = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    NSString *key = [NSString stringWithUTF8String:stock_id];
    NSString *value = [NSString stringWithUTF8String:label];
    [loadedLabels setValue:value forKey:key];
}

static void openHelp(void *one, void *two) {
    [[NSApplication sharedApplication] showHelp:nil];
}

static void openGameHelp(void *one, void *two) {
    [[NSHelpManager sharedHelpManager] openHelpAnchor:curGameModule inBook:@"org.pazolli.Solitaire.help"];
}

static void openGitHub(void *one, void *two) {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/markmehere/solitaire"]];
}

static void safeCallback(GAction *action, void *ignore) {
    NSString *name = [NSString stringWithUTF8String:g_action_get_name(action)];
    SolMenuItem *menuItem = [proxiedCallbacks objectForKey:name];
    SOL_ACTION_CALLBACK callback = [menuItem original];
    (*callback)(action, active_win);
    g_main_context_wakeup(g_main_context_default());
}

@implementation SolMenuItem

- (id)initWithActionEntry:(GtkActionEntry *)entry {
    self = [super init];
    
    if (!proxiedCallbacks) proxiedCallbacks = [NSMutableDictionary dictionaryWithCapacity:32];
    self->name = [NSString stringWithUTF8String:entry->name];
    self->stock_id = entry->stock_id ? [NSString stringWithUTF8String:entry->stock_id] : nil;
    self->label = entry->label ? [NSString stringWithUTF8String:entry->label] : nil;
    if (!self->label && self->stock_id && loadedLabels) {
        self->label = [loadedLabels objectForKey:self->stock_id];
    }
    self->accelerator = entry->accelerator ? [NSString stringWithUTF8String:entry->accelerator] : nil;
    self->tooltip = entry->tooltip ? [NSString stringWithUTF8String:entry->tooltip] : nil;
    if (entry->callback) {
        self->callback = G_CALLBACK(safeCallback);
        self->callbackNoProxy = entry->callback;
        [proxiedCallbacks setValue:self forKey:self->name];
        self->type = ActionEntry;
    }
    else {
        self->type = MockEntry;
    }
    
    return self;
}

- (id)initWithRecentGame:(NSString *)gameName fullName:(NSString *)fullName callback:(GCallback)callback {
    self = [super init];
    
    self->name = fullName;
    self->label = gameName;
    self->payload = fullName;
    self->callback = callback;
    self->type = RecentGameEntry;
    
    return self;
    
}

- (id)initWithName:(NSString *)name label:(NSString *)label andAccelerator:(NSString *)accelerator {
    self = [super init];
    
    self->name = name;
    self->label = label;
    self->accelerator = accelerator;
    self->type = MockEntry;
    
    return self;
}

- (id)initWithName:(NSString *)name label:(NSString *)label value:(bool)value andCallback:(GCallback)callback {
    self = [super init];
    
    if (!proxiedCallbacks) proxiedCallbacks = [NSMutableDictionary dictionaryWithCapacity:32];
    self->name = name;
    self->label = label;
    self->callback = G_CALLBACK(safeCallback);
    self->callbackNoProxy = callback;
    self->type = ToggleActionEntry;
    self->value = value;
    [proxiedCallbacks setValue:self forKey:self->name];
    
    return self;
}

- (id)initAsHelp {
    self = [super init];
    
    self->name = @"Help";
    self->label = @"Marc Solitaire Help";
    self->callback = G_CALLBACK(openHelp);
    self->type = ActionEntry;
    
    return self;
}

- (id)initAsGameHelp {
    self = [super init];
    
    self->name = @"GameHelp";
    self->label = @"Current Game Help";
    self->callback = G_CALLBACK(openGameHelp);
    self->type = ActionEntry;
    
    return self;
}

- (id)initAsSourceCode {
    self = [super init];
    
    self->name = @"SourceCode";
    self->label = @"GitHub source code";
    self->callback = G_CALLBACK(openGitHub);
    self->type = ActionEntry;
    
    return self;
}

- (id)initPlaceholderWithName:(NSString *)name label:(NSString *)label {
    self = [super init];
    
    self->name = name;
    self->label = label;
    self->type = DynamicPlaceholder;
    
    return self;
}

- (id)initWithToggleActionEntry:(GtkToggleActionEntry *)entry {
    self = [super init];
    
    if (!proxiedCallbacks) proxiedCallbacks = [NSMutableDictionary dictionaryWithCapacity:32];
    self->name = [NSString stringWithUTF8String:entry->name];
    self->stock_id = entry->stock_id ? [NSString stringWithUTF8String:entry->stock_id] : nil;
    self->label = entry->label ? [NSString stringWithUTF8String:entry->label] : nil;
    if (!self->label && self->stock_id && loadedLabels) {
        self->label = [loadedLabels objectForKey:self->stock_id];
    }
    self->accelerator = entry->accelerator ? [NSString stringWithUTF8String:entry->accelerator] : nil;
    self->tooltip = entry->tooltip ? [NSString stringWithUTF8String:entry->tooltip] : nil;
    self->is_active = entry->is_active ? true : false;
    self->callback = G_CALLBACK(safeCallback);
    self->callbackNoProxy = entry->callback;
    self->type = ToggleActionEntry;
    [proxiedCallbacks setValue:self forKey:self->name];
    
    return self;
}

- (id)initAsSeparator {
    self = [super init];
    
    self->name = @"-";
    self->type = Separator;
    
    return self;
}

- (SOL_ACTION_CALLBACK)original {
    return (SOL_ACTION_CALLBACK)callbackNoProxy;
}

- (bool)isSeparator {
    return type == Separator;
}

- (bool)isDynamicPlaceholder {
    return type == DynamicPlaceholder;
}

- (void)dealloc {
    if (submenu) g_object_unref(submenu);
}

- (NSString *)name {
    return name;
}

- (GMenu *)submenu {
    return submenu;
}

- (GSimpleAction *)action {
    return simpleAction;
}

- (void)addToMenu:(GMenu *)menu andApplication:(GtkApplication *)application {
    NSString *formalName = [NSString stringWithFormat:@"app.%s", [name UTF8String]];
    
    NSAssert(label, @"label must be present");
    if (type == RecentGameEntry) {
        simpleAction = g_simple_action_new([name UTF8String], G_VARIANT_TYPE_STRING);
        g_action_map_add_action(G_ACTION_MAP(application), G_ACTION(simpleAction));
        g_signal_connect(simpleAction, "activate", self->callback, NULL);
        GMenuItem *menuItem = g_menu_item_new([label UTF8String], [formalName UTF8String]);
        g_menu_item_set_attribute(menuItem, "target", "s", [payload UTF8String]);
        g_menu_append_item(menu, menuItem);
        g_object_unref(simpleAction);
        g_object_unref(menuItem);
    }
    else if (type == ActionEntry || type == ToggleActionEntry || type == RadioActionEntry) {
        GVariant *state = g_variant_new_boolean(value);
        simpleAction = type == ActionEntry ? g_simple_action_new([name UTF8String], NULL) :
            g_simple_action_new_stateful([name UTF8String], NULL, state);
        g_action_map_add_action(G_ACTION_MAP(application), G_ACTION(simpleAction));
        g_signal_connect(simpleAction, "activate", self->callback, NULL);
        GMenuItem *menuItem = g_menu_item_new([label UTF8String], [formalName UTF8String]);
        if (accelerator) {
            g_menu_item_set_attribute(menuItem, "accel", "s", [accelerator UTF8String]);
        }
        g_menu_append_item(menu, menuItem);
        g_object_unref(simpleAction);
        g_object_unref(menuItem);
    }
    else if ([name isEqualToString:@"RecentMenu"]) {
        submenu = g_menu_new();
        GMenuItem *menuItem = g_menu_item_new_submenu([label UTF8String], G_MENU_MODEL(submenu));
        g_menu_append_item(menu, menuItem);
        g_object_unref(menuItem);
    }
    else if (type == MockEntry || type == DynamicPlaceholder) {
        GMenuItem *menuItem = g_menu_item_new([label UTF8String], [formalName UTF8String]);
        if (accelerator) {
            g_menu_item_set_attribute(menuItem, "accel", "s", [accelerator UTF8String]);
        }
        g_menu_append_item(menu, menuItem);
        g_object_unref(menuItem);
    }
}

@end
