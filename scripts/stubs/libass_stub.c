#include <ass/ass.h>

static char stub_sink;

int ass_library_version(void)
{
    return 0;
}

ASS_Library *ass_library_init(void)
{
    return (ASS_Library *)(void *)&stub_sink;
}

void ass_library_done(ASS_Library *priv)
{
}

void ass_set_fonts_dir(ASS_Library *priv, const char *fonts_dir)
{
}

void ass_set_extract_fonts(ASS_Library *priv, int extract)
{
}

void ass_set_style_overrides(ASS_Library *priv, char **list)
{
}

void ass_set_message_cb(ASS_Library *priv,
                        void (*msg_cb)(int level, const char *fmt,
                                       va_list args, void *data),
                        void *data)
{
}

void ass_add_font(ASS_Library *library, const char *name, const char *data,
                  int data_size)
{
}

ASS_Renderer *ass_renderer_init(ASS_Library *priv)
{
    return (ASS_Renderer *)(void *)&stub_sink;
}

void ass_renderer_done(ASS_Renderer *priv)
{
}

void ass_set_frame_size(ASS_Renderer *priv, int w, int h)
{
}

void ass_set_storage_size(ASS_Renderer *priv, int w, int h)
{
}

void ass_set_shaper(ASS_Renderer *priv, ASS_ShapingLevel level)
{
}

void ass_set_margins(ASS_Renderer *priv, int t, int b, int l, int r)
{
}

void ass_set_use_margins(ASS_Renderer *priv, int use)
{
}

void ass_set_pixel_aspect(ASS_Renderer *priv, double par)
{
}

void ass_set_font_scale(ASS_Renderer *priv, double font_scale)
{
}

void ass_set_hinting(ASS_Renderer *priv, ASS_Hinting ht)
{
}

void ass_set_line_spacing(ASS_Renderer *priv, double line_spacing)
{
}

void ass_set_line_position(ASS_Renderer *priv, double line_position)
{
}

void ass_set_fonts(ASS_Renderer *priv, const char *default_font,
                   const char *config, int update, const char *fallbacks,
                   int flags)
{
}

void ass_set_selective_style_override_enabled(ASS_Renderer *priv, int bits)
{
}

void ass_set_selective_style_override(ASS_Renderer *priv, ASS_Style *style)
{
}

void ass_set_cache_limits(ASS_Renderer *priv, int glyph_max,
                          int bitmap_max_size)
{
}

ASS_Image *ass_render_frame(ASS_Renderer *priv, ASS_Track *track,
                            long long now, int *detect_change)
{
    return 0;
}

ASS_Track *ass_new_track(ASS_Library *priv)
{
    return (ASS_Track *)(void *)&stub_sink;
}

void ass_free_track(ASS_Track *track)
{
}

int ass_alloc_style(ASS_Track *track)
{
    return 0;
}

int ass_alloc_event(ASS_Track *track)
{
    return 0;
}

void ass_free_event(ASS_Track *track, int eid)
{
}

void ass_process_codec_private(ASS_Track *track, const char *data, int size)
{
}

void ass_process_chunk(ASS_Track *track, const char *data, int size,
                       long long timecode, long long duration)
{
}

void ass_process_force_style(ASS_Track *track)
{
}

void ass_set_check_readorder(ASS_Track *track, int check_readorder)
{
}

void ass_configure_prune(ASS_Track *track, long long delay)
{
}

void ass_flush_events(ASS_Track *track)
{
}

int ass_read_styles(ASS_Track *track, const char *fname, const char *codepage)
{
    return 0;
}

int ass_track_set_feature(ASS_Track *track, ASS_Feature feature, int enable)
{
    return 0;
}

long long ass_step_sub(ASS_Track *track, long long now, int movement)
{
    return 0;
}
