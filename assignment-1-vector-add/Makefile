include ../shared.mk
PROJECTFILE = $(or $(wildcard assignment*.cu $(EXECUTABLE).cu main.cu), starter.cu)
EXECUTABLE = $(notdir $(PWD))
SUBMITCMD = /scratch/$(CLASS_NAME)_root/$(CLASS_NAME)/shared_data/submit
SUBMITPATH = /scratch/$(CLASS_NAME)_root/$(CLASS_NAME)/all_sub/$(UNIQUE_NAME)
PROJECTNAME = $(shell basename $(PWD))
PROJECTNUM = $(shell echo "$(PROJECTNAME)" | grep -o -E '[0-9]+')

##############TODO###############

# EXECUTABLE = 
# PROJECTFILE = 

#################################

all: tests

SUBMITTEDFILE = $(SUBMITPATH)/assignment-$(PROJECTNUM)/$(UNIQUE_NAME)-assignment-$(PROJECTNUM).cu
$(EXECUTABLE): $(PROJECTFILE)
	sed -i '/#SBATCH --mail-type=BEGIN,END/d' run_tests
	./build $(PROJECTFILE) $(EXECUTABLE)

build: $(EXECUTABLE) $(PROJECTFILE)

tests: $(EXECUTABLE) $(PROJECTFILE)
	@rm -f slurm-*.out
	@sbatch run_tests $(EXECUTABLE) > $(EXECUTABLE).out
	@cat $(EXECUTABLE).out
	@JOBNUM=$$(cat $(EXECUTABLE).out | grep -o -E '[0-9]+'); \
	rm $(EXECUTABLE).out; \
	until [[ -f slurm-$$JOBNUM.out ]]; \
		do echo "waiting for slurm-$$JOBNUM.out"; \
		sleep 1; \
	done; 
	@LASTLINE=`tail -1 slurm-*.out`; 
	@until [[ $$LASTLINE =~ tests\ passed$$ ]]; \
		do echo "waiting for tests to finish: $$LASTLINE"; \
		sleep 1; \
		LASTLINE=`tail -1 slurm-*.out`; \
	done; 
	@cat slurm-*.out

debug: $(EXECUTABLE) $(PROJECTFILE)
	@rm -f slurm-*.out
	@sbatch run_tests $(EXECUTABLE) $(ID) > $(EXECUTABLE).out
	@cat $(EXECUTABLE).out
	@JOBNUM=$$(cat $(EXECUTABLE).out | grep -o -E '[0-9]+'); \
	rm $(EXECUTABLE).out; \
	until [ -f slurm-$$JOBNUM.out ] && [ -s slurm-$$JOBNUM.out ]; \
	do echo "waiting for slurm-$$JOBNUM.out"; \
	sleep 1; \
	done; \
	cat slurm-$$JOBNUM.out

gdb: $(EXECUTABLE) $(PROJECTFILE)
	@echo "Make sure you did salloc and are running on a node with a GPU"
	nvidia-smi
	./debug_gdb $(EXECUTABLE) $(ID)

submit:
	@$(SUBMITCMD) $(PROJECTFILE) $(PROJECTNUM)
	@echo "submitted $$(($$(date +%s) - $$(date +%s -r $(SUBMITTEDFILE)))) seconds ago to project $(PROJECTNUM)"


clean:
	rm -f $(EXECUTABLE)
	rm -rf libwb/build
	rm -f slurm-*.out
	find test -type f -name 'attempt.raw' -delete


define MAKEFILE_HELP
change PROJECTNUM before you start!

*make build* to build your code
*make tests* to run on all tests
*make debug ID=0* to run test 0 only
*make gdb ID=0* to run test 0 in gdb (After salloc a node with GPU!)
*make submit* to submit and check submission
*make clean*
endef
export MAKEFILE_HELP

help:
	@echo "$$MAKEFILE_HELP"
