CXX:=g++

CXXFLAGS:=-std=c++17 -g

SOURCE:=demo.cpp

TARGET:=demo.out

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
