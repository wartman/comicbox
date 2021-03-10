package comicbox.preview;

import capsule.Container;
import capsule.ServiceProvider;
import comicbox.core.PluginManager;

class PreviewModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map(PreviewManager).toShared(PreviewManager);
    container.getMapping(PluginManager).extend(manager -> {
      manager.add(container.get(PreviewManager));
      manager;
    });
  }
}
