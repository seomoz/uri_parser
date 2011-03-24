#include "ruby.h"
#include <string>

#include "url_canon_stdstring.h"
#include "url_util.h"

#define ATTR_PORT "port"
#define ATTR_SCHEME "scheme"
#define ATTR_HOST "host"
#define ATTR_PATH "path"
#define ATTR_QUERY "query"
#define ATTR_VALID "valid"
#define ATTR_URI "uri"

extern "C" {
// Defining a space for information and references about the module to be stored internally
static VALUE uri_parser = Qnil;

typedef VALUE (ruby_method_vararg)(...);

// Prototype for the initialization method - Ruby calls this, not you
void Init_uri_parser();

bool canonicalize(const std::string& input_spec,
			std::string* canonical,
			url_parse::Parsed* parsed)
{
	// Reserve enough room in the output for the input, plus some extra so that
	// we have room if we have to escape a few things without reallocating.
	canonical->reserve(input_spec.size() + 32);
	url_canon::StdStringCanonOutput output(canonical);
	bool success = url_util::Canonicalize(
		input_spec.data(), static_cast<int>(input_spec.length()),
		NULL, &output, parsed);
	output.Complete();  // Must be done before using string.
	return success;
}


// Returns the substring of the input identified by the given component.
VALUE component_rb_str(std::string& url, const url_parse::Component& comp)
{
	if (comp.len <= 0)
		return rb_str_new2("");
	else 
		return rb_str_new2(std::string(url, comp.begin, comp.len).c_str());
}

VALUE uri_parser_valid(VALUE self)
{ 
	return rb_iv_get(self, "@"ATTR_VALID);
}

VALUE uri_parser_initialize(VALUE self, VALUE in)
{ 
	std::string url(rb_string_value_ptr(&in));
	std::string canonical;
	url_parse::Parsed parsed;
	
	bool valid = canonicalize(url, &canonical, &parsed);

	rb_iv_set(self, "@"ATTR_PORT, component_rb_str(canonical, parsed.port));
	rb_iv_set(self, "@"ATTR_HOST, component_rb_str(canonical, parsed.host));
	rb_iv_set(self, "@"ATTR_PATH, component_rb_str(canonical, parsed.path));
	rb_iv_set(self, "@"ATTR_QUERY, component_rb_str(canonical, parsed.query));
	rb_iv_set(self, "@"ATTR_SCHEME, component_rb_str(canonical, parsed.scheme));
	rb_iv_set(self, "@"ATTR_URI, rb_str_new2(canonical.c_str()));
	rb_iv_set(self, "@"ATTR_VALID, valid ? Qtrue : Qfalse);
	
	return Qtrue;
}

// The initialization method for this module
void Init_uri_parser() {
	uri_parser= rb_define_class("URIParser", rb_cObject);
	rb_define_method(uri_parser, "initialize", (ruby_method_vararg*)uri_parser_initialize, 1);
	rb_define_attr(uri_parser, ATTR_PORT, 1, 0);
	rb_define_attr(uri_parser, ATTR_HOST, 1, 0);
	rb_define_attr(uri_parser, ATTR_PATH, 1, 0);
	rb_define_attr(uri_parser, ATTR_QUERY, 1, 0);
	rb_define_attr(uri_parser, ATTR_SCHEME, 1, 0);
	rb_define_attr(uri_parser, ATTR_URI, 1, 0);
	rb_define_attr(uri_parser, ATTR_VALID, 1, 0);
	rb_define_method(uri_parser, ATTR_VALID"?", (ruby_method_vararg*)uri_parser_valid, 0);
}

}
