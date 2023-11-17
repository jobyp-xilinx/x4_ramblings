PY3_VENV:=$(shell echo /proj/x4_runs/Work/`whoami`/_venv_x4_ramblings)
PY_PROGS:=merge_fsdb.py
PROGS:=$(patsubst %.c,%,$(wildcard *.c)) $(patsubst %.py,%,$(PY_PROGS))

.PHONY: all
all: $(PROGS)
	@echo "Copied $^ into $$HOME/bin"
	rm -vf *~
	cp -v $(wildcard *.sh) $$HOME/bin/

% : %.py
	./black.sh $< ;cp $< $$HOME/bin/$@; chmod +x $$HOME/bin/$@

% : %.c
	musl-gcc -static -Wall -Wextra -Werror -std=gnu18 -O2 -g -o $@ $<
	cp $@ $$HOME/bin

.PHONY: dev-tools
dev-tools: requirements.txt
	rm -rf $(PY3_VENV)
	python3.11 -m venv $(PY3_VENV)
	. $(PY3_VENV)/bin/activate; \
        pip install --upgrade pip ; \
        pip install -r requirements.txt

.PHONY: clean
clean:
	@rm -vf $(PROGS) *.o *~




