package comicbox.provider;

import vscode.Range;
import vscode.Diagnostic;
import vscode.Uri;
import vscode.DiagnosticCollection;
import vscode.ExtensionContext;
import boxup.Error;

using comicbox.Util;

class DiagnosticsProvider {
  final collection:DiagnosticCollection;
  
  public function new() {
    collection = Vscode.languages.createDiagnosticCollection('boxup');
  }

  public function register(context:ExtensionContext) {
    context.subscriptions.push(collection);
  }

  public function clear(uri:Uri) {
    collection.set(uri, []);
  }

  public function remove(uri:Uri) {
    collection.delete(uri);
  }

  public function report(errors:Array<Error>) {
    collection.clear();
    var diags:Map<String, Array<Diagnostic>> = [];
    for (error in errors) {
      var uri = Uri.parse(error.pos.file);
      var path = uri.toString();
      var editor = uri.getEditorByUri();
      
      if (editor == null) return;

      var source = editor.document.getText();
      var pos = error.pos;
      var startLine = 0;
      var endLine = 0;
      var charPos = 0;
      var startChar = 0;
      var endChar = 0;

      while (charPos <= pos.min) {
        charPos++;
        startChar++;
        if (source.charAt(charPos) == '\n') {
          startLine++;
          startChar = -2; // why????
        }
      }

      endLine = startLine;
      endChar = startChar;
      
      while (charPos <= pos.max) {
        charPos++;
        endChar++;
        if (source.charAt(charPos) == '\n') {
          endLine++;
          endChar = 0;
        }
      }

      var range = new Range(startLine, startChar, endLine, endChar);
      var diag = new Diagnostic(range, error.message, Error);

      if (!diags.exists(path)) {
        diags.set(path, []);
      }
      
      diags.get(path).push(diag);
    }
    for (path => ds in diags) {
      collection.set(Uri.parse(path), ds);
    }
  }
}