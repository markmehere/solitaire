/*
 * Copyright © 2009 Christian Persch <chpe@src.gnome.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __AR_CURSOR_H__
#define __AR_CURSOR_H__

#include <gdk/gdk.h>

G_BEGIN_DECLS

typedef enum {
  AR_CURSOR_DEFAULT,
  AR_CURSOR_OPEN,
  AR_CURSOR_CLOSED,
  AR_CURSOR_DROPPABLE,
  AR_LAST_CURSOR
} ArCursorType;

GdkCursor *ar_cursor_new (GdkDisplay *display,
                          ArCursorType cursor_type);

G_END_DECLS

#endif /* __AR_CURSOR_H__ */
