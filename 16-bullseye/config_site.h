#ifndef __PJ_CONFIG_SITE_H__
#define __PJ_CONFIG_SITE_H__

/* https://stackoverflow.com/questions/39275328/asterisk-13-10-pjsip-webrtc-rx-buffer-overflow-pjsip-erxoverflow */

#define PJ_ICE_MAX_CAND 32
#define PJ_ICE_MAX_CHECKS (PJ_ICE_MAX_CAND * 16)
#define PJSIP_MAX_PKT_LEN 12288

#endif /* __PJ_CONFIG_SITE_H__ */