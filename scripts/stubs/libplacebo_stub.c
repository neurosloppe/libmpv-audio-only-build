#include <libplacebo/cache.h>
#include <libplacebo/colorspace.h>
#include <libplacebo/dispatch.h>
#include <libplacebo/dither.h>
#include <libplacebo/dummy.h>
#include <libplacebo/filters.h>
#include <libplacebo/gamut_mapping.h>
#include <libplacebo/gpu.h>
#include <libplacebo/log.h>
#include <libplacebo/options.h>
#include <libplacebo/renderer.h>
#include <libplacebo/shaders.h>
#include <libplacebo/swapchain.h>
#include <libplacebo/tone_mapping.h>
#include <libplacebo/utils/dolbyvision.h>
#include <libplacebo/utils/frame_queue.h>
#include <libplacebo/utils/upload.h>

static char stub_sink;

bool pl_bit_encoding_equal(const struct pl_bit_encoding *b1,
                           const struct pl_bit_encoding *b2)
{
    return 0;
}

struct pl_raw_primaries pl_primaries_clip(const struct pl_raw_primaries *src,
                                          const struct pl_raw_primaries *dst)
{
    return (struct pl_raw_primaries){0};
}

bool pl_raw_primaries_similar(const struct pl_raw_primaries *a,
                              const struct pl_raw_primaries *b)
{
    return 0;
}

bool pl_primaries_superset(const struct pl_raw_primaries *a,
                           const struct pl_raw_primaries *b)
{
    return 0;
}

bool pl_primaries_valid(const struct pl_raw_primaries *prim)
{
    return 0;
}

const struct pl_raw_primaries *pl_raw_primaries_get(enum pl_color_primaries prim)
{
    return 0;
}

pl_matrix3x3 pl_get_color_mapping_matrix(const struct pl_raw_primaries *src,
                                         const struct pl_raw_primaries *dst,
                                         enum pl_rendering_intent intent)
{
    return (pl_matrix3x3){0};
}

pl_matrix3x3 pl_get_rgb2xyz_matrix(const struct pl_raw_primaries *prim)
{
    return (pl_matrix3x3){0};
}

pl_matrix3x3 pl_get_xyz2rgb_matrix(const struct pl_raw_primaries *prim)
{
    return (pl_matrix3x3){0};
}

void pl_matrix3x3_mul(pl_matrix3x3 *a, const pl_matrix3x3 *b)
{
}

void pl_matrix3x3_invert(pl_matrix3x3 *mat)
{
}

void pl_transform3x3_invert(pl_transform3x3 *t)
{
}

void pl_chroma_location_offset(enum pl_chroma_location loc, float *x, float *y)
{
}

bool pl_color_repr_equal(const struct pl_color_repr *c1,
                         const struct pl_color_repr *c2)
{
    return 0;
}

void pl_color_repr_merge(struct pl_color_repr *orig,
                         const struct pl_color_repr *update)
{
}

bool pl_color_space_equal(const struct pl_color_space *c1,
                          const struct pl_color_space *c2)
{
    return 0;
}

void pl_color_space_merge(struct pl_color_space *orig,
                          const struct pl_color_space *update)
{
}

void pl_color_space_infer_map(struct pl_color_space *src,
                              struct pl_color_space *dst)
{
}

bool pl_color_space_is_hdr(const struct pl_color_space *csp)
{
    return 0;
}

void pl_color_space_nominal_luma_ex(const struct pl_nominal_luma_params *params)
{
}

float pl_color_transfer_nominal_peak(enum pl_color_transfer trc)
{
    return 0;
}

bool pl_hdr_metadata_contains(const struct pl_hdr_metadata *data,
                              enum pl_hdr_metadata_type type)
{
    return 0;
}

void pl_hdr_metadata_from_dovi_rpu(struct pl_hdr_metadata *out,
                                   const uint8_t *buf, size_t size)
{
}

void pl_frame_from_swapchain(struct pl_frame *out_frame,
                             const struct pl_swapchain_frame *frame)
{
}

void pl_frame_set_chroma_location(struct pl_frame *frame,
                                  enum pl_chroma_location loc)
{
}

void pl_frames_infer_mix(pl_renderer rr, const struct pl_frame_mix *mix,
                         struct pl_frame *target, struct pl_frame *out_ref)
{
}

bool pl_render_image(pl_renderer rr, const struct pl_frame *image,
                     const struct pl_frame *target,
                     const struct pl_render_params *params)
{
    return 0;
}

bool pl_render_image_mix(pl_renderer rr, const struct pl_frame_mix *images,
                         const struct pl_frame *target,
                         const struct pl_render_params *params)
{
    return 0;
}

pl_renderer pl_renderer_create(pl_log log, pl_gpu gpu)
{
    return (pl_renderer)&stub_sink;
}

void pl_renderer_destroy(pl_renderer *rr)
{
}

void pl_renderer_flush_cache(pl_renderer rr)
{
}

bool pl_renderer_get_hdr_metadata(pl_renderer rr,
                                  struct pl_hdr_metadata *metadata)
{
    return 0;
}

pl_fmt pl_find_fmt(pl_gpu gpu, enum pl_fmt_type type, int num_components,
                   int min_depth, int host_bits, enum pl_fmt_caps caps)
{
    return 0;
}

pl_fmt pl_find_named_fmt(pl_gpu gpu, const char *name)
{
    return 0;
}

bool pl_fmt_is_ordered(pl_fmt fmt)
{
    return 0;
}

pl_tex pl_tex_create(pl_gpu gpu, const struct pl_tex_params *params)
{
    return (pl_tex)&stub_sink;
}

void pl_tex_destroy(pl_gpu gpu, pl_tex *tex)
{
}

bool pl_tex_recreate(pl_gpu gpu, pl_tex *tex, const struct pl_tex_params *params)
{
    return 0;
}

void pl_tex_clear(pl_gpu gpu, pl_tex dst, const float color[4])
{
}

void pl_tex_blit(pl_gpu gpu, const struct pl_tex_blit_params *params)
{
}

bool pl_tex_upload(pl_gpu gpu, const struct pl_tex_transfer_params *params)
{
    return 0;
}

bool pl_tex_download(pl_gpu gpu, const struct pl_tex_transfer_params *params)
{
    return 0;
}

pl_buf pl_buf_create(pl_gpu gpu, const struct pl_buf_params *params)
{
    return (pl_buf)&stub_sink;
}

void pl_buf_destroy(pl_gpu gpu, pl_buf *buf)
{
}

void pl_buf_write(pl_gpu gpu, pl_buf buf, size_t buf_offset,
                  const void *data, size_t size)
{
}

bool pl_buf_poll(pl_gpu gpu, pl_buf buf, uint64_t timeout)
{
    return 0;
}

pl_timer pl_timer_create(pl_gpu gpu)
{
    return (pl_timer)&stub_sink;
}

void pl_timer_destroy(pl_gpu gpu, pl_timer *timer)
{
}

uint64_t pl_timer_query(pl_gpu gpu, pl_timer timer)
{
    return 0;
}

pl_pass pl_pass_create(pl_gpu gpu, const struct pl_pass_params *params)
{
    return (pl_pass)&stub_sink;
}

void pl_pass_destroy(pl_gpu gpu, pl_pass *pass)
{
}

void pl_pass_run(pl_gpu gpu, const struct pl_pass_run_params *params)
{
}

int pl_desc_namespace(pl_gpu gpu, enum pl_desc_type type)
{
    return 0;
}

void pl_gpu_flush(pl_gpu gpu)
{
}

void pl_gpu_set_cache(pl_gpu gpu, pl_cache cache)
{
}

pl_log pl_log_create_360(int api_ver, const struct pl_log_params *params)
{
    return (pl_log)&stub_sink;
}

void pl_log_destroy(pl_log *log)
{
}

struct pl_log_params pl_log_update(pl_log log, const struct pl_log_params *params)
{
    return (struct pl_log_params){0};
}

pl_cache pl_cache_create(const struct pl_cache_params *params)
{
    return (pl_cache)&stub_sink;
}

void pl_cache_destroy(pl_cache *c)
{
}

bool pl_swapchain_resize(pl_swapchain sw, int *width, int *height)
{
    return 0;
}

void pl_swapchain_colorspace_hint(pl_swapchain sw,
                                  const struct pl_color_space *csp)
{
}

bool pl_swapchain_start_frame(pl_swapchain sw,
                              struct pl_swapchain_frame *out_frame)
{
    return 0;
}

bool pl_swapchain_submit_frame(pl_swapchain sw)
{
    return 0;
}

void pl_swapchain_destroy(pl_swapchain *sw)
{
}

pl_shader_info pl_shader_info_ref(pl_shader_info info)
{
    return (pl_shader_info)&stub_sink;
}

void pl_shader_info_deref(pl_shader_info *info)
{
}

void pl_mpv_user_shader_destroy(const struct pl_hook **hook)
{
}

const struct pl_hook *pl_mpv_user_shader_parse(pl_gpu gpu, const char *body,
                                               size_t len)
{
    return 0;
}

pl_options pl_options_alloc(pl_log log)
{
    return (pl_options)&stub_sink;
}

void pl_options_free(pl_options *opts)
{
}

bool pl_options_set_str(pl_options opts, const char *key, const char *value)
{
    return 0;
}

struct pl_var_layout pl_std140_layout(size_t offset, const struct pl_var *var)
{
    return (struct pl_var_layout){0};
}

struct pl_var_layout pl_std430_layout(size_t offset, const struct pl_var *var)
{
    return (struct pl_var_layout){0};
}

const struct pl_error_diffusion_kernel *pl_find_error_diffusion_kernel(const char *name)
{
    return 0;
}

const struct pl_filter_function_preset *pl_find_filter_function_preset(const char *name)
{
    return 0;
}

const struct pl_filter_preset *pl_find_filter_preset(const char *name)
{
    return 0;
}

pl_queue pl_queue_create(pl_gpu gpu)
{
    return (pl_queue)&stub_sink;
}

void pl_queue_destroy(pl_queue *queue)
{
}

void pl_queue_push(pl_queue queue, const struct pl_source_frame *frame)
{
}

void pl_queue_reset(pl_queue queue)
{
}

bool pl_queue_peek(pl_queue queue, int idx, struct pl_source_frame *out)
{
    return 0;
}

enum pl_queue_status pl_queue_update(pl_queue queue, struct pl_frame_mix *out_mix,
                                     const struct pl_queue_params *params)
{
    return 0;
}

void pl_lut_free(struct pl_custom_lut **lut)
{
}

struct pl_custom_lut *pl_lut_parse_cube(pl_log log, const char *str, size_t str_len)
{
    return 0;
}

void pl_icc_close(pl_icc_object *icc)
{
}

void pl_icc_profile_compute_signature(struct pl_icc_profile *profile)
{
}

bool pl_icc_update(pl_log log, pl_icc_object *obj,
                   const struct pl_icc_profile *profile,
                   const struct pl_icc_params *params)
{
    return 0;
}

const char *pl_version(void)
{
    return "7.360.1";
}

const struct pl_color_repr pl_color_repr_sdtv = {0};
const struct pl_color_repr pl_color_repr_rgb = {0};
const struct pl_color_space pl_color_space_srgb = {0};
const struct pl_color_space pl_color_space_hdr10 = {0};
const struct pl_hdr_metadata pl_hdr_metadata_empty = {0};
const struct pl_icc_params pl_icc_default_params = {0};
const struct pl_color_map_params pl_color_map_default_params = {0};
const struct pl_filter_config pl_filter_nearest = {0};
const struct pl_filter_config pl_filter_bicubic = {0};
const struct pl_filter_config pl_filter_oversample = {0};
const struct pl_filter_config pl_filter_bilinear = {0};
const struct pl_gamut_map_function pl_gamut_map_linear = {0};
const struct pl_gamut_map_function pl_gamut_map_highlight = {0};
const struct pl_gamut_map_function pl_gamut_map_darken = {0};
const struct pl_gamut_map_function pl_gamut_map_desaturate = {0};
const struct pl_gamut_map_function pl_gamut_map_absolute = {0};
const struct pl_gamut_map_function pl_gamut_map_saturation = {0};
const struct pl_gamut_map_function pl_gamut_map_relative = {0};
const struct pl_gamut_map_function pl_gamut_map_perceptual = {0};
const struct pl_gamut_map_function pl_gamut_map_clip = {0};
const struct pl_tone_map_function pl_tone_map_st2094_40 = {0};
const struct pl_tone_map_function pl_tone_map_st2094_10 = {0};
const struct pl_tone_map_function pl_tone_map_bt2390 = {0};
const struct pl_tone_map_function pl_tone_map_bt2446a = {0};
const struct pl_tone_map_function pl_tone_map_linear = {0};
const struct pl_tone_map_function pl_tone_map_hable = {0};
const struct pl_tone_map_function pl_tone_map_gamma = {0};
const struct pl_tone_map_function pl_tone_map_mobius = {0};
const struct pl_tone_map_function pl_tone_map_reinhard = {0};
const struct pl_tone_map_function pl_tone_map_clip = {0};
const struct pl_tone_map_function pl_tone_map_spline = {0};

pl_fmt pl_plane_find_fmt(pl_gpu gpu, int out_map[4],
                         const struct pl_plane_data *data)
{
    return 0;
}

void pl_rect2df_rotate(pl_rect2df *rc, pl_rotation rot)
{
}

bool pl_upload_plane(pl_gpu gpu, struct pl_plane *out_plane, pl_tex *tex,
                     const struct pl_plane_data *data)
{
    return 0;
}
