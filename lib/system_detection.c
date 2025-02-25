#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>

const char *detect_os()
{
#if defined(_WIN32) || defined(__CYGWIN__)
    return "Windows";
#elif defined(__linux__)
    return "Linux";
#elif defined(__APPLE__)
    return "MacOS";
#else
    return "Unsupported OS";
#endif
}

const char *detect_architecture()
{
#if defined(__x86_64__) || defined(_M_X64)
    return "x64";
#elif defined(__i386__) || defined(_M_IX86)
    return "x86";
#elif defined(__arm__) || defined(_M_ARM)
    return "ARM";
#elif defined(__aarch64__) || defined(_M_ARM64)
    return "ARM64";
#else
    return "Unsupported Architecture";
#endif
}

CAMLprim value caml_detect_os(value unit)
{
    CAMLparam0();
    const char *os = detect_os();
    CAMLreturn(caml_copy_string(os));
}

CAMLprim value caml_detect_architecture(value unit)
{
    CAMLparam0();
    const char *arch = detect_architecture();
    CAMLreturn(caml_copy_string(arch));
}
