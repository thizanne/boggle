.PHONY: all
all:
	jbuilder build @install

.PHONY: clean
clean:
	jbuilder clean

.PHONY: doc
doc:
	jbuilder build @doc
