package comicbox.render;

import boxup.Compiler;
import boxup.cli.Writer;
import capsule.Container;
import capsule.ServiceProvider;
import comicbox.core.PluginManager;
import comicbox.generator.PdfGeneratorStream;

class RenderModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map('Compiler<PdfGeneratorStream>').toShared(RenderCompiler);
    container.map(RenderManager).toShared(RenderManager).with(c -> {
      c.map(Writer).toShared(FileWriter);
    });
    container.getMapping(PluginManager).extend(manager -> {
      manager.add(container.get(RenderManager));
      manager;
    });
  }
}
