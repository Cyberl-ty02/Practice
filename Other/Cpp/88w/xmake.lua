set_project("test01")

set_toolchains("clang")
set_languages("c++17")

target("test01")
	set_kind("binary")
	add_files("src/*.cpp")