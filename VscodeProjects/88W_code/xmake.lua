set_project("88W_code")
toolchain("clang")
target("88w_code")
	set_kind("binary")
	add_files("src/*.cpp")
set_kind("binary")

