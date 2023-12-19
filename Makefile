APPNAME ?= proxy-app
SRCDIR ?= .

push-app:
	cf push $(APPNAME) --path $(SRCDIR)

cf-enable-ssh:
	cf enable-ssh $(APPNAME)
	cf restart $(APPNAME)

start-reverse-tunnel:
	$(eval PROXYPORT := $(shell cf ssh $(APPNAME) -c "echo \$$PORT"))
	@echo "--> $(APPNAME) uses port $(PROXYPORT), starting the reverse tunnel shell..."
	@cf ssh -L $(PROXYPORT):localhost:$(PROXYPORT) $(APPNAME) || \
	echo "couldn't start the reverse tunnel, try running \"make cf-enable-ssh\""
