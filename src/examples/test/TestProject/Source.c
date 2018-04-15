#include <stdio.h>
#include <string.h>
#include <libpmemobj.h>
#include "Layout.h"


int main(int argc, char *argv[])
{
	const char* path = "/jmajkutewicz_pmem1";

	// path:		path to file
	// layout:		string that identifies the pool
	// poolsize:	PMEMOBJ_MIN_POOL = 8MiB
	// mode:		standard file mode
	PMEMobjpool *pop = pmemobj_create(path, LAYOUT_NAME, PMEMOBJ_MIN_POOL, 0666);
	if (pop == NULL) {
		perror("pmemobj_create");
		return 1;
	}

	// request the root object
	//	PMEMoid - persistent memory pointer; consists of:
	//				* pool_uuid_lo - unique id of the pool
	//				* off - the offset from the start of the pool (not the VAS)
	//	pmemobj_root - returns the root object; takes:
	//				* PMEMobjpool pool
	//				* size - the size of the structure you want as root object
	PMEMoid root = pmemobj_root(pop, sizeof(struct my_root));
	// translate it to a usable, direct pointer.
	//	to get the DIRECT pointer, a simple addition can be performed 
	//		(if you know the virtual address the pool is mapped at):
	//		direct = (void *)((uint64_t)pool + oid.off)
	//	pmemobj_direct - computes the direct pointer, takes:
	//				* PMEMoid - persistent pointer
	//		The pool id is used to figure out where the pool is currently mapped
	//		All open pools are stored in a cuckoo hash table with 2 hashing functions, 
	//		which is used to locate the pool address.
	struct my_root *rootp = pmemobj_direct(root);

	// read string to save
	char buf[MAX_BUF_LEN];
	scanf("%9s", buf);

	// persists the data
	//	The _persist suffixed functions make sure that the range of memory they operate on is flushed
	//	store length for validating string integrity
	//	pmemobj_persist - pmemobj version of pmem_persist; takes:
	//				* PMEMobjpool* pool
	//				* const void *add
	//				* size_t len
	rootp->len = strlen(buf);
	pmemobj_persist(pop, &rootp->len, sizeof(rootp->len));
	pmemobj_memcpy_persist(pop, rootp->buf, buf, rootp->len);

	// release the pool
	pmemobj_close(pop);
	return 0;
}