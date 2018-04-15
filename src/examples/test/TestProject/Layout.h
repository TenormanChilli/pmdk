#ifndef LAYOUT_H
#define LAYOUT_H

#define LAYOUT_NAME "intro_0" /* will use this in create and open */
#define MAX_BUF_LEN 10 /* maximum length of our buffer */

struct my_root {
	size_t len; /* = strlen(buf) */
	char buf[MAX_BUF_LEN];
};

#endif /* BALL_H_ */