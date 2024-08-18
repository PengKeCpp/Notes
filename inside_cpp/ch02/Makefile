CXX:=g++

CXXFLAGS:=-std=c++11 -g -fverbose-asm

SOURCE:=main.cpp

TARGET:=main.out

OUTPUT:=output

CURRENT_DATE:=$(shell date "+%Y-%m-%d %H:%M:%S")

all:$(OUTPUT) $(TARGET) show_date run

$(OUTPUT):
	@mkdir -p $(OUTPUT)

$(TARGET):$(SOURCE)
	@$(CXX) $(CXXFLAGS) $< -o ./$(OUTPUT)/$@

show_date:
	@echo $(CURRENT_DATE)

run:
	@./$(OUTPUT)/$(TARGET)

clean:
	rm -rf $(OUTPUT)