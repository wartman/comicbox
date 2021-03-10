package comicbox.core;

import capsule.Container;
import capsule.ServiceProvider;

class PluginModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map(PluginManager).toShared(PluginManager);
  }
}
