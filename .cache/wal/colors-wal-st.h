const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#131219", /* black   */
  [1] = "#633E81", /* red     */
  [2] = "#68688D", /* green   */
  [3] = "#906DA1", /* yellow  */
  [4] = "#7987A7", /* blue    */
  [5] = "#9196B2", /* magenta */
  [6] = "#ADAFC8", /* cyan    */
  [7] = "#ddccde", /* white   */

  /* 8 bright colors */
  [8]  = "#9a8e9b",  /* black   */
  [9]  = "#633E81",  /* red     */
  [10] = "#68688D", /* green   */
  [11] = "#906DA1", /* yellow  */
  [12] = "#7987A7", /* blue    */
  [13] = "#9196B2", /* magenta */
  [14] = "#ADAFC8", /* cyan    */
  [15] = "#ddccde", /* white   */

  /* special colors */
  [256] = "#131219", /* background */
  [257] = "#ddccde", /* foreground */
  [258] = "#ddccde",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
