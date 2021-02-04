STATICLIB=test_lib.a
SHARELIB=test_lib.so
LIB:=lib
MAIN:=main
######################################
VPATH=src
OBJDIR = obj
Target:=target
SRCPATH:= $(filter-out src/main.cpp,$(foreach dir,$(VPATH),$(wildcard $(addprefix ${dir}/*,.cpp))))
OBJS:= $(subst src,obj,$(subst .cpp,.o,$(SRCPATH)))


all:$(MAIN)

$(MAIN): src/main.cpp $(STATICLIB)
    @test -d $(Target) | mkdir -p $(Target)
    g++ -o $@ src/main.cpp $(LIB)/$(STATICLIB)
    @mv $(MAIN) $(Target)/

$(OBJS):$(SRCPATH)
    @test -d $(OBJDIR) | mkdir -p $(OBJDIR)
    g++ -c $(SRCPATH)
    @mv *.o $(OBJDIR)/

$(STATICLIB):$(OBJS)
    @test -d $(LIB) | mkdir -p $(LIB)
    ar -q $@ $<
    @mv $@ $(LIB)/
$(SHARELIB):$(SRCPATH)
    @test -d $(LIB) | mkdir -p $(LIB)
    g++ $< -shared -fPIC  -o $@
    @mv $(SHARELIB) $(LIB)/
clean:
    rm $(OBJDIR) -rf
    rm $(LIB) -rf
    rm $(Target) -rf

