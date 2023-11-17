// JMJ

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define X4AM "/proj/x4_runs/Work/common/tools/artefact-manager/x4am.sh"
#define CMD_BUF_SIZE 1024

time_t START_OF_DAY_SEC = 0;
long   START_OF_DAY_NSEC = 0;


static void start_of_day_timestamp(void)
{
	struct timespec ts;

	if (clock_gettime(CLOCK_MONOTONIC, &ts) == -1)
	{
		perror("clock_gettime()");
		exit(EXIT_FAILURE);
	}

	START_OF_DAY_SEC = ts.tv_sec;
	START_OF_DAY_NSEC = ts.tv_nsec;
	return;
}


static void log_info(const char *msg, bool silent)
{
	struct timespec ts;
	time_t tv_sec;
	long tv_nsec;

	if (silent)
		return;
	
	if (clock_gettime(CLOCK_MONOTONIC, &ts) == -1)
	{
		perror("clock_gettime()");
		exit(EXIT_FAILURE);
	}
	
        tv_sec = ts.tv_sec - START_OF_DAY_SEC;
	tv_nsec = ts.tv_nsec - START_OF_DAY_NSEC; 
	printf("[%5jd.%06ld] %s\n", (intmax_t) tv_sec, tv_nsec / 1000, msg);

	return;
}


static void do_cmd(const char *cmd, bool silent)
{
	log_info(cmd, silent);
	system(cmd);
	return;
}


int main(void)
{
	const char *product[] = {
		"mcfw_x4.a0.stage1_veloce",
		"rtl_x4.stage1_veloce",
		"snapper_x4",
		"tools.x86_64",
	};

	char cmd_buf[CMD_BUF_SIZE] = { 0 };
	
	start_of_day_timestamp();
	
	for (size_t i = 0; i < sizeof(product) / sizeof(product[0]); i++)
	{
		snprintf(cmd_buf,
			 (size_t) CMD_BUF_SIZE,
			 "%s build_versions --product %s --report-path | tail -n1 | awk '{ print $1}'",
			 X4AM,
			 product[i]);
		
		do_cmd(cmd_buf, true);
	}
	
	exit(EXIT_SUCCESS);
}
