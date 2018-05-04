.PHONY: all
all:
	jbuilder build @install

.PHONY: clean
clean:
	jbuilder clean

.PHONY: doc
doc:
	jbuilder build @doc

.PHONY: web
web:
	jbuilder build @web/DEFAULT
