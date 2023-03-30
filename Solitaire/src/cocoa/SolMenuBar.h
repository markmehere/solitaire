//
//  SolMenuBar.h
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#ifndef SolMenuBar_h
#define SolMenuBar_h

#import <Cocoa/Cocoa.h>
#import <gtk/gtk.h>
#import "SolActionDictionary.h"

@interface SolMenuBar : NSObject {
    NSMutableArray *optionGroupings;
    NSMutableDictionary *nameToGrouping;
    NSMutableArray *optionChecks;
    NSMutableArray *quickAccessItem;
    SolActionDictionary *activeDictionary;
    GMenu *dynamicOptionsMenu;
    NSTimer *timer;
}

@end

extern void addRecentGame(GtkApplication *application, const char *gameName, const char *fullName, GCallback callback, bool isFresh);
extern void addQuickAccessItem(const char *name, bool fresh);
extern void setQuickAccessItemEnabled(int index, bool value);
extern void setItemChecked(const char *name, bool value);
extern void createMenuBar(GtkApplication *application, SolActionDictionary *dict, GtkWindow *window);
extern void addCheckOption(const char *actionname, const char *display_name, GCallback option_cb, bool isFresh, bool curValue, GtkApplication *application);
extern void addRadioOption(const char *actionname, const char *display_name, int radion, GCallback option_cb, bool isFresh, bool curValue, GtkApplication *application);
extern void resetOptionsMenu(GtkApplication *application);
extern guint32 clearAllRadiosInGroup(const char *name, guint32 *mask);

#endif /* SolMenuBar_h */
