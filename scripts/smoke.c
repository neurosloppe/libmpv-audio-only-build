#include <mpv/client.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void print_audio_devices(mpv_handle *h)
{
    mpv_node list;
    if (mpv_get_property(h, "audio-device-list", MPV_FORMAT_NODE, &list) < 0)
        return;
    printf("audio devices:\n");
    for (int i = 0; i < list.u.list->num; i++) {
        mpv_node *e = &list.u.list->values[i];
        const char *name = "?";
        const char *desc = "?";
        for (int j = 0; j < e->u.list->num; j++) {
            if (!strcmp(e->u.list->keys[j], "name"))
                name = e->u.list->values[j].u.string;
            else if (!strcmp(e->u.list->keys[j], "description"))
                desc = e->u.list->values[j].u.string;
        }
        printf("  %s  (%s)\n", name, desc);
    }
    mpv_free_node_contents(&list);
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s <media> [ao] [audio-device]\n", argv[0]);
        return 2;
    }
    mpv_handle *h = mpv_create();
    if (!h) {
        fprintf(stderr, "mpv_create failed\n");
        return 1;
    }
    mpv_set_option_string(h, "vo", "null");
    mpv_set_option_string(h, "ao", argc > 2 ? argv[2] : "wasapi");
    if (argc > 3)
        mpv_set_option_string(h, "audio-device", argv[3]);
    mpv_set_option_string(h, "volume", "100");
    mpv_request_log_messages(h, "warn");
    if (mpv_initialize(h) < 0) {
        fprintf(stderr, "mpv_initialize failed\n");
        mpv_terminate_destroy(h);
        return 1;
    }
    char *dev = mpv_get_property_string(h, "audio-device");
    printf("audio-device: %s\n", dev ? dev : "?");
    mpv_free(dev);
    print_audio_devices(h);
    mpv_observe_property(h, 0, "current-ao", MPV_FORMAT_STRING);
    mpv_observe_property(h, 0, "audio-params/samplerate", MPV_FORMAT_STRING);
    mpv_observe_property(h, 0, "audio-params/channel-count", MPV_FORMAT_STRING);
    const char *cmd[] = {"loadfile", argv[1], NULL};
    if (mpv_command(h, cmd) < 0) {
        fprintf(stderr, "loadfile failed\n");
        mpv_terminate_destroy(h);
        return 1;
    }
    int started = 0;
    int idles = 0;
    int ok = 0;
    for (;;) {
        mpv_event *ev = mpv_wait_event(h, 30.0);
        if (ev->event_id == MPV_EVENT_NONE) {
            continue;
        } else if (ev->event_id == MPV_EVENT_START_FILE) {
            started = 1;
        } else if (ev->event_id == MPV_EVENT_PROPERTY_CHANGE) {
            mpv_event_property *p = ev->data;
            if (p->data)
                printf("property %s = %s\n", p->name, (const char *)p->data);
        } else if (ev->event_id == MPV_EVENT_LOG_MESSAGE) {
            mpv_event_log_message *lm = ev->data;
            fprintf(stderr, "[%s] %s", lm->prefix, lm->text);
        } else if (ev->event_id == MPV_EVENT_END_FILE) {
            mpv_event_end_file *ef = ev->data;
            if (ef->reason == MPV_END_FILE_REASON_ERROR)
                fprintf(stderr, "playback error: %s\n", mpv_error_string(ef->error));
            ok = started && ef->reason != MPV_END_FILE_REASON_ERROR;
            break;
        } else if (ev->event_id == MPV_EVENT_IDLE) {
            if (++idles > 1 && !started) {
                fprintf(stderr, "player went idle without starting playback\n");
                break;
            }
        } else if (ev->event_id == MPV_EVENT_SHUTDOWN) {
            break;
        }
    }
    mpv_terminate_destroy(h);
    if (!ok) {
        fprintf(stderr, "smoke test FAILED\n");
        return 1;
    }
    printf("smoke test OK (ao=%s)\n", argc > 2 ? argv[2] : "wasapi");
    return 0;
}
