package comicbox.diagnostic;

import capsule.Container;
import capsule.ServiceProvider;
import comicbox.core.PluginManager;

class DiagnosticModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map(DiagnosticManager).toShared(DiagnosticManager);
    container.getMapping(PluginManager).extend(manager -> {
      manager.add(container.get(DiagnosticManager));
      manager;
    });
  }
}
