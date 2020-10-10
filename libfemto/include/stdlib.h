#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

__attribute__((noreturn)) void exit(int status);
void _malloc_addblock(void* addr, size_t size);

#ifdef __cplusplus
}
#endif
