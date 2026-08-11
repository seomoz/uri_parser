require 'mkmf'

extension_name = 'uri_parser'

$CFLAGS << ' -Wno-deprecated -g '
# icu4c headers require C++17 (LocalPointer uses auto template parameters);
# Ruby >= 3.1's mkmf strips -std= flags passed via --with-cxxflags, so it must
# be set here.
$CXXFLAGS << ' -DUCHAR_TYPE=uint16_t -std=gnu++17 '
# icu headers use reserved user-defined literal syntax; this silence flag is
# clang-only, so keep it off gcc/linux builds.
$CXXFLAGS << ' -Wno-reserved-user-defined-literal ' if RUBY_PLATFORM =~ /darwin/

if RUBY_PLATFORM =~ /linux|darwin/
	$libs << ' -lstdc++'
	$libs << ' -licuuc'
else
  abort <<END_BAD_PLATFORM
+----------------------------------------------------------------------------+
| This gem is for use only on Linux, and Mac OSX                             |
+----------------------------------------------------------------------------+
END_BAD_PLATFORM
end

def failure s
  Logging::message s
  message s+"\n"
  exit(1)
end

# Check for compiler. Extract first word so ENV['CC'] can be a program name with arguments.
cc = (ENV["CC"] or RbConfig::CONFIG["CC"] or "gcc").split(' ').first
unless find_executable(cc)
	failure "No C compiler found in ${ENV['PATH']}. See mkmf.log for details."
end
RbConfig::MAKEFILE_CONFIG['CC'] = cc

def find_library_or_fail(lib,func)
	unless have_library(lib, func)
		failure "Cannot find required library %s (have you installed icu?)" % lib
	end
end

def find_header_or_fail hdr
	unless have_header(hdr)
		failure "Cannot find required header %s (have you installed icu?)" % hdr
	end
end

find_header_or_fail("unicode/ucnv.h")
find_header_or_fail("unicode/ucnv_cb.h")
find_header_or_fail("unicode/uidna.h")

dir_config(extension_name)

create_header
# Namespaced target so the built extension installs as
# uri_parser/uri_parser.<ext>, which is what lib/uri_parser.rb requires.
# Modern RubyGems builds extensions out-of-tree, so the historical reliance
# on a build artifact being left behind in ext/ (reachable via the gemspec's
# `require_paths = %w[lib ext]`) no longer holds.
create_makefile("#{extension_name}/#{extension_name}")
