//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <clipboard_getter/clipboard_getter_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) clipboard_getter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ClipboardGetterPlugin");
  clipboard_getter_plugin_register_with_registrar(clipboard_getter_registrar);
}
