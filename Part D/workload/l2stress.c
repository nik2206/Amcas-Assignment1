// l2stress.c
// Generates a memory-access pattern with a working set much larger than
// typical L1/L2 cache sizes, so a good fraction of accesses become L2
// misses that reach the memory controller. Three phases are included:
//   1. Sequential sweep      -> good row-buffer locality (spatial reuse)
//   2. Strided sweep         -> adversarial for row-buffer (row-conflict prone)
//   3. Pseudo-random access  -> exercises many banks/rows, low locality
//
// Compile statically for gem5 SE mode:
//   gcc -O1 -static -o l2stress l2stress.c
//
// -O1 (not -O2/-O3) is used deliberately so the compiler does not vectorize
// or unroll the loops so aggressively that it hides individual load/store
// accesses or optimizes away the sweep. volatile is used to force real
// memory traffic.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define ARRAY_BYTES   (32UL * 1024 * 1024)      // 32 MiB working set
#define ARRAY_ELEMS   (ARRAY_BYTES / sizeof(uint64_t))
#define CACHELINE_ELEMS (64 / sizeof(uint64_t))  // 64B line = 8 uint64_t

static uint64_t buf[ARRAY_ELEMS];

// Simple xorshift PRNG (no library call overhead, deterministic across runs)
static inline uint64_t xorshift64(uint64_t *state) {
    uint64_t x = *state;
    x ^= x << 13;
    x ^= x >> 7;
    x ^= x << 17;
    *state = x;
    return x;
}

int main(void) {
    volatile uint64_t sink = 0;
    uint64_t rng_state = 0x123456789abcdefULL;

    // ---- Phase 1: sequential sweep (write then read), full array ----
    for (size_t i = 0; i < ARRAY_ELEMS; i += CACHELINE_ELEMS) {
        buf[i] = i;               // write, one per cache line
    }
    for (size_t i = 0; i < ARRAY_ELEMS; i += CACHELINE_ELEMS) {
        sink += buf[i];           // read, one per cache line
    }

    // ---- Phase 2: strided sweep, stride chosen to land on different
    //      rows of the same bank on a typical DDR4 mapping, forcing
    //      row conflicts. Row size is commonly 8KiB (2^13 B); use a
    //      stride of 8KiB / sizeof(uint64_t) elements, repeated many times
    //      over a smaller window so it wraps and re-touches rows. ----
    {
        const size_t stride_elems = 8192 / sizeof(uint64_t); // 8KiB stride
        const size_t window_elems = ARRAY_ELEMS;              // wrap within full buffer
        size_t idx = 0;
        for (int rep = 0; rep < 4; rep++) {
            for (size_t i = 0; i < 200000; i++) {
                idx = (idx + stride_elems) % window_elems;
                buf[idx] ^= (uint64_t)i;
                sink += buf[idx];
            }
        }
    }

    // ---- Phase 3: pseudo-random access across the whole array ----
    for (size_t i = 0; i < 400000; i++) {
        uint64_t r = xorshift64(&rng_state);
        size_t idx = r % ARRAY_ELEMS;
        buf[idx] += r;
        sink += buf[idx];
    }

    printf("sink=%lu\n", (unsigned long)sink);
    return 0;
}