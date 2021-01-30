#include <stdlib.h>
#include <errno.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

#include "macros.h"

size_t file_size(FILE *fd) {
	size_t size = 0L;
	if(!fd) {
		ERR("file descriptor missing: %s", strerror(errno));
		exit(1);
	}
	if(fseek(fd, 0L, SEEK_END)<0) {
		ERR("fseek(end) error in %s: %s",__func__,strerror(errno));
		exit(1);
	}
	size = ftell(fd);
	if(fseek(fd, 0L, SEEK_SET)<0) {
		ERR("fseek(start) error in %s: %s",__func__,strerror(errno));
		exit(1);
	}
	return(size);
}

void file_load(char *dst, size_t size, FILE *fd) {
	char *firstline = NULL;
	size_t offset = 0;
	size_t bytes = 0;

	firstline = malloc(MAX_STRING);
	// skip shebang on firstline
	if(!fgets(firstline, MAX_STRING, fd)) {
		if(errno==0) { // file is empty
			ERR("Error reading, file is empty");
			if(firstline) free(firstline);
			exit(1);
		}
		ERR("Error reading first line: %s", strerror(errno));
		exit(1);
	}
	if(firstline[0]=='#' && firstline[1]=='!') {
		XXX("Skipping shebang");
	} else {
		offset+=strlen(firstline);
		strncpy(dst,firstline,MAX_STRING);
	}

	size_t chunk;
	while(1) {
		chunk = MAX_STRING;
		if( offset+MAX_STRING>MAX_FILE )
			chunk = MAX_FILE-offset-1;
		if(!chunk) {
			XXX("File too big, truncated at maximum supported size");
			break; }
		bytes = fread(&dst[offset],1,chunk,fd);

		if(!bytes) {
			if(feof(fd)) {
				if((fd!=stdin) && (long)offset!=size) {
					ERR("Incomplete file read (%lu of %lu bytes)",
					    offset, size);
				} else {
					XXX("EOF after %lu bytes",offset);
				}
 				dst[offset] = '\0';
				break;
			}
			if(ferror(fd)) {
				ERR("Error in %s: %s",__func__,strerror(errno));
				fclose(fd);
				if(firstline) free(firstline);
				exit(1);
			}
		}
		offset += bytes;
	}
	if(fd!=stdin) fclose(fd);
	XXX("loaded file (%lu bytes)", offset);
	if(firstline) free(firstline);
}
