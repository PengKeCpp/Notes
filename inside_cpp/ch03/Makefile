CXX:=g++

CXXFLAGS:=-m32 -g -std=c++17

TARGET=class_size.out

SOURCE=class_size.cpp

all:$(TARGET) run

$(TARGET):$(SOURCE)
	@$(CXX) $(CXXFLAGS) $^ -o $@

run:
	@./$(TARGET)

clean:
	rm -rf $(TARGET)