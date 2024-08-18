CXX:=g++

CXXFLAGS:= -g -std=c++17

TARGET=mul_virtual.out

SOURCE=mul_virtual.cpp

all:$(TARGET) run

$(TARGET):$(SOURCE)
	@$(CXX) $(CXXFLAGS) $^ -o $@

run:
	@./$(TARGET)

clean:
	rm -rf $(TARGET)