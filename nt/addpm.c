/* Add entries to the GNU Emacs Program Manager folder.
   Copyright (C) 1995, 2001-2023 Free Software Foundation, Inc.

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

/****************************************************************************
 *
 * Program: addpm	(adds emacs to the Windows program manager)
 *
 * Usage:
 *   	argv[1] = install path for emacs
 *
 * argv[2] used to be an optional argument for setting the icon.
 * But now Emacs has a professional looking icon of its own.
 * If users really want to change it, they can go into the settings of
 * the shortcut that is created and do it there.
 */

/* Use parts of shell API that were introduced by the merge of IE4
   into the desktop shell.  If Windows 95 or NT4 users do not have IE4
   installed, then the DDE fallback for creating icons the Windows 3.1
   progman way will be used instead, but that is prone to lockups
   caused by other applications not servicing their message queues.  */

#define DEFER_MS_W32_H
#include <config.h>

#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>

/* MinGW64 barfs if _WIN32_IE is defined to anything below 0x0500.  */
#ifndef MINGW_W64
# ifdef _WIN32_IE
#  undef _WIN32_IE
# endif
#define _WIN32_IE 0x0400
#endif
/* Request C Object macros for COM interfaces.  */
#define COBJMACROS 1

#include <windows.h>
#include <shlobj.h>
#include <ddeml.h>

#ifndef OLD_PATHS
#include "../src/epaths.h"
#endif

HDDEDATA CALLBACK DdeCallback (UINT, UINT, HCONV, HSZ, HSZ, HDDEDATA, DWORD_PTR,
			       DWORD_PTR);

HDDEDATA CALLBACK
DdeCallback (UINT uType, UINT uFmt, HCONV hconv,
	     HSZ hsz1, HSZ hsz2, HDDEDATA hdata,
	     DWORD_PTR dwData1, DWORD_PTR dwData2)
{
  return ((HDDEDATA) NULL);
}

#define DdeCommand(str) 	\
	DdeClientTransaction ((LPBYTE)str, strlen (str)+1, conversation, (HSZ)NULL, \
		              CF_TEXT, XTYP_EXECUTE, 30000, NULL)

#define REG_ROOT "SOFTWARE\\GNU\\Emacs"
#define REG_APP_PATH \
  "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\emacs.exe"

static struct entry
{
  const char *name;
  const char *value;
}
env_vars[] =
{
#ifdef OLD_PATHS
  {"emacs_dir", NULL},
  {"EMACSLOADPATH", "%emacs_dir%/site-lisp;%emacs_dir%/../site-lisp;%emacs_dir%/lisp"},
  {"SHELL", "%emacs_dir%/bin/cmdproxy.exe"},
  {"EMACSDATA", "%emacs_dir%/etc"},
  {"EMACSPATH", "%emacs_dir%/bin"},
  /* We no longer set INFOPATH because Info-default-directory-list
     is then ignored.  */
  /*  {"INFOPATH", "%emacs_dir%/info"},  */
  {"EMACSDOC", "%emacs_dir%/etc"},
  {"TERM", "cmd"}
#else  /* !OLD_PATHS */
  {"emacs_dir", NULL},
  {"EMACSLOADPATH", PATH_SITELOADSEARCH ";" PATH_LOADSEARCH},
  {"SHELL", PATH_EXEC "/cmdproxy.exe"},
  {"EMACSDATA", PATH_DATA},
  {"EMACSPATH", PATH_EXEC},
  /* We no longer set INFOPATH because Info-default-directory-list
     is then ignored.  */
  /*  {"INFOPATH", "%emacs_dir%/info"},  */
  {"EMACSDOC", PATH_DOC},
  {"TERM", "cmd"}
#endif
};

static void
add_registry (const char *path)
{
  HKEY hrootkey = NULL;
  int i;

  /* Record the location of Emacs to the App Paths key if we have
     sufficient permissions to do so.  This helps Windows find emacs quickly
     if the user types emacs.exe in the "Run Program" dialog without having
     emacs on their path.  Some applications also use the same registry key
     to discover the installation directory for programs they are looking for.
     Multiple installations cannot be handled by this method, but it does not
     affect the general operation of other installations of Emacs, and we
     are blindly overwriting the Start Menu entries already.
  */
  if (RegCreateKeyEx (HKEY_LOCAL_MACHINE, REG_APP_PATH, 0, NULL,
                      REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL,
                      &hrootkey, NULL) == ERROR_SUCCESS)
    {
      int len;
      char *emacs_path;

      len = strlen (path) + 15; /* \bin\emacs.exe + terminator.  */
      emacs_path = (char *) alloca (len);
      sprintf (emacs_path, "%s\\bin\\emacs.exe", path);

      RegSetValueEx (hrootkey, NULL, 0, REG_EXPAND_SZ, emacs_path, len);
      RegCloseKey (hrootkey);
    }

  /* Previous versions relied on registry settings, but we do not need
     them any more.  If registry settings are installed from a previous
     version, replace them to ensure they are the current settings.
     Otherwise, do nothing.  */

  /* Check both the current user and the local machine to see if we
     have any resources.  */

  if (RegOpenKeyEx (HKEY_LOCAL_MACHINE, REG_ROOT, 0,
		    KEY_WRITE | KEY_QUERY_VALUE, &hrootkey) != ERROR_SUCCESS
      && RegOpenKeyEx (HKEY_CURRENT_USER, REG_ROOT, 0,
		       KEY_WRITE | KEY_QUERY_VALUE, &hrootkey) != ERROR_SUCCESS)
    return;

  for (i = 0; i < (sizeof (env_vars) / sizeof (env_vars[0])); i++)
    {
      const char * value = env_vars[i].value ? env_vars[i].value : path;

      /* Replace only those settings that already exist.  */
      if (RegQueryValueEx (hrootkey, env_vars[i].name, NULL,
			   NULL, NULL, NULL) == ERROR_SUCCESS)
	RegSetValueEx (hrootkey, env_vars[i].name, 0, REG_EXPAND_SZ,
		       value, lstrlen (value) + 1);
    }

  RegCloseKey (hrootkey);
}

int
main (int argc, char *argv[])
{
  char start_folder[MAX_PATH + 1];
  int shortcuts_created = 0;
  int com_available = 1;
  char modname[MAX_PATH];
  const char *prog_name;
  const char *emacs_path;
  char *p;
  int quiet = 0;
  HRESULT result;
  IShellLinkA *shortcut;

  /* If no args specified, use our location to set emacs_path.  */

  if (argc > 1
      && (argv[1][0] == '/' || argv[1][0] == '-')
      && argv[1][1] == 'q')
    {
      quiet = 1;
      --argc;
      ++argv;
    }

  if (argc > 1)
    emacs_path = argv[1];
  else
    {
      if (!GetModuleFileName (NULL, modname, MAX_PATH) ||
	  (p = strrchr (modname, '\\')) == NULL)
	{
	  fprintf (stderr, "fatal error");
	  exit (1);
	}
      *p = 0;

      /* Set emacs_path to emacs_dir if we are in "%emacs_dir%\bin".  */
      if ((p = strrchr (modname, '\\')) && stricmp (p, "\\bin") == 0)
	{
	  *p = 0;
	  emacs_path = modname;
	}
      else
	{
	  fprintf (stderr, "usage: addpm emacs_path\n");
	  exit (1);
	}

      /* Tell user what we are going to do.  */
      if (!quiet)
	{
	  int result;

	  const char install_msg[] = "Install Emacs at %s?\n";
	  char msg[ MAX_PATH + sizeof (install_msg) ];
	  sprintf (msg, install_msg, emacs_path);
	  result = MessageBox (NULL, msg, "Install Emacs",
			       MB_OKCANCEL | MB_ICONQUESTION);
	  if (result != IDOK)
	    {
	      fprintf (stderr, "Install canceled\n");
	      exit (1);
	    }
	}
    }

  add_registry (emacs_path);
  prog_name =  "runemacs.exe";

  /* Try to install globally.  */

  if (!SUCCEEDED (CoInitialize (NULL))
      || !SUCCEEDED (CoCreateInstance (&CLSID_ShellLink, NULL,
					CLSCTX_INPROC_SERVER, &IID_IShellLinkA,
					(void **) &shortcut)))
    {
      com_available = 0;
    }

  if (com_available
      && SHGetSpecialFolderPath (NULL, start_folder, CSIDL_COMMON_PROGRAMS, 0))
    {
      if (strlen (start_folder) < (MAX_PATH - 20))
	{
	  strcat (start_folder, "\\Gnu Emacs");
	  if (CreateDirectory (start_folder, NULL)
	      || GetLastError () == ERROR_ALREADY_EXISTS)
	    {
	      char full_emacs_path[MAX_PATH + 1];
	      IPersistFile *lnk;
	      strcat (start_folder, "\\Emacs.lnk");
	      sprintf (full_emacs_path, "%s\\bin\\%s", emacs_path, prog_name);
	      IShellLinkA_SetPath (shortcut, full_emacs_path);
	      IShellLinkA_SetDescription (shortcut, "GNU Emacs");
	      result = IShellLinkA_QueryInterface (shortcut, &IID_IPersistFile,
						   (void **) &lnk);
	      if (SUCCEEDED (result))
		{
		  wchar_t unicode_path[MAX_PATH];
		  MultiByteToWideChar (CP_ACP, 0, start_folder, -1,
				       unicode_path, MAX_PATH);
		  if (SUCCEEDED (IPersistFile_Save (lnk, unicode_path, TRUE)))
		    shortcuts_created = 1;
		  IPersistFile_Release (lnk);
		}
	    }
	}
    }

  if (!shortcuts_created && com_available
      && SHGetSpecialFolderPath (NULL, start_folder, CSIDL_PROGRAMS, 0))
    {
      /* Ensure there is enough room for "...\GNU Emacs\Emacs.lnk".  */
      if (strlen (start_folder) < (MAX_PATH - 20))
	{
	  strcat (start_folder, "\\Gnu Emacs");
	  if (CreateDirectory (start_folder, NULL)
	      || GetLastError () == ERROR_ALREADY_EXISTS)
	    {
	      char full_emacs_path[MAX_PATH + 1];
	      IPersistFile *lnk;
	      strcat (start_folder, "\\Emacs.lnk");
	      sprintf (full_emacs_path, "%s\\bin\\%s", emacs_path, prog_name);
	      IShellLinkA_SetPath (shortcut, full_emacs_path);
	      IShellLinkA_SetDescription (shortcut, "GNU Emacs");
	      result = IShellLinkA_QueryInterface (shortcut, &IID_IPersistFile,
						   (void **) &lnk);
	      if (SUCCEEDED (result))
		{
		  wchar_t unicode_path[MAX_PATH];
		  MultiByteToWideChar (CP_ACP, 0, start_folder, -1,
				       unicode_path, MAX_PATH);
		  if (SUCCEEDED (IPersistFile_Save (lnk, unicode_path, TRUE)))
		    shortcuts_created = 1;
		  IPersistFile_Release (lnk);

		}
	    }
	}
    }

  if (com_available)
    IShellLinkA_Release (shortcut);

  /* Need to call uninitialize, even if ComInitialize failed.  */
  CoUninitialize ();

  /* Fallback on old DDE method if the above failed.  */
  if (!shortcuts_created)
    {
      DWORD dde = 0;
      HCONV conversation;
      HSZ progman;
      char add_item[MAX_PATH*2 + 100];

      DdeInitialize (&dde, (PFNCALLBACK) DdeCallback, APPCMD_CLIENTONLY, 0);
      progman = DdeCreateStringHandle (dde, "PROGMAN", CP_WINANSI);
      conversation = DdeConnect (dde, progman, progman, NULL);
      if (conversation)
	{
	  DdeCommand ("[CreateGroup (\"Gnu Emacs\")]");
	  DdeCommand ("[ReplaceItem (Emacs)]");
	  sprintf (add_item, "[AddItem (\"%s\\bin\\%s\", Emacs)]",
		   emacs_path, prog_name);
	  DdeCommand (add_item);

	  DdeDisconnect (conversation);
	}

      DdeFreeStringHandle (dde, progman);
      DdeUninitialize (dde);
   }

  return 0;
}
