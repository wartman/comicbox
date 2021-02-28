package comicbox;

import vscode.TextDocument;
import haxe.ds.Option;
import vscode.Uri;
import vscode.TextEditor;

using Lambda;

class Util {
  public static function getCurrentDocumentUri():Option<Uri> {
    if (Vscode.window.activeTextEditor != null 
        && isBoxupDocument(Vscode.window.activeTextEditor.document)) {
      return Some(Vscode.window.activeTextEditor.document.uri);
    }
    for (editor in Vscode.window.visibleTextEditors) {
      if (isBoxupDocument(editor.document)) {
        return Some(editor.document.uri);
      }
    }
    return None;
  }

  public static function getEditorByUri(uri:Uri):Null<TextEditor> {
    return Vscode.window.visibleTextEditors
      .find(editor -> editor.document.uri.toString() == uri.toString());
  }

  public static function isBoxupDocument(document:TextDocument) {
    return document.languageId == 'box';
  }
}
