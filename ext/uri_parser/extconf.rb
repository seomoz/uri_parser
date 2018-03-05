require 'mkmf'

extension_name = 'uri_parser'

$CFLAGS << ' -Wno-deprecated -g '
$CXXFLAGS << ' -DUCHAR_TYPE=uint16_t '

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

# Check for compiler. Extract first word so ENV['CC'] can be a program name with arguments.
cc = (ENV["CC"] or RbConfig::CONFIG["CC"] or "gcc").split(' ').first
unless find_executable(cc)
	failure "No C compiler found in ${ENV['PATH']}. See mkmf.log for details."
end
RbConfig::MAKEFILE_CONFIG['CC'] = cc

def failure s
  Logging::message s
  message s+"\n"
  exit(1)
end

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
create_makefile(extension_name)
