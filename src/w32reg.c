/* Emulate the X Resource Manager through the registry.

Copyright (C) 1990, 1993-1994, 2001-2023 Free Software Foundation, Inc.

Author: Kevin Gallo

This file is NOT part of GNU Emacs.

GNU Emacs is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.  */

#include <config.h>
#include "lisp.h"
#include "blockinput.h"
#include "w32term.h"

#include <stdio.h>

#define REG_ROOT "SOFTWARE\\GNU\\Emacs"

/* Default system colors from the Display Control Panel settings.  */
#define SYSTEM_DEFAULT_RESOURCES                          \
  "emacs.foreground:SystemWindowText\0"			  \
  "emacs.background:SystemWindow\0"                       \
  "emacs.tooltip.attributeForeground:SystemInfoText\0"    \
  "emacs.tooltip.attributeBackground:SystemInfoWindow\0"  \
  "emacs.tool-bar.attributeForeground:SystemButtonText\0" \
  "emacs.tool-bar.attributeBackground:SystemButtonFace\0" \
  "emacs.tab-bar.attributeForeground:SystemButtonText\0" \
  "emacs.tab-bar.attributeBackground:SystemButtonFace\0" \
  "emacs.menu.attributeForeground:SystemMenuText\0"       \
  "emacs.menu.attributeBackground:SystemMenu\0"           \
  "emacs.scroll-bar.attributeForeground:SystemScrollbar\0"

/* Other possibilities for default faces:

  region: Could use SystemHilight, but interferes with our ability to
  see most syntax highlighting through the region face.

  modeline: Could use System(In)ActiveTitle, gradient versions (not
  supported on 95 and NT), but modeline is more like a status bar
  really (which don't appear to be configurable in Windows).

  highlight: Could use SystemHotTrackingColor, but it is not supported
  on Windows 95 or NT, and other apps only seem to use it for menus
  anyway.

*/

static char *
w32_get_rdb_resource (const char *rdb, const char *resource)
{
  char *value = (char *)rdb;
  int len = strlen (resource);

  while (*value)
    {
      /* Comparison is case-insensitive because registry searches are too.  */
      if ((strnicmp (value, resource, len) == 0) && (value[len] == ':'))
        return xstrdup (&value[len + 1]);

      value = strchr (value, '\0') + 1;
    }

  return NULL;
}

static const char *
w32_get_string_resource_1 (const char *name, const char *class, DWORD dwexptype)
{
  LPBYTE lpvalue = NULL;
  HKEY hrootkey = NULL;
  DWORD dwType;
  DWORD cbData;
  BOOL ok = FALSE;
  HKEY hive = HKEY_CURRENT_USER;

 trykey:

  block_input ();

  /* Check both the current user and the local machine to see if we have
     any resources */

  if (RegOpenKeyEx (hive, REG_ROOT, 0, KEY_READ, &hrootkey) == ERROR_SUCCESS)
    {
      const char *keyname;

      if (RegQueryValueEx (hrootkey, name, NULL, &dwType, NULL, &cbData) == ERROR_SUCCESS
	  && dwType == dwexptype)
	{
	  keyname = name;
	}
      else if (RegQueryValueEx (hrootkey, class, NULL, &dwType, NULL, &cbData) == ERROR_SUCCESS
	       && dwType == dwexptype)
	{
	  keyname = class;
	}
      else
	{
	  keyname = NULL;
	}

      ok = (keyname
	    && (lpvalue = xmalloc (cbData)) != NULL
	    && RegQueryValueEx (hrootkey, keyname, NULL, NULL, lpvalue, &cbData) == ERROR_SUCCESS);

      RegCloseKey (hrootkey);
    }

  unblock_input ();

  if (!ok)
    {
      if (lpvalue)
	{
	  xfree (lpvalue);
	  lpvalue = NULL;
	}
      if (hive == HKEY_CURRENT_USER)
	{
	  hive = HKEY_LOCAL_MACHINE;
	  goto trykey;
	}

      /* Check if there are Windows specific defaults defined.  */
      return w32_get_rdb_resource (SYSTEM_DEFAULT_RESOURCES, name);
    }
  return (const char *)lpvalue;
}

/* Retrieve the string resource specified by NAME with CLASS from
   database RDB. */

const char *
w32_get_string_resource (void *v_rdb, const char *name, const char *class)
{
  const char *rdb = *(char **) v_rdb;

  if (rdb)
    {
      char *resource;

      if ((resource = w32_get_rdb_resource (rdb, name)))
        return resource;
      if ((resource = w32_get_rdb_resource (rdb, class)))
        return resource;
    }

  if (inhibit_x_resources)
    /* --quick was passed, so this is a no-op.  */
    return NULL;

  return w32_get_string_resource_1 (name, class, REG_SZ);
}
