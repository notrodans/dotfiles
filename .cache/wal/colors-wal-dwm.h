static const char norm_fg[] = "#ddccde";
static const char norm_bg[] = "#131219";
static const char norm_border[] = "#9a8e9b";

static const char sel_fg[] = "#ddccde";
static const char sel_bg[] = "#68688D";
static const char sel_border[] = "#ddccde";

static const char urg_fg[] = "#ddccde";
static const char urg_bg[] = "#633E81";
static const char urg_border[] = "#633E81";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
