/* err-stub.h
 *
 * Copyright (c) Synopsys, Inc. All rights reserved worldwide.
 *
 * This file is part of bsdiff-thh, a branch of bsdiff.
 * Refer to LICENSE for copyright permission information.
 *
 * A stub implementation of <err.h> to satisfy its use in bsdiff.
 * <err.h> is a nonstandard BSD extension, so is not available on all platforms.
 */

void err_set_prgn(const char* nm);
void err(int eval, const char* fmt, ...) __attribute__ ((__noreturn__));
void errx(int eval, const char* fmt, ...) __attribute__ ((__noreturn__));
