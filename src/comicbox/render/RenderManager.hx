package comicbox.render;

import vscode.Uri;
import js.node.Fs;
import js.lib.Promise;
import vscode.ExtensionContext;
import boxup.Source;
import boxup.Compiler;
import vscode.TextDocument;
import comicbox.generator.PdfGeneratorStream;
import comicbox.core.Plugin;

using comicbox.Util;
using haxe.io.Path;

class RenderManager implements Plugin {
  final config:ComicboxConfig;
  final compiler:Compiler<PdfGeneratorStream>;

  public function new(config, compiler) {
    this.config = config;
    this.compiler = compiler;
  }

  public function register(context:ExtensionContext) {
    context.subscriptions.push(
      Vscode.commands.registerCommand('comicbox.compile', function () {
        compileDocument(
          Vscode.window.activeTextEditor.document
        );
      })
    );
  }

  public function compileDocument(document:TextDocument) {
    if (!document.isBoxupDocument()) {
      Vscode.window.showErrorMessage('Not a vaid boxup document');
      return;
    }

    var source = new Source(
      document.uri.toString(),
      document.getText()
    );
    
    createUri(source.filename).then(uri -> {
      switch compiler.compile(source) {
        case Some(stream):
          stream.onComplete(chunks -> {
            var fsStream = Fs.createWriteStream(uri.fsPath, { encoding: 'binary' });
            fsStream.on('finish', () -> {
              Vscode.window.showInformationMessage('Exported PDF successfully!');
            });
            fsStream.on('error', (err) -> {
              // if (err.code == "ENOENT"){
              //   Vscode.window.showErrorMessage("Unable to export PDF! The specified location does not exist: " + err.path)
              // } else if (err.code == "EPERM"){
              //   Vscode.window.showErrorMessage("Unable to export PDF! You do not have the permission to write the specified file: " + err.path)
              // } else {
                Vscode.window.showErrorMessage(err.message);
              // }
              trace(err);
            });
            fsStream.on('open', () -> {
              for (chunk in chunks) fsStream.write(chunk, 'base64');
              fsStream.end();
            });
          });
        case None:
      }
    });
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
}
