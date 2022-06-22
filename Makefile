# all:

	# @stow -D ${folder} && stow ${folder}
	# 
	#
SUBDIRS = nvim

.PHONY: all $(SUBDIRS)

all:
	@for dir in ${SUBDIRS}; do $(MAKE) $$dir; done

$(SUBDIRS):
	@echo Installing $@
	@stow -D $@ && stow $@


