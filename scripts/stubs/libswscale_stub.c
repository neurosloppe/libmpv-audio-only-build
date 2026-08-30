#include <libswscale/swscale.h>

static char stub_sink;

SwsContext *sws_alloc_context(void)
{
    return (SwsContext *)(void *)&stub_sink;
}

int sws_init_context(SwsContext *sws_context, SwsFilter *srcFilter, SwsFilter *dstFilter)
{
    return 0;
}

int sws_isSupportedInput(enum AVPixelFormat pix_fmt)
{
    return 1;
}

int sws_isSupportedOutput(enum AVPixelFormat pix_fmt)
{
    return 1;
}

int sws_scale(SwsContext *c, const uint8_t *const srcSlice[],
              const int srcStride[], int srcSliceY, int srcSliceH,
              uint8_t *const dst[], const int dstStride[])
{
    return 0;
}

int sws_setColorspaceDetails(SwsContext *c, const int inv_table[4],
                             int srcRange, const int table[4], int dstRange,
                             int brightness, int contrast, int saturation)
{
    return 0;
}

void sws_freeContext(SwsContext *swsContext)
{
}

const int *sws_getCoefficients(int colorspace)
{
    return 0;
}

SwsFilter *sws_getDefaultFilter(float lumaGBlur, float chromaGBlur,
                                float lumaSharpen, float chromaSharpen,
                                float chromaHShift, float chromaVShift,
                                int verbose)
{
    return 0;
}

void sws_freeFilter(SwsFilter *filter)
{
}

unsigned swscale_version(void)
{
    return LIBSWSCALE_VERSION_INT;
}
