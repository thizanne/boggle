.PHONY: all
all:
	jbuilder build @install

.PHONY: clean
clean:
	jbuilder clean
	rm boggle.install

.PHONY: doc
doc:
	jbuilder build @doc
