package comicbox.document;

import comicbox.core.PluginManager;
import capsule.Container;
import capsule.ServiceProvider;

class DocumentModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map(DocumentManager).toShared(DocumentManager);
    container.getMapping(PluginManager).extend(manager -> {
      manager.add(container.get(DocumentManager));
      manager;
    });
  }
}
