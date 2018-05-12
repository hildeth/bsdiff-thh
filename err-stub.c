/* err-stub.c
 *
 * Copyright (c) Synopsys, Inc. All rights reserved worldwide.
 *
 * This file is part of bsdiff-thh, a branch of bsdiff.
 * Refer to LICENSE for copyright permission information.
 *
 * A stub implementation of <err.h> to satisfy its use in bsdiff.
 * <err.h> is a nonstandard BSD extension, so is not available on all platforms.
 */

#include "err-stub.h"

#include <stdio.h> // vfprintf, stderr
#include <stdarg.h> // va_list, etc.
#include <string.h> // strerror, strrchr
#include <errno.h>
#include <stdlib.h> // exit

static const char* prog_name = NULL;

void err_set_prgn(const char* prgn)
{
    const char* slash = strrchr(prgn, '/');
    prog_name = slash ? slash+1 : prgn;
}

void err(int eval, const char* fmt, ...)
{
    if (prog_name) fprintf(stderr, "%s: ", prog_name);
    if (fmt)
    {
        va_list ap;
        va_start(ap, fmt);
        vfprintf(stderr, fmt, ap);
        fprintf(stderr, ": ");
    }
    fprintf(stderr, "%s\n", strerror(errno));
    exit(eval);
}

void errx(int eval, const char* fmt, ...)
{
    if (prog_name) fprintf(stderr, "%s: ", prog_name);
    if (fmt)
    {
        va_list ap;
        va_start(ap, fmt);
        vfprintf(stderr, fmt, ap);
        fprintf(stderr, ": ");
    }
    exit(eval);
}
