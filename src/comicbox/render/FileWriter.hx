package comicbox.render;

import js.lib.Promise;
import vscode.Uri;
import boxup.cli.Writer;

using haxe.io.Path;

class FileWriter implements Writer {
  final config:ComicboxConfig;

  public function new(config) {
    this.config = config;
  }

  function createUri(sourcePath:String):Thenable<Uri> {
    var dest = sourcePath.withoutExtension().withExtension('pdf');
    var uri = Uri.file(dest);
    return if (config.showSaveDialog) Vscode.window.showSaveDialog({
      filters: { 'PDF file': ['pdf'] },
      defaultUri: uri
    }) else {
      Promise.resolve(uri);
    }
  }

  public function write(path:String, content:String) {
    createUri(path).then(uri -> {
      if (uri == null) return;
      // todo
    });
  }
}
