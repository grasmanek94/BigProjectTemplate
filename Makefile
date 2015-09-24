empty:=

#config here
CFLAGS_RELEASE=-O3 -ggdb3
CFLAGS_DEBUG=-O0 -ggdb3 -Wall
CFLAGS_X86=-m32
CFLAGS_X64=-m64
CFLAGS_COMBINED_RELEASE_X86=$(CFLAGS_RELEASE) $(CFLAGS_X86)
CFLAGS_COMBINED_RELEASE_X64=$(CFLAGS_RELEASE) $(CFLAGS_X64)
CFLAGS_COMBINED_DEBUG_X86=$(CFLAGS_DEBUG) $(CFLAGS_X86)
CFLAGS_COMBINED_DEBUG_X64=$(CFLAGS_DEBUG) $(CFLAGS_X64)
SUFFIX_RELEASE_X86=_REL_x86
SUFFIX_RELEASE_X64=_REL_x64
SUFFIX_DEBUG_X86=_DBG_x86
SUFFIX_DEBUG_X64=_DBG_x64

SUFFIX_SELECTED=
CFLAGS_SELECTED=
#endconfig

NO_CPP_CFLAGS_COMMON=$(CFLAGS_INCLUDE_DIRS) $(CFLAGS_SELECTED)

CFLAGS_STATIC_LIBRARY=-c
CFLAGS_INCLUDE_DIRS=-I.
CFLAGS_COMMON=-std=gnu++14 $(NO_CPP_CFLAGS_COMMON)

GOOGLE_TEST_INCLUDE_DIRS=-I./libraries/googletest -I./libraries/googletest/include
GOOGLE_TEST_SOURCES=./libraries/__linux__/google_test.cc
GOOGLE_TEST_LIBRARY=./libraries/__linux__/obj/google_test$(SUFFIX_SELECTED).o

GOOGLE_MOCK_INCLUDE_DIRS=-I./libraries/googlemock -I./libraries/googlemock/include $(GOOGLE_TEST_INCLUDE_DIRS)
GOOGLE_MOCK_SOURCES=./libraries/__linux__/google_mock.cc
GOOGLE_MOCK_LIBRARY=./libraries/__linux__/obj/google_mock$(SUFFIX_SELECTED).o

GLM_INCLUDE_DIRS=-I./libraries/glm
GLM_SOURCES=./libraries/__linux__/glm.cpp
GLM_LIBRARY=./libraries/__linux__/obj/glm$(SUFFIX_SELECTED).o

SQLITE_INCLUDE_DIRS=-I./libraries/sqlite-amalgamation
SQLITE_SOURCES=./libraries/__linux__/sqlite.c
SQLITE_LIBRARY=./libraries/__linux__/obj/sqlite$(SUFFIX_SELECTED).o

LIBODB_INCLUDE_DIRS=-I./libraries/libodb -I./libraries/__linux__
LIBODB_SOURCES=./libraries/__linux__/libodb.cxx
LIBODB_LIBRARY=./libraries/__linux__/obj/libodb$(SUFFIX_SELECTED).o
LIBODB_DEFINES=-DLIBODB_STATIC_LIB

LIBODB_SQLITE_INCLUDE_DIRS=-I./libraries/libodb -I./libraries/__linux__ -I./libraries/libodb-sqlite/
LIBODB_SQLITE_SOURCES=./libraries/__linux__/libodb-sqlite.cxx
LIBODB_SQLITE_LIBRARY=./libraries/__linux__/obj/libodb-sqlite$(SUFFIX_SELECTED).o
LIBODB_SQLITE_DEFINES=-DLIBODB_STATIC_LIB -DLIBODB_SQLITE_STATIC_LIB

CRYPTOPP_INCLUDE_DIRS=-DCRYPTOPP_DISABLE_ASM -DCRYPTOPP_DISABLE_ASM -DCRYPTOPP_DISABLE_SSSE3 -DCRYPTOPP_DISABLE_AESNI -w
CRYPTOPP_SOURCES= $(shell find ./libraries/cryptopp/ -name '*.cpp' ! -name 'test.cpp')
CRYPTOPP_BASE_DIR =./libraries/__linux__/obj/
CRYPTOPP_OBJ_DIR=$(CRYPTOPP_BASE_DIR)libcryptopp/
CRYPTOPP_OBJECTS = $(addprefix $(CRYPTOPP_OBJ_DIR),$(CRYPTOPP_SOURCES))
CRYPTOPP_LIBRARY=$(CRYPTOPP_BASE_DIR)libcryptopp$(SUFFIX_SELECTED).a

INCLUDE_DIRS_PROJECT=$(GLM_INCLUDE_DIRS) $(SQLITE_INCLUDE_DIRS) $(LIBODB_INCLUDE_DIRS) $(LIBODB_SQLITE_INCLUDE_DIRS) $(CRYPTOPP_INCLUDE_DIRS) -I./project -I./project/lib
COMMON_INCLUDES=$(INCLUDE_DIRS_PROJECT)
COMMON_DEFINITIONS=-DLIBODB_STATIC_LIB -DLIBODB_SQLITE_STATIC_LIB -DLIBODB_MYSQL_STATIC_LIB

LIBPROJECT_INCLUDE_DIRS=$(INCLUDE_DIRS_PROJECT)
LIBPROJECT_SOURCES = $(shell find ./project/lib/ -name '*.c*')
LIBPROJECT_BASE_DIR =./libraries/__linux__/obj/
LIBPROJECT_OBJ_DIR=$(LIBPROJECT_BASE_DIR)libproject/
LIBPROJECT_OBJECTS = $(addprefix $(LIBPROJECT_OBJ_DIR),$(LIBPROJECT_SOURCES))
LIBPROJECT_LIBRARY=$(LIBPROJECT_BASE_DIR)libproject$(SUFFIX_SELECTED).a
LIBPROJECT_DEFINES=$(COMMON_DEFINITIONS)

COMMON_LIBRARIES=$(GLM_LIBRARY) $(SQLITE_LIBRARY) $(LIBODB_LIBRARY) $(LIBODB_SQLITE_LIBRARY) $(LIBPROJECT_LIBRARY) $(CRYPTOPP_LIBRARY) -lpthread -ldl

APP_PROJECT_INCLUDE_DIRS=$(INCLUDE_DIRS_PROJECT)
APP_PROJECT_SOURCES = $(shell find ./project/ ! -path "./project/lib/*" -name '*.c*')
APP_PROJECT_BASE_DIR =./libraries/__linux__/
APP_PROJECT_OBJ_DIR=$(APP_PROJECT_BASE_DIR)obj/project/
APP_PROJECT_OBJECTS = $(addprefix $(APP_PROJECT_OBJ_DIR),$(APP_PROJECT_SOURCES))
APP_PROJECT_EXECUTABLE=$(APP_PROJECT_BASE_DIR)project$(SUFFIX_SELECTED).app
APP_PROJECT_DEFINES=$(COMMON_DEFINITIONS) -DPROJECT_APP
APP_PROJECT_LIBRARIES=$(COMMON_LIBRARIES)

TEST_INCLUDE_DIRS=$(INCLUDE_DIRS_PROJECT) $(GOOGLE_MOCK_INCLUDE_DIRS) 
TEST_SOURCES = $(shell find ./test/ -name '*.c*')
TEST_BASE_DIR =./libraries/__linux__/
TEST_OBJ_DIR=$(TEST_BASE_DIR)obj/test/
TEST_OBJECTS = $(addprefix $(TEST_OBJ_DIR),$(TEST_SOURCES))
TEST_EXECUTABLE=$(TEST_BASE_DIR)test$(SUFFIX_SELECTED).app
TEST_DEFINES=$(COMMON_DEFINITIONS) -DUNIT_TESTING_FRAMEWORK
TEST_LIBRARIES=$(COMMON_LIBRARIES) $(GOOGLE_TEST_LIBRARY) $(GOOGLE_MOCK_LIBRARY)

DEFAULT_CLEARER=

GCC=gcc
GPP=g++

ARCHIVE=ar rvs

all: test

GoogleTest: $(GOOGLE_TEST_SOURCES)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_STATIC_LIBRARY) $(GOOGLE_TEST_INCLUDE_DIRS) $(GOOGLE_TEST_SOURCES) -o $(GOOGLE_TEST_LIBRARY)
	
GoogleMock: $(GOOGLE_MOCK_SOURCES)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_STATIC_LIBRARY) $(GOOGLE_MOCK_INCLUDE_DIRS) $(GOOGLE_MOCK_SOURCES) -o $(GOOGLE_MOCK_LIBRARY)

GLM: $(GLM_SOURCES)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_STATIC_LIBRARY) $(GLM_INCLUDE_DIRS) $(GLM_SOURCES) -o $(GLM_LIBRARY)
	
SQLite: $(SQLITE_SOURCES)
	@$(GCC) $(NO_CPP_CFLAGS_COMMON) $(CFLAGS_STATIC_LIBRARY) $(SQLITE_INCLUDE_DIRS) $(SQLITE_SOURCES) -o $(SQLITE_LIBRARY)

LibODB: $(LIBODB_SOURCES)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_STATIC_LIBRARY) $(LIBODB_DEFINES) $(LIBODB_INCLUDE_DIRS) $(LIBODB_SOURCES) -o $(LIBODB_LIBRARY)

LibODBSQLite: $(LIBODB_SQLITE_SOURCES)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_STATIC_LIBRARY) $(LIBODB_SQLITE_DEFINES) $(LIBODB_SQLITE_INCLUDE_DIRS) $(SQLITE_INCLUDE_DIRS) $(LIBODB_SQLITE_SOURCES) -o $(LIBODB_SQLITE_LIBRARY)

CryptoPP: DEFAULT_CLEARER=$(CRYPTOPP_OBJ_DIR)
CryptoPP: COMMON_INCLUDES=$(CRYPTOPP_INCLUDE_DIRS)
CryptoPP: $(CRYPTOPP_OBJECTS)
	@$(ARCHIVE) $(CRYPTOPP_LIBRARY) $(addsuffix $(SUFFIX_SELECTED).o,$(addprefix ./,$^)) > /dev/null
	
LibProject: DEFAULT_CLEARER=$(LIBPROJECT_OBJ_DIR)
LibProject: COMMON_INCLUDES=$(LIBPROJECT_INCLUDE_DIRS)
LibProject: $(LIBPROJECT_OBJECTS)
	@$(ARCHIVE) $(LIBPROJECT_LIBRARY) $(addsuffix $(SUFFIX_SELECTED).o,$(addprefix ./,$^)) > /dev/null

AppProject: DEFAULT_CLEARER=$(APP_PROJECT_OBJ_DIR)
AppProject: COMMON_INCLUDES=$(APP_PROJECT_INCLUDE_DIRS)
AppProject: $(APP_PROJECT_OBJECTS)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_INCLUDE_DIRS) $(APP_PROJECT_INCLUDE_DIRS) $(addsuffix $(SUFFIX_SELECTED).o,$(addprefix ./,$^)) $(APP_PROJECT_LIBRARIES) -o $(APP_PROJECT_EXECUTABLE)

TestProject: DEFAULT_CLEARER=$(TEST_OBJ_DIR)
TestProject: COMMON_INCLUDES=$(TEST_INCLUDE_DIRS)
TestProject: $(TEST_OBJECTS)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_INCLUDE_DIRS) $(TEST_INCLUDE_DIRS) $(addsuffix $(SUFFIX_SELECTED).o,$(addprefix ./,$^)) $(TEST_LIBRARIES) -o $(TEST_EXECUTABLE)

.DEFAULT:
	@mkdir -p ./$(@D)
	@$(GPP) $(CFLAGS_COMMON) $(CFLAGS_STATIC_LIBRARY) $(CFLAGS_INCLUDE_DIRS) $(COMMON_INCLUDES) ./$(subst $(DEFAULT_CLEARER),$(empty),./$@) -o ./$@$(SUFFIX_SELECTED).o

clean:
	@rm -rf ./libraries/__linux__/obj/*
	@rm -rf ./libraries/__linux__/*.app

d86 test_d86: SUFFIX_SELECTED=$(SUFFIX_DEBUG_X86)
d86 test_d86: CFLAGS_SELECTED=$(CFLAGS_COMBINED_DEBUG_X86)

d64 test_d64: SUFFIX_SELECTED=$(SUFFIX_DEBUG_X64)
d64 test_d64: CFLAGS_SELECTED=$(CFLAGS_COMBINED_DEBUG_X64)

r86 test_r86: SUFFIX_SELECTED=$(SUFFIX_RELEASE_X86)
r86 test_r86: CFLAGS_SELECTED=$(CFLAGS_COMBINED_RELEASE_X86)

r64 test_r64: SUFFIX_SELECTED=$(SUFFIX_RELEASE_X64)
r64 test_r64: CFLAGS_SELECTED=$(CFLAGS_COMBINED_RELEASE_X64)

d86 d64 r86 r64: GoogleTest GoogleMock GLM SQLite LibODB LibODBSQLite CryptoPP LibProject AppProject TestProject

test_d86 test_d64 test_r86 test_r64: GoogleTest GoogleMock GLM SQLite LibODB LibODBSQLite CryptoPP LibProject TestProject
	valgrind $(TEST_EXECUTABLE)
