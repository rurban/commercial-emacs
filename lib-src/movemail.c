/* movemail foo bar -- move file foo to file bar,
   locking file foo the way /bin/mail respects.

Copyright (C) 1986, 1992-1994, 1996, 1999, 2001-2023 Free Software
Foundation, Inc.

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


/* Important notice: defining MAIL_USE_FLOCK or MAIL_USE_LOCKF *will
   cause loss of mail* if you do it on a system that does not normally
   use flock/lockf as its way of interlocking access to inbox files.  The
   setting of MAIL_USE_FLOCK and MAIL_USE_LOCKF *must agree* with the
   system's own conventions.  It is not a choice that is up to you.

   So, if your system uses lock files rather than flock, then the only way
   you can get proper operation is to enable movemail to write lockfiles there.
   This means you must either give that directory access modes
   that permit everyone to write lockfiles in it, or you must make movemail
   a setuid or setgid program.  */

/*
 * Modified January, 1986 by Michael R. Gretzinger (Project Athena)
 *
 * Added POP (Post Office Protocol) service.  When compiled -DMAIL_USE_POP
 * movemail will accept input filename arguments of the form
 * "po:username".  This will cause movemail to open a connection to
 * a pop server running on $MAILHOST (environment variable).  Movemail
 * must be setuid to root in order to work with POP.
 *
 * New module: popmail.c
 * Modified routines:
 *	main - added code within #ifdef MAIL_USE_POP; added setuid (getuid ())
 *		after POP code.
 * New routines in movemail.c:
 *	get_errmsg - return pointer to system error message
 *
 * Modified August, 1993 by Jonathan Kamens (OpenVision Technologies)
 *
 * Move all of the POP code into a separate file, "pop.c".
 * Use strerror instead of get_errmsg.
 *
 */

#include <config.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <timespec.h>

#include <getopt.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <string.h>

#include <attribute.h>
#include <unlocked-io.h>

#include "syswait.h"
#ifdef MAIL_USE_POP
#include "pop.h"
#endif

#ifdef MSDOS
#undef access
#endif /* MSDOS */

#ifdef WINDOWSNT
#include "ntlib.h"
#undef access
#undef unlink
#define fork() 0
#define waitpid(child, var, flags) (*(var) = 0)
/* Unfortunately, Samba doesn't seem to properly lock Unix files even
   though the locking call succeeds (and indeed blocks local access from
   other NT programs).  If you have direct file access using an NFS
   client or something other than Samba, the locking call might work
   properly - make sure it does before you enable this!

   [18-Feb-97 andrewi] I now believe my comment above to be incorrect,
   since it was based on a misunderstanding of how locking calls are
   implemented and used on Unix.  */
//#define DISABLE_DIRECT_ACCESS

#include <fcntl.h>
#endif /* WINDOWSNT */

#ifdef WINDOWSNT
#include <sys/locking.h>
#endif

/* If your system uses the `flock' or `lockf' system call for mail locking,
   define MAIL_USE_SYSTEM_LOCK.  If your system type should always define
   MAIL_USE_LOCKF or MAIL_USE_FLOCK but configure does not do this,
   please make a bug report.  */

#ifdef MAIL_USE_LOCKF
#define MAIL_USE_SYSTEM_LOCK
#endif

#ifdef MAIL_USE_FLOCK
#define MAIL_USE_SYSTEM_LOCK
#endif

#if (!defined MAIL_USE_SYSTEM_LOCK				\
     && (defined HAVE_LIBMAIL || defined HAVE_LIBLOCKFILE)	\
     && defined HAVE_MAILLOCK_H)
#include <maillock.h>
/* We can't use maillock unless we know what directory system mail
   files appear in. */
#ifdef MAILDIR
#define MAIL_USE_MAILLOCK
static char *mail_spool_name (char *);
#endif
#endif

static _Noreturn void fatal (const char *s1, const char *s2, const char *s3);
static void error (const char *s1, const char *s2, const char *s3);
static _Noreturn void pfatal_with_name (char *name);
static _Noreturn void pfatal_and_delete (char *name);
#ifdef MAIL_USE_POP
static int popmail (char *, char *, bool, char *, bool);
static bool pop_retr (popserver, int, FILE *);
static bool mbx_write (char *, int, FILE *);
static bool mbx_delimit_begin (FILE *);
static bool mbx_delimit_end (FILE *);
#endif

#if (defined MAIL_USE_MAILLOCK						\
     || (!defined DISABLE_DIRECT_ACCESS && !defined MAIL_USE_SYSTEM_LOCK))
/* Like malloc but get fatal error if memory is exhausted.  */

static void * ATTRIBUTE_MALLOC
xmalloc (size_t size)
{
  void *result = malloc (size);
  if (!result)
    fatal ("virtual memory exhausted", 0, 0);
  return result;
}
#endif

/* Nonzero means this is name of a lock file to delete on fatal error.  */
static char *delete_lockname;

int
main (int argc, char **argv)
{
  char *inname, *outname;
  int indesc, outdesc;
  ssize_t nread;
  int wait_status;
  int c;
  bool preserve_mail = false;

#ifndef MAIL_USE_SYSTEM_LOCK
  struct stat st;
  int tem;
  char *tempname;
  size_t inname_len, inname_dirlen;
  int desc;
#endif /* not MAIL_USE_SYSTEM_LOCK */

#ifdef MAIL_USE_POP
  bool pop_reverse_order = false;
# define ARGSTR "pr"
#else /* ! MAIL_USE_POP */
# define ARGSTR "p"
#endif /* MAIL_USE_POP */

  uid_t real_gid = getgid ();
  uid_t priv_gid = getegid ();

  delete_lockname = 0;

  while (0 <= (c = getopt (argc, argv, ARGSTR)))
    {
      switch (c) {
#ifdef MAIL_USE_POP
      case 'r':
	pop_reverse_order = true;
	break;
#endif
      case 'p':
	preserve_mail = true;
	break;
      default:
	return EXIT_FAILURE;
      }
    }

  if (
#ifdef MAIL_USE_POP
      (argc - optind < 2) || (argc - optind > 3)
#else
      (argc - optind != 2)
#endif
      )
    {
#ifdef MAIL_USE_POP
      fprintf (stderr, "Usage: movemail [-p] [-r] inbox destfile%s\n",
	       " [POP-password]");
#else
      fprintf (stderr, "Usage: movemail [-p] inbox destfile%s\n", "");
#endif
      return EXIT_FAILURE;
    }

  inname = argv[optind];
  outname = argv[optind+1];

  if (*outname == 0)
    fatal ("Destination file name is empty", 0, 0);

#ifdef MAIL_USE_POP
  if (!strncmp (inname, "po:", 3))
    {
      int status;

      status = popmail (inname + 3, outname, preserve_mail,
			(argc - optind == 3) ? argv[optind+2] : NULL,
			pop_reverse_order);
      return status;
    }

  if (setuid (getuid ()) < 0)
    fatal ("Failed to drop privileges", 0, 0);

#endif /* MAIL_USE_POP */

#ifndef DISABLE_DIRECT_ACCESS

  char *lockname = 0;
  char *spool_name = 0;

#ifdef MAIL_USE_MAILLOCK
  spool_name = mail_spool_name (inname);
#endif
  if (! spool_name)
    {
#ifndef MAIL_USE_SYSTEM_LOCK
      /* Use a lock file named after our first argument with .lock appended:
	 If it exists, the mail file is locked.  */
      /* Note: this locking mechanism is *required* by the mailer
	 (on systems which use it) to prevent loss of mail.

	 On systems that use a lock file, extracting the mail without locking
	 WILL occasionally cause loss of mail due to timing errors!

	 So, if creation of the lock file fails due to access
	 permission on the mail spool directory, you simply MUST
	 change the permission and/or make movemail a setgid program
	 so it can create lock files properly.

	 You might also wish to verify that your system is one which
	 uses lock files for this purpose.  Some systems use other methods.  */

      bool lockname_unlinked = false;
      inname_len = strlen (inname);
      lockname = xmalloc (inname_len + sizeof ".lock");
      strcpy (lockname, inname);
      strcpy (lockname + inname_len, ".lock");
      for (inname_dirlen = inname_len;
	   inname_dirlen && !IS_DIRECTORY_SEP (inname[inname_dirlen - 1]);
	   inname_dirlen--)
	continue;
      tempname = xmalloc (inname_dirlen + sizeof "EXXXXXX");

      while (true)
	{
	  /* Create the lock file, but not under the lock file name.  */
	  /* Give up if cannot do that.  */

	  memcpy (tempname, inname, inname_dirlen);
	  strcpy (tempname + inname_dirlen, "EXXXXXX");
	  desc = mkostemp (tempname, O_BINARY);
	  if (desc < 0)
	    {
	      int mkostemp_errno = errno;
	      error ("error while creating what would become the lock file",
		     0, 0);
	      errno = mkostemp_errno;
	      pfatal_with_name (tempname);
	    }
	  close (desc);

	  tem = link (tempname, lockname);

	  if (tem < 0 && errno != EEXIST)
	    pfatal_with_name (lockname);

	  unlink (tempname);
	  if (tem >= 0)
	    break;
	  sleep (1);

	  /* If lock file is five minutes old, unlock it.
	     Five minutes should be good enough to cope with crashes
	     and wedgitude, and long enough to avoid being fooled
	     by time differences between machines.  */
	  if (!lockname_unlinked
	      && stat (lockname, &st) == 0
	      && st.st_ctime < time (0) - 300)
	    lockname_unlinked = unlink (lockname) == 0 || errno == ENOENT;
	}

      delete_lockname = lockname;
#endif /* not MAIL_USE_SYSTEM_LOCK */
    }

#ifdef SIGCHLD
  signal (SIGCHLD, SIG_DFL);
#endif

  pid_t child = fork ();
  if (child < 0)
    fatal ("Error in fork; %s", strerror (errno), 0);

  if (child == 0)
    {
      int lockcount = 0;
      int status = 0;
#if defined (MAIL_USE_MAILLOCK) && defined (HAVE_TOUCHLOCK)
      time_t touched_lock;
#endif

      if (setuid (getuid ()) < 0 || setregid (-1, real_gid) < 0)
	fatal ("Failed to drop privileges", 0, 0);

#ifdef MAIL_USE_SYSTEM_LOCK
      indesc = open (inname, O_RDWR | O_BINARY);
#else  /* if not MAIL_USE_SYSTEM_LOCK */
      indesc = open (inname, O_RDONLY | O_BINARY);
#endif /* not MAIL_USE_SYSTEM_LOCK */

      if (indesc < 0)
	pfatal_with_name (inname);

      /* Make sure the user can read the output file.  */
      umask (umask (0) & 0377);

      outdesc = open (outname, O_WRONLY | O_BINARY | O_CREAT | O_EXCL, 0666);
      if (outdesc < 0)
	pfatal_with_name (outname);

      if (setregid (-1, priv_gid) < 0)
	fatal ("Failed to regain privileges", 0, 0);

      /* This label exists so we can retry locking
	 after a delay, if it got EAGAIN or EBUSY.  */
    retry_lock:

      /* Try to lock it.  */
#ifdef MAIL_USE_MAILLOCK
      if (spool_name)
	{
	  /* The "-" is to make it a negative number if maillock returns
	     non-zero. */
	  status = - maillock (spool_name, 1);
#ifdef HAVE_TOUCHLOCK
	  touched_lock = time (0);
#endif
	  lockcount = 5;
	}
      else
#endif /* MAIL_USE_MAILLOCK */
	{
#ifdef MAIL_USE_SYSTEM_LOCK
#ifdef MAIL_USE_LOCKF
	  status = lockf (indesc, F_LOCK, 0);
#else /* not MAIL_USE_LOCKF */
#ifdef WINDOWSNT
	  status = locking (indesc, LK_RLCK, -1L);
#else
	  status = flock (indesc, LOCK_EX);
#endif
#endif /* not MAIL_USE_LOCKF */
#endif /* MAIL_USE_SYSTEM_LOCK */
	}

      /* If it fails, retry up to 5 times
	 for certain failure codes.  */
      if (status < 0)
	{
	  if (++lockcount <= 5 && (errno == EAGAIN || errno == EBUSY))
	    {
	      sleep (1);
	      goto retry_lock;
	    }

	  pfatal_with_name (inname);
	}

      {
	char buf[1024];

	while (true)
	  {
	    nread = read (indesc, buf, sizeof buf);
	    if (nread < 0)
	      pfatal_with_name (inname);
	    if (nread != write (outdesc, buf, nread))
	      {
		int saved_errno = errno;
		unlink (outname);
		errno = saved_errno;
		pfatal_with_name (outname);
	      }
	    if (nread < sizeof buf)
	      break;
#if defined (MAIL_USE_MAILLOCK) && defined (HAVE_TOUCHLOCK)
	    if (spool_name)
	      {
		time_t now = time (0);
		if (now - touched_lock > 60)
		  {
		    touchlock ();
		    touched_lock = now;
		  }
	      }
#endif /* MAIL_USE_MAILLOCK */
	  }
      }

      if (fsync (outdesc) != 0 && errno != EINVAL)
	pfatal_and_delete (outname);

      /* Prevent symlink attacks truncating other users' mailboxes */
      if (setregid (-1, real_gid) < 0)
	fatal ("Failed to drop privileges", 0, 0);

      /* Check to make sure no errors before we zap the inbox.  */
      if (close (outdesc) != 0)
	pfatal_and_delete (outname);

#ifdef MAIL_USE_SYSTEM_LOCK
      if (! preserve_mail)
	{
	  if (ftruncate (indesc, 0) != 0)
	    pfatal_with_name (inname);
	}
#endif /* MAIL_USE_SYSTEM_LOCK */

      close (indesc);

#ifndef MAIL_USE_SYSTEM_LOCK
      if (! preserve_mail)
	{
	  /* Delete the input file; if we can't, at least get rid of its
	     contents.  */
#ifdef MAIL_UNLINK_SPOOL
	  /* This is generally bad to do, because it destroys the permissions
	     that were set on the file.  Better to just empty the file.  */
	  if (unlink (inname) < 0 && errno != ENOENT)
#endif /* MAIL_UNLINK_SPOOL */
	    creat (inname, 0600);
	}
#endif /* not MAIL_USE_SYSTEM_LOCK */

      /* End of mailbox truncation */
      if (setregid (-1, priv_gid) < 0)
	fatal ("Failed to regain privileges", 0, 0);

#ifdef MAIL_USE_MAILLOCK
      /* This has to occur in the child, i.e., in the process that
         acquired the lock! */
      if (spool_name)
	mailunlock ();
#endif
      return EXIT_SUCCESS;
    }

  if (waitpid (child, &wait_status, 0) < 0)
    fatal ("Error in waitpid; %s", strerror (errno), 0);
  if (!WIFEXITED (wait_status))
    return EXIT_FAILURE;
  else if (WEXITSTATUS (wait_status) != 0)
    return WEXITSTATUS (wait_status);

  if (lockname)
    unlink (lockname);

#endif /* ! DISABLE_DIRECT_ACCESS */

  return EXIT_SUCCESS;
}

#ifdef MAIL_USE_MAILLOCK
/* This function uses stat to confirm that the mail directory is
   identical to the directory of the input file, rather than just
   string-comparing the two paths, because one or both of them might
   be symbolic links pointing to some other directory. */
static char *
mail_spool_name (char *inname)
{
  struct stat stat1, stat2;
  char *indir, *fname;
  int status;

  if (! (fname = strrchr (inname, '/')))
    return NULL;

  fname++;

  if (stat (MAILDIR, &stat1) < 0)
    return NULL;

  indir = xmalloc (fname - inname + 1);
  memcpy (indir, inname, fname - inname);
  indir[fname-inname] = '\0';


  status = stat (indir, &stat2);

  free (indir);

  if (status < 0)
    return NULL;

  if (stat1.st_dev == stat2.st_dev
      && stat1.st_ino == stat2.st_ino)
    return fname;

  return NULL;
}
#endif /* MAIL_USE_MAILLOCK */

/* Print error message and exit.  */

static void
fatal (const char *s1, const char *s2, const char *s3)
{
  if (delete_lockname)
    unlink (delete_lockname);
  error (s1, s2, s3);
  exit (EXIT_FAILURE);
}

/* Print error message.  `s1' is printf control string, `s2' and `s3'
   are args for it or null. */

static void
error (const char *s1, const char *s2, const char *s3)
{
  fprintf (stderr, "movemail: ");
  if (s3)
    fprintf (stderr, s1, s2, s3);
  else if (s2)
    fprintf (stderr, s1, s2);
  else
    fprintf (stderr, "%s", s1);
  fprintf (stderr, "\n");
}

static void
pfatal_with_name (char *name)
{
  fatal ("%s for %s", strerror (errno), name);
}

static void
pfatal_and_delete (char *name)
{
  const char *s = strerror (errno);
  unlink (name);
  fatal ("%s for %s", s, name);
}

/* This is the guts of the interface to the Post Office Protocol.  */

#ifdef MAIL_USE_POP

#ifndef WINDOWSNT
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#else
#undef _WINSOCKAPI_
#include <winsock.h>
#endif
#include <pwd.h>
#include <string.h>

/*
 * The full valid syntax for a POP mailbox specification for movemail
 * is "po:username:hostname".  The ":hostname" is optional; if it is
 * omitted, the MAILHOST environment variable will be consulted.  Note
 * that by the time popmail() is called the "po:" has been stripped
 * off of the front of the mailbox name.
 *
 * If the mailbox is in the form "po:username:hostname", then it is
 * modified by this function -- the second colon is replaced by a
 * null.
 *
 * Return a value suitable for passing to `exit'.
 */

static int
popmail (char *mailbox, char *outfile, bool preserve, char *password,
	 bool reverse_order)
{
  int nmsgs, nbytes;
  int i;
  int mbfi;
  FILE *mbf;
  popserver server;
  int start, end, increment;
  char *user, *hostname;

  user = mailbox;
  if ((hostname = strchr (mailbox, ':')))
    *hostname++ = '\0';

  server = pop_open (hostname, user, password, POP_NO_GETPASS);
  if (! server)
    {
      error ("Error connecting to POP server: %s", pop_error, 0);
      return EXIT_FAILURE;
    }

  if (pop_stat (server, &nmsgs, &nbytes))
    {
      error ("Error getting message count from POP server: %s", pop_error, 0);
      return EXIT_FAILURE;
    }

  if (!nmsgs)
    {
      pop_close (server);
      return EXIT_SUCCESS;
    }

  mbfi = open (outfile, O_WRONLY | O_BINARY | O_CREAT | O_EXCL, 0666);
  if (mbfi < 0)
    {
      pop_close (server);
      error ("Error in open: %s, %s", strerror (errno), outfile);
      return EXIT_FAILURE;
    }

  if (fchown (mbfi, getuid (), -1) != 0)
    {
      int fchown_errno = errno;
      struct stat st;
      if (fstat (mbfi, &st) != 0 || st.st_uid != getuid ())
	{
	  pop_close (server);
	  error ("Error in fchown: %s, %s", strerror (fchown_errno), outfile);
	  return EXIT_FAILURE;
	}
    }

  mbf = fdopen (mbfi, "wb");
  if (!mbf)
    {
      pop_close (server);
      error ("Error in fdopen: %s", strerror (errno), 0);
      close (mbfi);
      unlink (outfile);
      return EXIT_FAILURE;
    }

  if (reverse_order)
    {
      start = nmsgs;
      end = 1;
      increment = -1;
    }
  else
    {
      start = 1;
      end = nmsgs;
      increment = 1;
    }

  for (i = start; i * increment <= end * increment; i += increment)
    if (! (mbx_delimit_begin (mbf)
	   && pop_retr (server, i, mbf)
	   && mbx_delimit_end (mbf)
	   && fflush (mbf) == 0))
      {
	if (errno)
	  error ("Error in POP retrieving: %s", strerror (errno), 0);
	pop_close (server);
	fclose (mbf);
	return EXIT_FAILURE;
      }

  if (fsync (mbfi) != 0 && errno != EINVAL)
    {
      error ("Error in fsync: %s", strerror (errno), 0);
      fclose (mbf);
      return EXIT_FAILURE;
    }

  if (fclose (mbf) != 0)
    {
      error ("Error in fclose: %s", strerror (errno), 0);
      return EXIT_FAILURE;
    }

  if (! preserve)
    for (i = 1; i <= nmsgs; i++)
      {
	if (pop_delete (server, i))
	  {
	    error ("Error from POP server: %s", pop_error, 0);
	    pop_close (server);
	    return EXIT_FAILURE;
	  }
      }

  if (pop_quit (server))
    {
      error ("Error from POP server: %s", pop_error, 0);
      return EXIT_FAILURE;
    }

  return EXIT_SUCCESS;
}

static bool
pop_retr (popserver server, int msgno, FILE *arg)
{
  char *line;
  int ret;

  if (pop_retrieve_first (server, msgno, &line))
    {
      error ("Error from POP server: %s", pop_error, 0);
      errno = 0;
      return false;
    }

  while ((ret = pop_retrieve_next (server, &line)) >= 0)
    {
      if (! line)
	break;

      if (! mbx_write (line, ret, arg))
	{
	  int write_errno = errno;
	  pop_close (server);
	  errno = write_errno;
	  return false;
	}
    }

  if (ret)
    {
      error ("Error from POP server: %s", pop_error, 0);
      errno = 0;
      return false;
    }

  return true;
}

static bool
mbx_write (char *line, int len, FILE *mbf)
{
#ifdef MOVEMAIL_QUOTE_POP_FROM_LINES
  /* Do this as a macro instead of using strcmp to save on execution time. */
  # define IS_FROM_LINE(a) ((a[0] == 'F')	\
			    && (a[1] == 'r')	\
			    && (a[2] == 'o')	\
			    && (a[3] == 'm')	\
			    && (a[4] == ' '))
  if (IS_FROM_LINE (line))
    {
      if (fputc ('>', mbf) < 0)
	return false;
    }
#endif
  if (line[0] == '\037')
    {
      if (fputs ("^_", mbf) < 0)
	return false;
      line++;
      len--;
    }
  return fwrite (line, 1, len, mbf) == len && 0 <= fputc ('\n', mbf);
}

#ifdef WINDOWSNT
/* Work around MS-Windows lack of support for %e or %T with a
   special-purpose strftime that assumes the exact format that
   movemail uses.  */
static size_t
movemail_strftime (char *s, size_t size, char const *format,
		   struct tm const *tm)
{
  char fmt[size + 6], *q;
  const char *p;

  for (p = format, q = &fmt[0]; *p; )
    {
      if (*p == '%' && p[1] == 'e')
	{
	  memcpy (q, "%d", 2);
	  q += 2;
	  p += 2;
	}
      else if (*p == '%' && p[1] == 'T')
	{
	  memcpy (q, "%H:%M:%S", 8);
	  q += 8;
	  p += 2;
	}
      else if (*p == '%' && p[1] == '%')
	{
	  memcpy (q, p, 2);
	  q += 2;
	  p += 2;
	}
      else
	*q++ = *p++;
    }

  size_t n = strftime (s, size, fmt, tm);
  char *mday = s + sizeof "From movemail Sun Jan " - 1;
  if (*mday == '0')
    *mday = ' ';
  return n;
}
# undef strftime
# define strftime movemail_strftime
#endif

static bool
mbx_delimit_begin (FILE *mbf)
{
  time_t now = current_timespec ().tv_sec;
  struct tm *ltime = localtime (&now);
  if (!ltime)
    return false;

  char fromline[100];
  if (! strftime (fromline, sizeof fromline,
		  "From movemail %a %b %e %T %Y\n", ltime))
    {
      errno = EOVERFLOW;
      return false;
    }
  return 0 <= fputs (fromline, mbf);
}

static bool
mbx_delimit_end (FILE *mbf)
{
  return 0 <= putc ('\n', mbf);
}

#endif /* MAIL_USE_POP */
